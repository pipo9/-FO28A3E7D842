import 'package:flutter/material.dart';
import '../const.dart';

class ImageContainer extends StatelessWidget {
  final double width;
  final double height;
  final String img;
  final double borderRaduis;

  ImageContainer({ this.width,  this.img,  this.height,  this.borderRaduis});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(left: 15, top: 15),
      decoration: BoxDecoration(
        color: kDarkText,
        image: DecorationImage(
          image: NetworkImage(img),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: kDarkText,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(borderRaduis),
      ),
    );
  }
}