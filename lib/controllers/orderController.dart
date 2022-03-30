import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/model/orderModel.dart';

class Order {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  updateOrder(OrderModel order) async {
    try {
      await _firestore
          .collection("orders")
          .doc(order.uid)
          .update(order.toMap(true, null));
    } catch (e) {
      print(e);
    }
  }

  updateSubs(OrderModel order , date) async {
    try {
      await _firestore.collection("subscribes").doc(order.uid).update(order.toMap(false , date));
      
    } catch (e) {
      print("error :");
      print(e);
    }
  }
}
