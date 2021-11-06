import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/components/sub_screen_orders.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../const.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = false;
  TextEditingController searchTextController = new TextEditingController();
  int status = 0;
  DateTime time = DateTime.now();
  toggleSpinner() {
    setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        onTap: () {
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
                                              child: CalendarDatePicker(
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
                                                  })));
                                    });
                              },
                              child: Icon(
                                Icons.calendar_today_outlined,
                                size: _width * 0.055,
                                color: kDarkGrey,
                              )),
                          SizedBox(width: _width * 0.05),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/notif');
                            },
                            child: Icon(
                              Icons.notifications_none,
                              size: _width * 0.07,
                              color: kDarkGrey,
                            ),
                          ),
                          SizedBox(width: _width * 0.05),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/signIn');
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
                  width: _width * 1 / 3,
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
                      Icons.loop,
                      color: status == 1 ? kBlueAccent : kDarkGrey,
                      size: _height * 0.035,
                    ),
                    Text(
                      "Processing",
                      style: GoogleFonts.robotoSlab(
                        color: status == 1 ? kBlueAccent : kDarkGrey,
                        fontSize: _height * 0.017,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                width: _width * 1 / 3,
                height: _height * 0.07,
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  status = 2;
                });
              },
              child: Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      color: status == 2 ? kBlueAccent : kDarkGrey,
                      size: _height * 0.035,
                    ),
                    Text(
                      "Delivered",
                      style: GoogleFonts.robotoSlab(
                        color: status == 2 ? kBlueAccent : kDarkGrey,
                        fontSize: _height * 0.017,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                width: _width * 1 / 3,
                height: _height * 0.07,
              ),
            )
          ],
        )));
  }
}
