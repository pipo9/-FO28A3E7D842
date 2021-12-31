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

  OrderModel order;
  List<ProductModel> toDayproducts = [];
  String _subCurentstatus;

  get subCurentstatus => _subCurentstatus;

  get currentNotifications => notifications;

  set changeCurentOrder(OrderModel order) {
    this.order = order;
    notifyListeners();
  }

  getNotifications() async {
    List<NotificationModel> notifications = [];
    int unseen = 0;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection("notifications")
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

  String onDateSelected(DateTime date) {
    String productStatus = "disabled";
    List<ProductModel> products = [];
    order.products.forEach((product) {
      if (product.status != 'paused') {
        List days = product.days;
        Map dates = product.dates;
        var dateYMD = DateFormat('yyyy-MM-dd').format(date);
        var dateEEE = DateFormat('EEEE').format(date);

        if (dates.containsKey(dateYMD)) {
          productStatus = dates[dateYMD.toString()];
        } else if (product.status == "subscribed" && days.contains(dateEEE)) {
          productStatus = "pending";
        }
        products.add(product);
      }
    });
    toDayproducts = products;
    return productStatus;
  }

  updateProductsStatus(DateTime date, status) {
    var dateYMD = DateFormat('yyyy-MM-dd').format(date);
    order.products.forEach((product) {
      if (product.dates[dateYMD] != "paused") product.dates[dateYMD] = status;
    });
  }

  pushNotification(status) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    await _firestore.collection("notifications").add({
      "body": "Order with ID :${order.id} \n is now prepared",
      "title": "Order Prepared",
      "to": "${order.deliveryId}"
    });
  }
}
