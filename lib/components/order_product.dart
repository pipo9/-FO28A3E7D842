import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/components/image_container.dart';
import '../../const.dart';

class OrderProduct extends StatefulWidget {
  final productName;
  final price;
  final quantity;
  final imageUrl;
  final days;
  final simple;

  OrderProduct(
      {@required this.productName,
      @required this.price,
      @required this.quantity,
      @required this.imageUrl,
       this.simple = false,
      @required this.days});

  @override
  _OrderProductState createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
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
        children: [
          ImageContainer(
              width: _width * 0.25,
              img: widget.imageUrl,
              height: _width * 0.3,
              borderRaduis: 10),
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
              Text(
                "${widget.quantity} pieces",
                style: GoogleFonts.robotoSlab(
                  color: kDarkText,
                  fontSize: _height * 0.017,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: _height * 0.02,
              ),
              Text(
                "${widget.price}\$",
                style: GoogleFonts.robotoSlab(
                  color: kDarkText,
                  fontSize: _height * 0.019,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: _height * 0.02,
              ),
              
              widget.simple == false ? 
              Row(children: [
                Text(widget.days[0].toString(),
                    overflow: TextOverflow.visible,
                    style: GoogleFonts.robotoSlab(
                      color: kDarkGrey,
                      fontSize: resizeText(widget.days.toString()),
                      fontWeight: FontWeight.w300,
                    )),
                for (var i = 1; i < widget.days.length; i++)
                  Text(", " + widget.days[i].toString(),
                      overflow: TextOverflow.visible,
                      style: GoogleFonts.robotoSlab(
                        color: kDarkGrey,
                        fontSize: resizeText(widget.days.toString()),
                        fontWeight: FontWeight.w300,
                      ))
              ]): SizedBox(),
              SizedBox(
                height: _height * 0.02,
              ),
              Text(
                "Qantity : ${widget.quantity}",
                style: GoogleFonts.robotoSlab(
                  color: kColor,
                  fontSize: _height * 0.018,
                  fontWeight: FontWeight.w400,
                ),
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
