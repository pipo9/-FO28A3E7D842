import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/components/order_product.dart';
import 'package:grocery/controllers/orderController.dart';
import 'package:grocery/controllers/userController.dart';
import 'package:grocery/shared_Pref.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../../const.dart';
import '../../strings.dart';

class OrderDtails extends StatefulWidget {
  @override
  _OrderDtailsState createState() => _OrderDtailsState();
}

class _OrderDtailsState extends State<OrderDtails> {
  int status = 0;
  List<Color> iconsColors = [kColor, klightGrey, klightGrey];
  List<String> ifDeliveyStates = ['processing', 'dispatched', 'delivered'];
  List<Color> ifDeliveryColors = [kBlueAccent.withOpacity(0.2), kColor, kGreen];
  List<IconData> ifDeliveyicons = [
    Icons.loop,
    Icons.local_mall,
    Icons.local_mall
  ];

  List<Color> ifVendorColors = [
    kBlueAccent.withOpacity(0.2),
    kBlueAccent,
    kGreen
  ];
  List<String> ifVendorStates = ['pending', 'processing', 'prepared'];
  List<IconData> ifVendoricons = [
    Icons.pending_actions,
    Icons.loop,
    Icons.local_mall
  ];

  bool loading = false;

  toggleSpinner() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SharedData _sharedData = Provider.of<SharedData>(context, listen: false);
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    SharedData.context = context;
    switch (_sharedData.order.situation) {
      case 'delivered':
        {
          setState(() {
            status = 2;
          });
          break;
        }
      case 'rejected':
        {
          setState(() {
            status = 2;
          });
          break;
        }
      case 'pending':
        {
          setState(() {
            status = 0;
          });
          break;
        }
      case 'processing':
        {
          setState(() {
            status = SharedData.user.role == 'delivery' ? 0 : 1;
          });
          break;
        }
      case 'dispatched':
        {
          setState(() {
            status = SharedData.user.role == 'delivery' ? 1 : 2;
          });
          break;
        }
      case 'prepared':
        {
          setState(() {
            status = SharedData.user.role == 'delivery' ? 0 : 2;
          });
          break;
        }

        break;
      default:
        {
          setState(() {
            status = 0;
          });
          break;
        }
    }

    return Scaffold(
      backgroundColor: klightGrey,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: _height * 0.11,
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Image.asset(
            "assets/images/logo.png",
            color: kColor,
            height: 37,
            width: 58,
          ),
        ),
        backgroundColor: klightGrey,
        title: Text(
          order_title,
          style: GoogleFonts.robotoSlab(
            color: kColor,
            fontSize: _height * 0.028,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ModalProgressHUD(
          inAsyncCall: loading,
          child: SafeArea(
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: _height * 0.05,
                ),
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: _width * 0.08, vertical: _height * 0.03),
                    width: _width,
                    color: kBlueAccent.withOpacity(0.15),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Payment details :",
                              style: GoogleFonts.robotoSlab(
                                color: kDarkText,
                                fontSize: _height * 0.030,
                                fontWeight: FontWeight.w700,
                              )),
                        ),
                        SizedBox(
                          height: _height * 0.02,
                        ),
                        Row(
                          children: [
                            Text(
                              "Payment Mode :",
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.020,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: _width * 0.01,
                            ),
                            Text(
                              _sharedData.order.paymentMethod,
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.018,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "QTY :",
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.020,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: _width * 0.01,
                            ),
                            Text(
                              _sharedData.order.products.length.toString(),
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.018,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "TOTAL :",
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.020,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: _width * 0.01,
                            ),
                            Text(
                              "${_sharedData.order.amount}\$",
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.018,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                SizedBox(
                  height: _height * 0.04,
                ),
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: _width * 0.08, vertical: _height * 0.03),
                    width: _width,
                    color: kBlueAccent.withOpacity(0.15),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Delivery details :",
                            style: GoogleFonts.robotoSlab(
                              color: kDarkText,
                              fontSize: _height * 0.030,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _height * 0.02,
                        ),
                        Row(
                          children: [
                            Text(
                              "Name:",
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.020,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: _width * 0.01,
                            ),
                            Text(
                              _sharedData.order.user.fullName,
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.018,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Email :",
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.020,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: _width * 0.01,
                            ),
                            Text(
                              _sharedData.order.user.email,
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.018,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Mobile :",
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.020,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: _width * 0.01,
                            ),
                            Text(
                              _sharedData.order.user.phone,
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.018,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Balance:",
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.020,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: _width * 0.01,
                            ),
                            Text(
                              _sharedData.order.user.wallet["balance"],
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.018,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                   
                        Row(
                          children: [
                            Text(
                              "Delivery Address :",
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.020,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: _width * 0.01,
                            ),
                            Text(
                              _sharedData.order.user.address,
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.018,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                SizedBox(
                  height: _height * 0.04,
                ),
                SizedBox(
                  height: _height * 0.04,
                ),
                SharedData.user.role == "vendor" &&
                            (_sharedData.order.vendorAcceptance == null ||
                                _sharedData.order.vendorAcceptance == false) ||
                        SharedData.user.role == "delivery" &&
                            (_sharedData.order.deliveryAcceptance == null ||
                                _sharedData.order.deliveryAcceptance == false)
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () async {
                              if (SharedData.user.role == "vendor")
                                _sharedData.order.vendorId = '';
                              else
                                _sharedData.order.deliveryId = '';

                              await Order().updateOrder(_sharedData.order);
                              Navigator.pushReplacementNamed(context, '/home');
                              await User().sendEmail("Rejected",
                                  _sharedData.order.id, kAdminEmail);

                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: _height * 0.01,
                                    horizontal: _width * 0.04),
                                decoration: BoxDecoration(
                                  color: kColorRed,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Reject",
                                      style: GoogleFonts.zillaSlab(
                                        fontWeight: FontWeight.w500,
                                        color: klightGrey,
                                        fontSize: _width * 0.04,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          InkWell(
                            onTap: () async {
                              toggleSpinner();
                              setState(() {
                                if (SharedData.user.role == "vendor") {
                                  _sharedData.order.vendorSeen = true;
                                  _sharedData.order.vendorAcceptance = true;
                                } else {
                                  _sharedData.order.deliverySeen = true;
                                  _sharedData.order.deliveryAcceptance = true;
                                }
                              });
                              await Order().updateOrder(_sharedData.order);
                              await User().sendEmail("Accepted",
                                  _sharedData.order.id, kAdminEmail);
                              toggleSpinner();
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: _height * 0.01,
                                    horizontal: _width * 0.04),
                                decoration: BoxDecoration(
                                  color: kGreen,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Accept",
                                      style: GoogleFonts.zillaSlab(
                                        fontWeight: FontWeight.w500,
                                        color: klightGrey,
                                        fontSize: _width * 0.04,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Status",
                            style: GoogleFonts.zillaSlab(
                              fontWeight: FontWeight.w600,
                              color: kColor,
                              fontSize: _height * 0.032,
                            ),
                          ),
                          SharedData.user.role == "delivery"
                              ? InkWell(
                                  onTap: () async {
                                    if (status == 1) {
                                      showConfirmation(context, "Warning",
                                          "do you really want to change the status to Delivred ?",
                                          () async {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        setState(() {
                                          status = (status + 1) % 3;
                                        });
                                        _sharedData.order.situation =
                                            ifDeliveyStates[status];
                                        if (_sharedData.order.paymentMethod ==
                                            'Wallet') {
                                          await User()
                                              .updateWallet(_sharedData.order);
                                        }
                                        await Order()
                                            .updateOrder(_sharedData.order);
                                        await User().sendEmail("Delivered",
                                            _sharedData.order.id, kAdminEmail);
                                      }, () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      });
                                    }
                                    if (status == 0 &&
                                        _sharedData.order.situation ==
                                            'prepared') {
                                      {
                                        setState(() {
                                          status = (status + 1) % 3;
                                          _sharedData.order.situation =
                                              ifDeliveyStates[status];
                                        });
                                        await Order()
                                            .updateOrder(_sharedData.order);
                                      }
                                    }
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: _height * 0.005,
                                          horizontal: _width * 0.04),
                                      decoration: BoxDecoration(
                                        color: ifDeliveryColors[status],
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            ifDeliveyicons[status],
                                            color: iconsColors[status],
                                          ),
                                          SizedBox(
                                            width: _width * 0.04,
                                          ),
                                          Text(
                                            ifDeliveyStates[status],
                                            style: GoogleFonts.zillaSlab(
                                              fontWeight: FontWeight.w500,
                                              color: iconsColors[status],
                                              fontSize: _width * 0.035,
                                            ),
                                          ),
                                        ],
                                      )),
                                )
                              : InkWell(
                                  onTap: () async {
                                    if (status == 1) {
                                      showConfirmation(context, "Warning",
                                          "do you really want to change the status to Prepared ?",
                                          () async {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        setState(() {
                                          status = (status + 1) % 3;
                                          _sharedData.order.situation =
                                              ifVendorStates[status];
                                        });
                                        await Order()
                                            .updateOrder(_sharedData.order);
                                        await User().sendEmail("Prepared",
                                            _sharedData.order.id, kAdminEmail);
                                        await User().sendPushMessage(
                                            _sharedData.order.deliveryId,
                                            _sharedData.order.id , true);
                                      }, () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      });
                                    }
                                    if (status == 0) {
                                      setState(() {
                                        status = (status + 1) % 3;
                                        _sharedData.order.situation =
                                            ifVendorStates[status];
                                      });
                                      await Order()
                                          .updateOrder(_sharedData.order);
                                    }
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: _height * 0.005,
                                          horizontal: _width * 0.04),
                                      decoration: BoxDecoration(
                                        color: ifVendorColors[status],
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            ifVendoricons[status],
                                            color: iconsColors[status],
                                          ),
                                          SizedBox(
                                            width: _width * 0.04,
                                          ),
                                          Text(
                                            ifVendorStates[status],
                                            style: GoogleFonts.zillaSlab(
                                              fontWeight: FontWeight.w500,
                                              color: iconsColors[status],
                                              fontSize: _width * 0.035,
                                            ),
                                          ),
                                        ],
                                      )),
                                )
                        ],
                      ),
                SizedBox(
                  height: _height * 0.06,
                ),
                Column(
                    children: _sharedData.order.products.map((product) {
                  return OrderProduct(
                      imageUrl: product.image,
                      price: product.price,
                      productName: product.name,
                      quantity: product.quantity,
                      days: product.days,
                      simple: true);
                }).toList())
              ],
            )),
          )),
    );
  }
}
