import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/components/calendar.dart';
import 'package:grocery/components/order_product.dart';
import 'package:grocery/controllers/orderController.dart';
import 'package:grocery/controllers/userController.dart';
import 'package:grocery/shared_Pref.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../../const.dart';
import '../../strings.dart';

class SubsDetails extends StatefulWidget {
  @override
  _SubsDetailsState createState() => _SubsDetailsState();
}

class _SubsDetailsState extends State<SubsDetails> {
  int status = 0;
  String disabled;
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
  DateTime date = DateTime.now();

  toggleSpinner() {
    setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    SharedData _sharedData = Provider.of<SharedData>(context, listen: false);
    SharedData.context = context;

    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    String state = _sharedData.onDateSelected(date);
    switch (state) {
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
      case 'prepared':
        {
          setState(() {
            status = status = SharedData.user.role == 'delivery' ? 0 : 2;
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
      case 'Not Delivred':
        {
          setState(() {
            status = SharedData.user.role == 'delivery' ? 0 : 1;
          });
          break;
        }

        break;
      case 'paused':
        {
          setState(() {
            status = -1;
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
    disabled = _sharedData.onDateSelected(date);

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
          subscription_title,
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
              children: [
                SizedBox(
                  height: _height * 0.07,
                ),
                CustomizedCalendar(
                  onDateSelected: (value) {
                    setState(() {
                      date = value;
                    });
                  },
                  width: _width,
                  height: _height,
                ),
                SizedBox(
                  height: _height * 0.04,
                ),
                status == -1 || disabled == "disabled"
                    ? Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: _height * 0.13,
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: kColor,
                              size: _height * 0.1,
                            ),
                            SizedBox(
                              height: _height * 0.01,
                            ),
                            Text(
                              "You have No subscription Today",
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.025,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          SharedData.user.role == "vendor" &&
                                      (_sharedData.order.vendorAcceptance ==
                                              null ||
                                          _sharedData.order.vendorAcceptance ==
                                              false) ||
                                  SharedData.user.role == "delivery" &&
                                      (_sharedData.order.deliveryAcceptance ==
                                              null ||
                                          _sharedData
                                                  .order.deliveryAcceptance ==
                                              false)
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        if (SharedData.user.role == "vendor")
                                          _sharedData.order.vendorId = '';
                                        else
                                          _sharedData.order.deliveryId = '';

                                        await Order()
                                            .updateSubs(_sharedData.order);
                                        Navigator.pushReplacementNamed(
                                            context, '/home');
                                        await User().sendEmail("Rejected",
                                            _sharedData.order.id, kAdminEmail);
                                      },
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: _height * 0.01,
                                              horizontal: _width * 0.04),
                                          decoration: BoxDecoration(
                                            color: kColorRed,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                                          if (SharedData.user.role ==
                                              "vendor") {
                                            _sharedData.order.vendorSeen = true;
                                            _sharedData.order.vendorAcceptance =
                                                true;
                                          } else {
                                            _sharedData.order.deliverySeen =
                                                true;
                                            _sharedData.order
                                                .deliveryAcceptance = true;
                                          }
                                        });
                                        await Order()
                                            .updateSubs(_sharedData.order);
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
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                              : DateFormat('yyyy-MM-dd')
                                          .format(date)
                                          .toString()
                                          .compareTo(DateFormat('yyyy-MM-dd')
                                              .format(DateTime.now())
                                              .toString()) <=
                                      0
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
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
                                                    showConfirmation(
                                                        context,
                                                        "Warning",
                                                        "do you really want to change the status to Delivred ?",
                                                        () async {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                      setState(() {
                                                        status =
                                                            (status + 1) % 3;
                                                      });
                                                      _sharedData
                                                          .updateProductsStatus(
                                                              date,
                                                              ifDeliveyStates[
                                                                  status]);
                                                      _sharedData
                                                              .order.situation =
                                                          ifDeliveyStates[
                                                              status];
                                                      await Order().updateSubs(
                                                          _sharedData.order);

                                                      await User().updateWallet(
                                                          _sharedData.order,
                                                          true);

                                                      await User().sendEmail(
                                                          "Delivered",
                                                          _sharedData.order.id,
                                                          kAdminEmail);
                                                    }, () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    });
                                                  }
                                                  if (status == 0 &&
                                                      state == 'prepared') {
                                                    setState(() {
                                                      status = (status + 1) % 3;
                                                    });
                                                    _sharedData
                                                        .updateProductsStatus(
                                                            date,
                                                            ifDeliveyStates[
                                                                status]);
                                                    _sharedData
                                                            .order.situation =
                                                        ifDeliveyStates[status];
                                                    await Order().updateSubs(
                                                        _sharedData.order);
                                                  }
                                                  if (ifDeliveyStates[status] ==
                                                      'dispatched') {
                                                    await User().sendEmail(
                                                        'dispatched',
                                                        _sharedData.order.id,
                                                        kAdminEmail);
                                                  }
                                                },
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                _height * 0.005,
                                                            horizontal:
                                                                _width * 0.04),
                                                    decoration: BoxDecoration(
                                                      color: ifDeliveryColors[
                                                          status],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          ifDeliveyicons[
                                                              status],
                                                          color: iconsColors[
                                                              status],
                                                        ),
                                                        SizedBox(
                                                          width: _width * 0.04,
                                                        ),
                                                        Text(
                                                          ifDeliveyStates[
                                                              status],
                                                          style: GoogleFonts
                                                              .zillaSlab(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: iconsColors[
                                                                status],
                                                            fontSize:
                                                                _width * 0.035,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              )
                                            : InkWell(
                                                onTap: () async {
                                                  if (status == 1) {
                                                    showConfirmation(
                                                        context,
                                                        "Warning",
                                                        "do you really want to change the status to Prepared ?",
                                                        () async {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                      setState(() {
                                                        status =
                                                            (status + 1) % 3;
                                                        _sharedData
                                                            .updateProductsStatus(
                                                                date,
                                                                ifVendorStates[
                                                                    status]);
                                                      });
                                                      _sharedData
                                                              .order.situation =
                                                          ifVendorStates[
                                                              status];
                                                      await Order().updateSubs(
                                                          _sharedData.order);
                                                      await User().sendEmail(
                                                          "Prepared",
                                                          _sharedData.order.id,
                                                          kAdminEmail);
                                                      await User()
                                                          .sendPushMessage(
                                                              _sharedData.order
                                                                  .deliveryId,
                                                              _sharedData
                                                                  .order.id,
                                                              false);
                                                    }, () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    });
                                                  }
                                                  if (status == 0) {
                                                    setState(() {
                                                      status = (status + 1) % 3;
                                                      _sharedData
                                                          .updateProductsStatus(
                                                              date,
                                                              ifVendorStates[
                                                                  status]);
                                                    });
                                                    _sharedData
                                                            .order.situation =
                                                        ifVendorStates[status];

                                                    await Order().updateSubs(
                                                        _sharedData.order);
                                                  }
                                                },
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                _height * 0.005,
                                                            horizontal:
                                                                _width * 0.04),
                                                    decoration: BoxDecoration(
                                                      color: ifVendorColors[
                                                          status],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          ifVendoricons[status],
                                                          color: iconsColors[
                                                              status],
                                                        ),
                                                        SizedBox(
                                                          width: _width * 0.04,
                                                        ),
                                                        Text(
                                                          ifVendorStates[
                                                              status],
                                                          style: GoogleFonts
                                                              .zillaSlab(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: iconsColors[
                                                                status],
                                                            fontSize:
                                                                _width * 0.035,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              )
                                      ],
                                    )
                                  : SizedBox(
                                      height: _height * 0.045,
                                      child: Text(
                                        "You can not change today's Order state",
                                        style: GoogleFonts.robotoSlab(
                                          color: kColor,
                                          fontSize: _height * 0.025,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                          SizedBox(
                            height: _height * 0.02,
                          ),
                          _sharedData.order.user.wallet["balance"] == "0" &&
                                  SharedData.user.role == "delivery"
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _width * 0.08,
                                      vertical: _height * 0.03),
                                  width: _width,
                                  color: kColorRed.withOpacity(0.15),
                                  child: Center(
                                    child: Text(
                                      "please ask user to recharge his/her wallet !!",
                                      style: GoogleFonts.robotoSlab(
                                        color: kColor,
                                        fontSize: _height * 0.018,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              : SizedBox(),
                          SizedBox(
                            height: _height * 0.03,
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: _width * 0.08,
                                  vertical: _height * 0.03),
                              width: _width,
                              color: kBlueAccent.withOpacity(0.15),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Payment details :",
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
                                        _sharedData.order.products.length
                                            .toString(),
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
                                        "Purchased At :",
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
                                        _sharedData.order.purchasedAt
                                            .split(' ')[0],
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
                                        "Order Amount :",
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
                                        "${_sharedData.order.amount}₹",
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
                                        "Saving amount:",
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
                                        "${_sharedData.order.realOrderPrice - double.parse(_sharedData.order.amount)} ₹",
                                        style: GoogleFonts.robotoSlab(
                                          color: kColor,
                                          fontSize: _height * 0.018,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SharedData.user.role == "delivery"
                                      ? Row(
                                          children: [
                                            Text(
                                              "Wallet pending amount:",
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
                                              "${_sharedData.order.user.pendingAmount}₹",
                                              style: GoogleFonts.robotoSlab(
                                                color: kColor,
                                                fontSize: _height * 0.018,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  SharedData.user.role == "delivery"
                                      ? Row(
                                          children: [
                                            Text(
                                              "Total amount to be collected :",
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
                                              _sharedData.order.paymentMethod ==
                                                      "COD"
                                                  ? "${(double.parse(_sharedData.order.amount) + double.parse(_sharedData.order.user.pendingAmount))}₹"
                                                  : "${_sharedData.order.user.pendingAmount}₹",
                                              style: GoogleFonts.robotoSlab(
                                                color: kColor,
                                                fontSize: _height * 0.018,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                ],
                              )),
                          SizedBox(
                            height: _height * 0.04,
                          ),
                          SharedData.user.role == "delivery"
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _width * 0.08,
                                      vertical: _height * 0.03),
                                  width: _width,
                                  color: kBlueAccent.withOpacity(0.15),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Customer delivery details:",
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
                                          InkWell(
                                              onTap: () async {
                                                try {
                                                  await FlutterPhoneDirectCaller
                                                      .callNumber(_sharedData
                                                          .order.user.phone);
                                                } catch (e) {
                                                  showAlert(
                                                      context,
                                                      "Error",
                                                      e.message.toString(),
                                                      true, () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  });
                                                }
                                              },
                                              child: Text(
                                                _sharedData.order.user.phone,
                                                style: GoogleFonts.robotoSlab(
                                                  color: kColor,
                                                  fontSize: _height * 0.018,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              )),
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
                                            _sharedData.order.user
                                                    .wallet["balance"] +
                                                "₹",
                                            style: GoogleFonts.robotoSlab(
                                              color: kColor,
                                              fontSize: _height * 0.018,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          Container(
                                            width: _width * 0.51,
                                            child: Text(
                                              _sharedData.order.user.address,
                                              softWrap: true,
                                              style: GoogleFonts.robotoSlab(
                                                color: kColor,
                                                fontSize: _height * 0.018,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ))
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _width * 0.08,
                                      vertical: _height * 0.03),
                                  width: _width,
                                  color: kBlueAccent.withOpacity(0.15),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "delivery boy details :",
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
                                            _sharedData.order.delivery.fullName,
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
                                            _sharedData.order.delivery.email,
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
                                          InkWell(
                                              onTap: () async {
                                                try {
                                                  await FlutterPhoneDirectCaller
                                                      .callNumber(_sharedData
                                                          .order
                                                          .delivery
                                                          .phone);
                                                } catch (e) {
                                                  showAlert(
                                                      context,
                                                      "Error",
                                                      e.message.toString(),
                                                      true, () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  });
                                                }
                                              },
                                              child: Text(
                                                _sharedData
                                                    .order.delivery.phone,
                                                style: GoogleFonts.robotoSlab(
                                                  color: kColor,
                                                  fontSize: _height * 0.018,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ],
                                  )),
                          SizedBox(
                            height: _height * 0.04,
                          ),
                          _sharedData.order.vendorAcceptance != true ||
                                  SharedData.user.role == "vendor"
                              ? SizedBox()
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _width * 0.08,
                                      vertical: _height * 0.03),
                                  width: _width,
                                  color: kBlueAccent.withOpacity(0.15),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Vendor details :",
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
                                            _sharedData.order.vendor.fullName,
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
                                            _sharedData.order.vendor.email,
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
                                          InkWell(
                                              onTap: () async {
                                                try {
                                                  await FlutterPhoneDirectCaller
                                                      .callNumber(_sharedData
                                                          .order.vendor.phone);
                                                } catch (e) {
                                                  showAlert(
                                                      context,
                                                      "Error",
                                                      e.message.toString(),
                                                      true, () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  });
                                                }
                                              },
                                              child: Text(
                                                _sharedData.order.vendor.phone,
                                                style: GoogleFonts.robotoSlab(
                                                  color: kColor,
                                                  fontSize: _height * 0.018,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              )),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pickup Address :",
                                            style: GoogleFonts.robotoSlab(
                                              color: kColor,
                                              fontSize: _height * 0.020,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            width: _width * 0.01,
                                          ),
                                          Container(
                                            width: _width * 0.51,
                                            child: Text(
                                              _sharedData.order.vendor.address,
                                              softWrap: true,
                                              style: GoogleFonts.robotoSlab(
                                                color: kColor,
                                                fontSize: _height * 0.018,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                          SizedBox(
                            height: _height * 0.04,
                          ),
                          Column(
                              children:
                                  _sharedData.toDayproducts.map((product) {
                            return OrderProduct(
                                imageUrl: product.image,
                                price: product.price,
                                productName: product.name,
                                discount: product.discount,
                                quantity: product.quantity,
                                days: product.days);
                          }).toList())
                        ],
                      )
              ],
            )),
          )),
    );
  }
}
