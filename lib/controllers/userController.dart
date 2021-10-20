import 'package:grocery/model/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery/shared_Pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
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

  getUsersInfo(id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(id).get();
      if (doc.data() != null) {
        var user = new UserModel(id, doc.data());
        return user;
      }
    } catch (e) {
      print(e.message);
    }
  }
}
