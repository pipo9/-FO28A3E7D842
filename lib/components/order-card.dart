import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../const.dart';
import '../../strings.dart';

class OrderCard extends StatefulWidget {
  final String orderId;
  final onTap;

  OrderCard({@required this.orderId, @required this.onTap});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(_height * 0.015),
      margin: EdgeInsets.only(
          top: _height * 0.025, left: _height * 0.02, right: _height * 0.02),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: Offset(0, 2),
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: klightGrey,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.orderId,
            style: GoogleFonts.zillaSlab(
              fontWeight: FontWeight.w400,
              color: kBlueAccent,
              fontSize: _width * 0.035,
            ),
          ),
          InkWell(
            onTap:widget.onTap,
            child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: _height * 0.005, horizontal: _width * 0.04),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: kColor, width: _width * 0.002)),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: kColor,
                    ),
                    SizedBox(
                      width: _width * 0.04,
                    ),
                    Text(
                      subs_details,
                      style: GoogleFonts.zillaSlab(
                        fontWeight: FontWeight.w500,
                        color: kColor,
                        fontSize: _width * 0.035,
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
