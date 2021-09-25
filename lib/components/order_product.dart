import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/components/image_container.dart';
import '../../const.dart';

class OrderProduct extends StatefulWidget {


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
              width:_width*0.25,
              img: "assets/images/fruits.png",
              height: _width*0.3,
              borderRaduis: 10),
          SizedBox(
            width: _width * 0.05,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Product Name",
                style: GoogleFonts.robotoSlab(
                  color: kColor,
                  fontSize: _height * 0.020,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: _height*0.02,
              ),
              Text(
                "4 pieces",
                style: GoogleFonts.robotoSlab(
                  color: kDarkText,
                  fontSize: _height * 0.017,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: _height*0.02,
              ),
              Text(
                "2\$",
                style: GoogleFonts.robotoSlab(
                  color: kDarkText,
                  fontSize: _height * 0.019,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: _height*0.02,
              ),
              Text(
                "Qantity : 8",
                style: GoogleFonts.robotoSlab(
                  color: kColor,
                  fontSize: _height * 0.018,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: _height*0.02,
              ),
            ],
          )
        ],
      ),
    );
  }
}
