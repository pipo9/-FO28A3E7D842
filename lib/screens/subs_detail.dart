import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/components/calendar.dart';
import 'package:grocery/components/order_product.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../const.dart';
import '../../strings.dart';

class SubsDetails extends StatefulWidget {
  @override
  _SubsDetailsState createState() => _SubsDetailsState();
}

class _SubsDetailsState extends State<SubsDetails> {

  int status = 0;
  List<Color> bgColors = [kBlueAccent.withOpacity(0.2), kGreen];
  List<Color> iconsColors = [kColor, klightGrey];
  List<String> statusString = ['Pending','Prepared'];
  List<IconData> icons = [Icons.pending_actions, Icons.local_mall];



  bool loading = false;

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
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: _height * 0.11,
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Container(
              width: 60,
              height: 60,
              child: Image.asset('assets/images/logo_second.png')),
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
                  height: _height * 0.03,
                ),
                CustomizedCalendar(
                  onDateSelected: (date) {},
                  width: _width,
                  height: _height,
                ),
                SizedBox(
                  height: _height * 0.04,
                ),
                Row(
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
                    InkWell(
                      onTap: () {
                        setState(() {
                          status = (status + 1) % 2;
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: _height * 0.005,
                              horizontal: _width * 0.04),
                          decoration: BoxDecoration(
                            color: bgColors[status],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                icons[status],
                                color: iconsColors[status],
                              ),
                              SizedBox(
                                width: _width * 0.04,
                              ),
                              Text(
                                statusString[status],
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
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: _width * 0.08, vertical: _height * 0.03),
                    width: _width,
                    color: kBlueAccent.withOpacity(0.15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Order N° :",
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
                              "#123456",
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
                              "Order purchased at : ",
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
                              "27-10-2020",
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
                              "Number of subscriptions :",
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
                              "2 products",
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
                              "Shipping address :",
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
                              "Street 1423 something, India",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Products",
                      style: GoogleFonts.robotoSlab(
                        color: kColor,
                        fontSize: _height * 0.030,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: _width * 0.01,
                    ),
                    Text(
                      "2 products",
                      style: GoogleFonts.robotoSlab(
                        color: kColor,
                        fontSize: _height * 0.023,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                OrderProduct(),
                OrderProduct(),
                SizedBox(
                  height: _height * 0.03,
                ),
              ],
            )),
          )),
    );
  }
}
