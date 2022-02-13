import 'package:grocery/controllers/userController.dart';
import 'package:grocery/model/productModel.dart';
import 'package:grocery/model/userModel.dart';

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
  double realOrderPrice= 0.0;

  OrderModel(String id, Map<String, dynamic> data) {
    this.uid = id;
    this.id = data['orderId'];
    this.vendorSeen = data['vendorSeen'] ?? false;
    this.deliverySeen = data['deliverySeen'] ?? false;
    this.statusDay = data['statusDay'];

    User().getUsersInfo(data['userId']).then((user) {
      this.user = user;
    });
    User().getUsersInfo(data['vendorId']).then((user) {
      this.vendor = user;
    });
    User().getUsersInfo(data['deliveryId']).then((user) {
      this.delivery = user;
    });
    this.paymentId = data['paymentId'];
    this.vendorAcceptance = data['vendorAcceptance'] ?? false;
    this.deliveryAcceptance = data['deliveryAcceptance'] ?? false;
    this.amount = data['amount'];
    this.phone = data['phone'];
    this.localisation = data['localisation'];

    for (var i = 0; i < data['products'].length; i++) {
      ProductModel productModel = ProductModel(data['products'][i]);
      products.add(productModel);
      realOrderPrice += double.parse(productModel.price) *
              double.parse(productModel.quantity);
    }
    this.situation = data['situation'];
    this.paymentMethod = data['paymentMethod'];
    this.purchasedAt = data['purchased_at'] ?? "";
    this.orderId = data['orderId'] ?? "";
    this.coupon = data['coupon'] ?? null;
    this.vendorId = data['vendorId'];
    this.deliveryId = data['deliveryId'];
    
  }

  Map<String, dynamic> toMap() {
    List listProducts = [];

    products.forEach((element) {
      listProducts.add(element.toMap());
    });
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
      "amount": amount
    };
  }
}
