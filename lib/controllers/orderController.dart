import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/model/orderModel.dart';
import 'package:grocery/shared_Pref.dart';

class Order {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getOrders(time, SharedData _sharedData) async {
    List<OrderModel> orders = [];
    QuerySnapshot ordersSnapshot = await _firestore
        .collection("orders")
        .where(SharedData.user.role == "vendor" ? "vendorId" : "deliveryId",
            isEqualTo: SharedData.user.uid)
        .get();
    ordersSnapshot.docs.forEach((doc) async {
      OrderModel order =
          await OrderModel().fromMap(doc.id, doc.data(), true, time);
      orders.add(order);
      _sharedData.orders = orders;
    });
  }

  getSubs(time, SharedData _sharedData) async {
    List<OrderModel> subs = [];
    QuerySnapshot subSnapshot = await _firestore
        .collection("subscribes")
        .where(SharedData.user.role == "vendor" ? "vendorId" : "deliveryId",
            isEqualTo: SharedData.user.uid)
        .get();
    subSnapshot.docs.forEach((doc) async {
      OrderModel sub =
          await OrderModel().fromMap(doc.id, doc.data(), false, time);
      subs.add(sub);
      _sharedData.subscribes = subs;
    });
  }

  updateOrder(OrderModel order) async {
    try {
      await _firestore
          .collection("orders")
          .doc(order.uid)
          .update(order.toMap(true, DateTime.now()));
    } catch (e) {
      print(e);
    }
  }

  updateSubs(OrderModel order, date) async {
    try {
      await _firestore
          .collection("subscribes")
          .doc(order.uid)
          .update(order.toMap(false, date));
    } catch (e) {
      print("error :");
      print(e);
    }
  }
}
