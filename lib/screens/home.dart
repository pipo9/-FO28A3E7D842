import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/components/image_container.dart';
import 'package:grocery/components/order-card.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../const.dart';
import '../strings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = false;
  TextEditingController searchTextController = new TextEditingController();
  int marign = 0;
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
                        Navigator.pushReplacementNamed(context, "/profile");
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
                            Navigator.pushReplacementNamed(context, '/notif');
                          },
                        child:Badge(
                          badgeContent: Text(''),
                          badgeColor: kLightGreen,
                          position: BadgePosition.topEnd(top: -7, end: 1),
                          child: Icon(
                            Icons.notifications_none,
                            size: _width * 0.07,
                            color: kDarkGrey,
                          ),
                        ),),
                        SizedBox(width: _width * 0.05),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/signIn');
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20,
                ),
                child: TextField(
                  style: GoogleFonts.robotoSlab(
                      color: kColor, fontSize: _width * 0.04),
                  controller: searchTextController,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: kColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: kColor)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: kColor,
                        )),
                    labelText: "Search",
                    labelStyle: TextStyle(
                      fontFamily: 'Adobe Devanagari',
                      color: kColor,
                      fontSize: _height * 0.02,
                    ),
                    hintText: "search by id",
                    hintStyle: TextStyle(
                        color: kColor.withOpacity(0.7),
                        fontSize: _height * 0.02,
                        fontFamily: 'Adobe Devanagari'),
                    suffixIcon: Icon(
                      Icons.search,
                      color: kDarkGrey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: _height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        marign = 0;
                      });
                    },
                    child: Text(
                      orders_tab_simple,
                      style: GoogleFonts.zillaSlab(
                        fontWeight: FontWeight.w500,
                        color: kColor,
                        fontSize: _width * 0.05,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        marign = 1;
                      });
                    },
                    child: Text(
                      orders_tab_subs,
                      style: GoogleFonts.zillaSlab(
                        fontWeight: FontWeight.w500,
                        color: kColor,
                        fontSize: _width * 0.05,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: _height * 0.01),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: EdgeInsets.only(left: _width * 0.5 * marign),
                    height: _height * 0.003,
                    width: _width * 0.5,
                    color: kColor),
              ),
              OrderCard(onTap:  () {
              Navigator.pushReplacementNamed(context, '/order');
            },orderId: "HFKELSLMCCS6780",),
              OrderCard(onTap:  () {
              Navigator.pushReplacementNamed(context, '/subscripton');
            },orderId: "HFKELSLMCCS6780",),
              
              ],
          ))),
    );
  }
}
