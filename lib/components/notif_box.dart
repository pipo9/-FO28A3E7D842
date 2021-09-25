import 'package:flutter/material.dart';
import '../const.dart';

class NotifBox extends StatelessWidget {
  
  final double width;
  final String title;
  final String body;
  final double height;

  const NotifBox({Key key, this.width, this.title, this.body, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.06, vertical: height * 0.015),
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.06, vertical: height * 0.02),
      decoration: BoxDecoration(
        color: klightGrey,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: Row(children: [
        Container(
          margin: EdgeInsets.only(right: width * 0.03),
          padding: EdgeInsets.only(right: width * 0.03),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: kColor, width: width * 0.003),
            ),
          ),
          child: Icon(
            Icons.notifications,
            color: kColor,
            size: height * 0.045,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  title,
                  style: TextStyle(
                    color: kColor,
                    fontSize: width * 0.04,
                  ),
                ),
              Text(
                  body,
                  style: TextStyle(
                    color: kColor.withOpacity(0.5),
                    fontSize: width * 0.03,
                  ),
                ),
            ],
          ),
        ),
      ]),
    );
  }
}
