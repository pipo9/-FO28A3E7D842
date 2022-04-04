import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:grocery/Helpers/Config.dart';
import 'package:grocery/Helpers/HttpClient.dart';
import 'package:grocery/model/orderModel.dart';
import 'package:grocery/model/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery/shared_Pref.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  wasHere() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool wasHere = prefs.getBool('wasHere');
    var returnedValue = wasHere != null ? wasHere : false;
    return returnedValue;
  }

  signIn(email, password) async {
    Map result = Map();
    result['status'] = false;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('wasHere', true);
      await getUserInfo();
      result['status'] = true;
    } catch (e) {
      result["message"] = e.message;
    }

    return result;
  }

  getUserInfo() async {
    try {
      var id = _auth.currentUser.uid;
      DocumentSnapshot doc = await _firestore.collection('users').doc(id).get();
      if (doc.data() != null) {
        var user = new UserModel(id, doc.data());
        SharedData.user = user;
      }
    } catch (e) {
      print(e.message);
    }
  }

  updateUserInfo(email, phone, name) async {
    Map result = Map();
    result['status'] = false;
    SharedData.user.email = email;
    SharedData.user.phone = phone;
    SharedData.user.fullName = name;
    try {
      var id = _auth.currentUser.uid;
      await _firestore
          .collection('users')
          .doc(id)
          .update(SharedData.user.toMap());
      result['status'] = true;
    } catch (e) {
      result["message"] = e.message;
    }
    return result;
  }

  signOut() async {
    _auth.signOut();
    SharedData.user.email = '';
    SharedData.user.phone = '';
    SharedData.user.fullName = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('wasHere', false);
  }

  resetPassword(email) async {
    Map result = Map();
    result['status'] = false;
    try {
      await _auth.sendPasswordResetEmail(email: email);
      result['status'] = true;
    } catch (e) {
      result["message"] = e.message;
    }
    return result;
  }

 Future<UserModel> getUsersInfo(id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(id).get();
      if (doc.data() != null) {
        UserModel user = new UserModel(id, doc.data());         
        return user;
      }
    } catch (e) {
      print("###Error getUserInfo## : $e");
    }
     return null;
  }

  sendEmail(stauts, id, email) async {
    HttpClient httpClient = new HttpClient();
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var body = {"id": id, "status": stauts, "email": email};
    try {
      await httpClient.postRequest(Urls.sendEmail, headers, body);
    } catch (e) {
      print(e);
    }
  }

  saveDeviceToken() async {
    String uid = _auth.currentUser.uid;
    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      var tokens = _firestore.collection('tokens').doc(fcmToken);
      await tokens.set({
        'uid': uid,
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    }
  }

  updateWallet(OrderModel order, deducate) async {
    try {
      if (deducate && order.paymentMethod == "Wallet") {
        var newBalance = double.parse(order.user.wallet["balance"]) -
            double.parse(order.amount);
        order.user.wallet["balance"] = newBalance.toString();
        order.user.wallet["transactions"].add({
          "amount": "-${order.amount}",
          "description": "For order ${order.orderId}",
          "date": DateFormat('dd-MM-yyyy HH:mm:ss.S').format(DateTime.now()),
          "type": "Expense",
          'status': "Completed",
        });
      }
      for (var transaction in order.user.wallet['transactions']) {
        if (transaction["status"] == "pending") {
          transaction["status"] = "completed";
        }
      }
      await _firestore
          .collection('users')
          .doc(order.user.uid)
          .update(order.user.toMap());
      print("##### wallet updated");
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendPushMessage(id, orderId, isOrder) async {
    var type = isOrder == true ? "Order" : "Subscription";
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var body = jsonEncode({
      "notif": {
        "to": "$id",
        "title": "Vendor Notification",
        "body": 'the $type with the id $orderId is now prepared'
      },
      "userId": "$id"
    });
    if (id == "" || id == null) {
      print('Unable to send FCM message, no delivery id exists.');
      return;
    }

    try {
      Response response = await http.post(
        Uri.parse('https://grocurs-admin.herokuapp.com/notifications/send'),
        headers: headers,
        body: body,
      );

      final statusCode = response.statusCode;
      if (statusCode >= 200 && statusCode < 299) {
        print('FCM request for device sent!');
      } else {
        print("Server ERROR***:");
      }
    } on SocketException {
      print("Socket ERROR***:");
    }
  }

  // String constructFCMPayload(String token, id, type) {
  //   return jsonEncode({
  //     'token': token,
  //     'android': {
  //       'priority': "high",
  //     },
  //     'data': {
  //       'via': 'Grocery Delivery App',
  //       'count': 1,
  //     },
  //     'notification': {
  //       'title': 'Vendor Notification',
  //       'body': 'the $type with the id $orderId is now prepared',
  //     },
  //   });
  // }

  // initialise(context) {
  //   if (Platform.isAndroid) {
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       RemoteNotification notification = message.notification;
  //       AndroidNotification android = message.notification?.android;
  //       showNotification(context, notification.title, notification.body, null);
  //     });
  //   }
  // }

  // initializeNotifications(context) async {
  //   await saveDeviceToken();
  //   _onMessageNotification(context);
  //   _onOpenMessageNotification(context);
  // }

  // void _onMessageNotification(context) {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     if (message.notification != null) {
  //       showNotification(context, message.notification.title,
  //           message.notification.body, null);
  //     }
  //   });
  // }

  // void _onOpenMessageNotification(context) {
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     if (message.notification != null) {
  //       showNotification(context, message.notification.title,
  //           message.notification.body, null);
  //     }
  //   });
  // }

  // Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   print('Message on background: ${message.messageId}');
  // }
}
