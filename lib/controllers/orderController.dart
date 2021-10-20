import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/model/orderModel.dart';

class Order {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  updateOrder(OrderModel order) async {
    try {
      await _firestore
          .collection("orders")
          .doc(order.uid)
          .update(order.toMap());
    } catch (e) {
      print(e.message);
    }
  }

  updateSubs(OrderModel order) async {
    try {
      await _firestore.collection("subscribes").doc(order.uid).update(order.toMap());
      
    } catch (e) {
      print("error :");
      print(e);
    }
  }
}