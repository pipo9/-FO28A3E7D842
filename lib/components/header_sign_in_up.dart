import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const.dart';

class HeaderSignInUp extends StatelessWidget {
  final String image;
  final String title;
  final String comment;

  HeaderSignInUp(
      { this.image,  this.title, this.comment = ''});

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        SizedBox(height: _height * 0.04),
        Image.asset(
          image,
          height: _height * 0.3,
          width: _height * 0.3,
        ),
        SizedBox(height: _height * 0.01),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.zillaSlab(
            fontWeight: FontWeight.w600,
            color: kColor,
            fontSize: _width * 0.1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            comment,
            textAlign: TextAlign.center,
            style: GoogleFonts.zillaSlab(
              fontWeight: FontWeight.w600,
              color: kColor,
              fontSize: _width * 0.035,
            ),
          ),
        ),
        SizedBox(height: _height * 0.02),
      ],
    );
  }
}
