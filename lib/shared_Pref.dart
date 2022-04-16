import 'package:flutter/cupertino.dart';
import 'package:grocery/model/notificationModel.dart';
import 'package:grocery/model/orderModel.dart';
import 'package:grocery/model/productModel.dart';
import 'package:grocery/model/userModel.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SharedData with ChangeNotifier {
  static UserModel user;
  static BuildContext context;
  static List<NotificationModel> notifications = [];
  static int unreadNotifs = 0;
  List<OrderModel> _orders = [];
  List<OrderModel> _subs = [];

  OrderModel _order;
  List<ProductModel> toDayproducts = [];
  String _subCurentstatus;

  get subCurentstatus => _subCurentstatus;

  get currentNotifications => notifications;

  get order => _order;

  List<OrderModel> get orders {
    return _orders;
  }

  List<OrderModel> get subs {
    return _subs;
  }

  set order(OrderModel order){
    _order = order;
    notifyListeners();
  }

  set orders(List<OrderModel> orders) {
    _orders = orders;
    _orders.sort((b, a) => a.purchasedAt.compareTo(b.purchasedAt));
    notifyListeners();
  }

  set subscribes(List<OrderModel> orders) {
    _subs = orders;
    _subs.sort((b, a) => a.purchasedAt.compareTo(b.purchasedAt));
    notifyListeners();
  }

  getNotifications() async {
    List<NotificationModel> notifications = [];
    int unseen = 0;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection("reminders")
        .where("to", isEqualTo: SharedData.user.uid)
        .get()
        .then((querySnapshot) => {
              for (int i = 0; i < querySnapshot.docs.length; i++)
                {
                  notifications
                      .add(new NotificationModel(querySnapshot.docs[i].data()))
                }
            });
    for (var notif in notifications) {
      if (notif.seen == false) unseen++;
    }
    unreadNotifs = unseen;
    notifications = notifications;
    notifyListeners();
  }

  onDateSelected(DateTime date) {
    var resturnedResult = {};
    String productStatus = "disabled";
    List<ProductModel> products = [];
    _order.products.forEach((product) {
      if (product.status != 'paused') {
        List days = product.days;
        Map dates = product.dates;
        var dateYMD = DateFormat('yyyy-MM-dd').format(date);
        var dateEEE = DateFormat('EEEE').format(date);
        if (product.startDate.compareTo(dateYMD.toString()) <= 0) {
          if (dates.containsKey(dateYMD)) {
            productStatus = dates[dateYMD.toString()];
            if (productStatus == "delivered" &&
                _order.userInfos.containsKey(dateYMD)) {
              //  print("##### test : ${order.userInfos} ");
              //  print("##### test : $dateYMD ");

              resturnedResult["user"] =
                  UserModel(_order.user.uid, _order.userInfos[dateYMD]);
            }
          } else if (product.status == "subscribed" && days.contains(dateEEE)) {
            productStatus = "pending";
          }
          products.add(product);
        }
      }
    });
    toDayproducts = products;

    if (toDayproducts.length == 0) {
      productStatus = "disabled";
    }

    resturnedResult["productStatus"] = productStatus;
    return resturnedResult;
  }

  onDateSelectedSubs(DateTime date, OrderModel order) {
    var response = {};
    var dateYMD = DateFormat('yyyy-MM-dd').format(date);
    var dateEEE = DateFormat('EEEE').format(date);
    bool productStatus = false;
    order.products.forEach((product) {
      if (product.status != 'paused') {
        List days = product.days;
        if (product.startDate.compareTo(dateYMD.toString()) <= 0) {
          if (days.contains(dateEEE)) {
            productStatus = true;
          }
        }
      }
    });

    response["status"] = productStatus;
    if (order.products.isNotEmpty) {
      response["state"] = order.products[0].dates[dateYMD];
    } else {
      response["state"] = "pending";
    }

    return response;
  }

  updateProductsStatus(DateTime date, status) {
    var dateYMD = DateFormat('yyyy-MM-dd').format(date);
    _order.products.forEach((product) {
      if (product.dates[dateYMD] != "paused") product.dates[dateYMD] = status;
    });
  }

  pushNotification(status) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    await _firestore.collection("reminders").add({
      "body": "Order with ID :${_order.id} \n is now prepared",
      "title": "Order Prepared",
      "to": "${_order.deliveryId}"
    });
  }
}
