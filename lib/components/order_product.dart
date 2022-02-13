import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../const.dart';

class OrderProduct extends StatefulWidget {
  final productName;
  final price;
  final quantity;
  final imageUrl;
  final days;
  final simple;
  final discount;

  OrderProduct(
      {@required this.productName,
      @required this.price,
      @required this.quantity,
      @required this.imageUrl,
      this.discount = "0",
      this.simple = false,
      @required this.days});

  @override
  _OrderProductState createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  priceAfterDiscount() {
    var price = double.parse(widget.price);
    var discount = double.parse(widget.discount);

    return price * (1 - discount / 100);
  }

  getDays() {
    var daysToText = "";
    daysToText = daysToText + widget.days[0];
    for (var i = 1; i < widget.days.length; i++) {
      daysToText = daysToText + " ," + widget.days[i];
    }
    return daysToText;
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    const double pi = 3.1415926535897932;
    var total = priceAfterDiscount() * double.parse(widget.quantity);
    String daysToText = "";
    if(!widget.simple)
      daysToText = getDays();

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
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Stack(
              children: [
                Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  width: _width * 0.25,
                  height: _width * 0.35,
                ),
                widget.discount == '0'
                    ? SizedBox()
                    : Positioned(
                        left: -_width * 0.075,
                        top: _width * 0.008,
                        child: Transform.rotate(
                          angle: 45.5 * pi / 12.0,
                          child: Container(
                              width: _width * 0.27,
                              height: _width * 0.06,
                              color: Color(0xffffba12),
                              child: Center(
                                child: Text(
                                  '${widget.discount}%',
                                  style: GoogleFonts.robotoSlab(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )),
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(
            width: _width * 0.05,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.productName,
                style: GoogleFonts.robotoSlab(
                  color: kColor,
                  fontSize: _height * 0.020,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: _height * 0.02,
              ),
              
              widget.discount == "0"
                  ? Text(
                      "${widget.price}₹",
                      style: GoogleFonts.robotoSlab(
                        color: kDarkText,
                        fontSize: _height * 0.019,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Row(
                      children: [
                        Text("${priceAfterDiscount()}₹",
                            style: GoogleFonts.robotoSlab(
                              color: kDarkText,
                              fontSize: _height * 0.020,
                              fontWeight: FontWeight.w700,
                            )),
                        SizedBox(
                          width: _width * 0.01,
                        ),
                        Text("${widget.price}₹",
                            style: GoogleFonts.robotoSlab(
                                color: kDarkText,
                                fontSize: _height * 0.019,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.lineThrough)),
                      ],
                    ),
              SizedBox(
                height: _height * 0.02,
              ),
              widget.simple == false
                  ? Container(
                      width: _width * 0.51,
                      child: Text(daysToText,
                          softWrap: true,
                          style: GoogleFonts.robotoSlab(
                            color: kDarkGrey,
                            fontSize: resizeText(widget.days.toString()),
                            fontWeight: FontWeight.w300,
                          )),
                    )
                  : SizedBox(),
              SizedBox(
                height: _height * 0.02,
              ),
              Row(
                children: [
                  Text(
                    "Qantity : ${widget.quantity}",
                    style: GoogleFonts.robotoSlab(
                      color: kColor,
                      fontSize: _height * 0.018,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    width: _width * 0.1,
                  ),
                  Text(
                    "Total Price : $total",
                    style: GoogleFonts.robotoSlab(
                      color: kColorRed,
                      fontSize: _height * 0.018,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: _height * 0.02,
              ),
            ],
          )
        ],
      ),
    );
  }
}
