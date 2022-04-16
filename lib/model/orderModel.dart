import 'package:grocery/controllers/userController.dart';
import 'package:grocery/model/productModel.dart';
import 'package:grocery/model/userModel.dart';
import 'package:intl/intl.dart';

class OrderModel {
  String uid;
  String id;
  String paymentId;
  String amount;
  String phone;
  String localisation;
  List<ProductModel> products = [];
  String situation;
  String paymentMethod;
  String purchasedAt;
  String orderId;
  Map<String, dynamic> coupon;
  Map<String, dynamic> userInfos = {};
  UserModel vendor;
  String vendorId;
  UserModel delivery;
  String deliveryId;
  UserModel user;
  bool vendorAcceptance;
  bool deliveryAcceptance;
  String statusDay;
  bool vendorSeen;
  bool deliverySeen;
  double realOrderPrice = 0.0;

  fromMap(String id, Map<String, dynamic> data, isSimple, time) async {
    var order = new OrderModel();
    order.uid = id;
    order.id = data['orderId'];

    order.vendorSeen = data['vendorSeen'] ?? false;
    order.deliverySeen = data['deliverySeen'] ?? false;
    order.statusDay = data['statusDay'];
    order.situation = data['situation'] ?? "";

     if (isSimple && data.containsKey("user") && situation == "delivered")
      order.user = UserModel(data['userId'], data['user']);
    else {
      order.user = await User().getUsersInfo(data['userId']);
    }
    order.vendor = await User().getUsersInfo(data['vendorId']);
    order.delivery = await User().getUsersInfo(data['deliveryId']);

    order.paymentId = data['paymentId'] ?? "";
    order.vendorAcceptance = data['vendorAcceptance'] ?? false;
    order.deliveryAcceptance = data['deliveryAcceptance'] ?? false;
    order.amount = data['amount'];
    order.phone = data['phone'];
    order.localisation = data['localisation'];

    for (var i = 0; i < data['products'].length; i++) {
      ProductModel productModel = ProductModel(data['products'][i], isSimple);
      order.products.add(productModel);
      realOrderPrice += double.parse(productModel.price) *
          double.parse(productModel.quantity);
    }

    order.paymentMethod = data['paymentMethod'];
    order.purchasedAt = data['purchased_at'] ?? "";
    order.orderId = data['orderId'] ?? "";
    order.coupon = data['coupon'] ?? null;
    order.vendorId = data['vendorId'];
    order.deliveryId = data['deliveryId'];

    order.userInfos = data['userInfos'] ?? {};
    return order;
  }

  Map<String, dynamic> toMap(isSimple, date) {
    List listProducts = [];
    var dateYMD = DateFormat('yyyy-MM-dd').format(date);
    // print(userInfos);
    if (!isSimple &&
        products[0].dates.containsKey(dateYMD) &&
        products[0].dates[dateYMD] != "delivered")
      userInfos[dateYMD] = user.toMap();
    // print(userInfos);

    products.forEach((element) {
      if (element.isSimple)
        listProducts.add(element.simpleToMap());
      else
        listProducts.add(element.subsToMap());
    });

    if (isSimple) {
      if (situation == "delivered")
        return {
          "statusDay": statusDay,
          "products": listProducts,
          "vendorAcceptance": vendorAcceptance,
          "deliveryAcceptance": deliveryAcceptance,
          'vendorId': vendorId,
          'deliveryId': deliveryId,
          'situation': situation,
          'vendorSeen': vendorSeen,
          'deliverySeen': deliverySeen,
          "amount": amount,
        };
      else
        return {
          "statusDay": statusDay,
          "products": listProducts,
          "vendorAcceptance": vendorAcceptance,
          "deliveryAcceptance": deliveryAcceptance,
          'vendorId': vendorId,
          'userInfos': userInfos,
          'deliveryId': deliveryId,
          'situation': situation,
          'vendorSeen': vendorSeen,
          'deliverySeen': deliverySeen,
          "amount": amount,
          "user": user.toMap()
        };
    } else {
      if (products[0].dates.containsKey(dateYMD) &&
          products[0].dates[dateYMD] == "delivered")
        return {
          "statusDay": statusDay,
          "products": listProducts,
          "vendorAcceptance": vendorAcceptance,
          "deliveryAcceptance": deliveryAcceptance,
          'vendorId': vendorId,
          'deliveryId': deliveryId,
          'situation': situation,
          'vendorSeen': vendorSeen,
          'deliverySeen': deliverySeen,
          "amount": amount,
        };
      else
        return {
          "statusDay": statusDay,
          "products": listProducts,
          "vendorAcceptance": vendorAcceptance,
          "deliveryAcceptance": deliveryAcceptance,
          'vendorId': vendorId,
          'userInfos': userInfos,
          'deliveryId': deliveryId,
          'situation': situation,
          'vendorSeen': vendorSeen,
          'deliverySeen': deliverySeen,
          "amount": amount,
        };
    }
  }
}
