import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../const.dart';

class OrderCard extends StatefulWidget {
  final String orderId;
  final onTap;
  final status;

  OrderCard(
      {@required this.orderId, @required this.onTap, @required this.status});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  var status;
  String state;
  List<Color> pendingColors = [
    kColorRed,
    kDarkBlue,
    kDarkBlue,
    kDarkBlue,
    kDarkBlue
  ];
  List<Color> proContColors = [
    kDarkGrey,
    kDarkGrey,
    kDarkBlue,
    kDarkBlue,
    kDarkBlue
  ];
  List<Color> proIconColors = [
    kDarkGrey,
    kDarkGrey,
    kDarkBlue,
    kDarkBlue,
    kDarkBlue
  ];
  List<Color> delConColors = [
    kDarkGrey,
    kDarkGrey,
    kDarkGrey,
    kDarkGrey,
    kDarkBlue
  ];
  List<Color> delIconColors = [
    kDarkGrey,
    kDarkGrey,
    kDarkGrey,
    kDarkGrey,
    kDarkBlue
  ];

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    switch (widget.status) {
      case 'delivered':
        {
          setState(() {
            status = 4;
          });
          break;
        }
      case 'rejected':
        {
          setState(() {
            status = 0;
          });
          break;
        }
      case 'pending':
        {
          setState(() {
            status = 1;
          });
          break;
        }
      case 'dispatched':
      case 'processing':
        {
          setState(() {
            status = 3;
          });
          break;
        }
      case 'prepared':
        {
          setState(() {
            status = 2;
          });
          break;
        }

        break;
      default:
        {
          setState(() {
            status = 1;
          });
          break;
        }
    }

    state = status == 2 ? "ready for pickUp" : widget.status;

    return InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.all(_height * 0.015),
          margin: EdgeInsets.only(
              top: _height * 0.025,
              left: _height * 0.02,
              right: _height * 0.02),
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
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Order Id:",
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
                          widget.orderId,
                          style: GoogleFonts.robotoSlab(
                            color: kColor,
                            fontSize: _height * 0.018,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      state,
                      style: GoogleFonts.robotoSlab(
                        color: pendingColors[status],
                        fontSize: _height * 0.020,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: _height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: _height * 0.04,
                            width: _height * 0.04,
                            decoration: BoxDecoration(
                              color: pendingColors[status],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80)),
                            ),
                            child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.departure_board_outlined,
                                  color: klightGrey,
                                  size: _height * 0.03,
                                ))),
                      ],
                    ),
                    Container(
                      height: _height * 0.008,
                      width: _width * 0.25,
                      color: proContColors[status],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: _height * 0.04,
                            width: _height * 0.04,
                            decoration: BoxDecoration(
                              color: proIconColors[status],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80)),
                            ),
                            child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.loop,
                                  color: klightGrey,
                                  size: _height * 0.03,
                                ))),
                      ],
                    ),
                    Container(
                      height: _height * 0.008,
                      width: _width * 0.25,
                      color: delConColors[status],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: _height * 0.04,
                            width: _height * 0.04,
                            decoration: BoxDecoration(
                              color: delConColors[status],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80)),
                            ),
                            child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.shopping_bag_outlined,
                                  color: klightGrey,
                                  size: _height * 0.03,
                                ))),
                      ],
                    )
                  ],
                ),
              ]),
        ));
  }
}
