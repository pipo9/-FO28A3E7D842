import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/components/sub_screen_orders.dart';
import 'package:grocery/controllers/userController.dart';
import 'package:grocery/model/notificationModel.dart';
import 'package:grocery/shared_Pref.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../const.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = false;
  TextEditingController searchTextController = new TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int status = 0;
  DateTime time = DateTime.now();
  toggleSpinner() {
    setState(() {
      loading = !loading;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SharedData.context = context;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: klightGrey,
        body: ModalProgressHUD(
            inAsyncCall: loading,
            child: SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _width * 0.02, vertical: _height * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          Navigator.pushNamed(context, "/profile");
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: kDarkGrey,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundImage: AssetImage(
                              "assets/images/delivery.png",
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(32.0))),
                                          content: Container(
                                              height: _height * 0.6,
                                              child: Column(children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    "Date : ${DateFormat('dd-MM-yyyy').format(time)}",
                                                    style:
                                                        GoogleFonts.robotoSlab(
                                                      color: kDarkGrey,
                                                      fontSize: _height * 0.017,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                CalendarDatePicker(
                                                    initialDate: time,
                                                    firstDate: DateTime.utc(
                                                        DateTime.now().year - 2,
                                                        DateTime.now().month,
                                                        1),
                                                    lastDate: DateTime.utc(
                                                        DateTime.now().year + 4,
                                                        DateTime.now().month,
                                                        1),
                                                    onDateChanged: (value) {
                                                      setState(() {
                                                        time = value;
                                                      });
                                                      Navigator.pop(context);
                                                    })
                                              ])));
                                    });
                              },
                              child: Icon(
                                Icons.calendar_today_outlined,
                                size: _width * 0.055,
                                color: kDarkGrey,
                              )),
                          SizedBox(width: _width * 0.05),
                          StreamBuilder(
                              stream: _firestore
                                  .collection("reminders")
                                  .where("to", isEqualTo: SharedData.user.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                var data = snapshot.data;
                                var unseen = [];
                                SharedData.notifications = [];
                                if (data != null) {
                                  for (var notif in data.docs) {
                                    var currentNotif = NotificationModel(notif);
                                    SharedData.notifications.add(currentNotif);
                                  }
                                  for (var notif in SharedData.notifications) {
                                    if (notif.seen == false) {
                                      unseen.add(notif);
                                    }
                                  }
                                  SharedData.notifications.sort(
                                      (notif1, notif2) => notif1.timeStamp
                                          .compareTo(notif2.timeStamp));
                                  SharedData.notifications = List.from(
                                      SharedData.notifications.reversed);
                                }
                                return Badge(
                                  badgeContent: Padding(
                                      padding: EdgeInsets.all(1),
                                      child: Text(
                                        unseen.length.toString(),
                                        style: TextStyle(
                                            fontSize: _width * 0.020,
                                            color: klightGrey),
                                      )),
                                  badgeColor: kColor,
                                  position:
                                      BadgePosition.topEnd(top: 0, end: 3),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(context, '/notif');
                                      },
                                      child: Icon(
                                        Icons.notifications_none,
                                        size: _width * 0.07,
                                        color: kDarkGrey,
                                      )),
                                  padding: EdgeInsets.all(2),
                                );
                              }),
                          SizedBox(width: _width * 0.05),
                          InkWell(
                            onTap: () {
                              signout();
                            },
                            child: Icon(
                              Icons.power_settings_new_outlined,
                              size: _width * 0.075,
                              color: kDarkGrey,
                            ),
                          ),
                          SizedBox(width: _width * 0.02),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SubScreenOrders(status: status, time: time),
                )
              ],
            ))),
        bottomNavigationBar: BottomAppBar(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
                onTap: () {
                  setState(() {
                    status = 0;
                  });
                },
                child: Container(
                  child: Column(
                    children: [
                      Icon(
                        Icons.departure_board_outlined,
                        color: status == 0 ? kBlueAccent : kDarkGrey,
                        size: _height * 0.035,
                      ),
                      Text(
                        "Pending",
                        style: GoogleFonts.robotoSlab(
                          color: status == 0 ? kBlueAccent : kDarkGrey,
                          fontSize: _height * 0.017,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  width: _width * 1 / 2,
                  height: _height * 0.07,
                )),
            InkWell(
              onTap: () {
                setState(() {
                  status = 1;
                });
              },
              child: Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      color: status == 1 ? kBlueAccent : kDarkGrey,
                      size: _height * 0.035,
                    ),
                    Text(
                      "Delivered",
                      style: GoogleFonts.robotoSlab(
                        color: status == 1 ? kBlueAccent : kDarkGrey,
                        fontSize: _height * 0.017,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                width: _width * 1 / 2,
                height: _height * 0.07,
              ),
            )
          ],
        )));
  }

  signout() {
    showConfirmation(context, "Warning", "Do you really want to \n Sign Out ?", () {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushReplacementNamed(context, '/signIn');
      User().signOut();
    }, () {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }
}
