import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const.dart';

class Textfields extends StatelessWidget {
  final String labetText;
  final String hintText;
  final IconData icon;
  final bool password;
  final TextInputType inputType;
  final int min;
  final onChanged;
  final bool enabled;
  final TextEditingController controller;
  final int max;

  Textfields(
      {@required this.labetText,
      @required this.hintText,
      @required this.icon,
      this.password = false,
      this.min = 1,
      this.inputType = TextInputType.text,
      @required this.onChanged,
      this.enabled = true,
      @required this.controller,
      this.max = 1,
      });

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 20,
      ),
      child: TextField(
        style: GoogleFonts.robotoSlab(color: kColor, fontSize: _width * 0.04),
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        keyboardType: inputType,
        obscureText: password,
        maxLines: max,
        minLines: min,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: icon != null ?  10 : 14, horizontal: 20),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: kColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: kColor)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: kColor,
              )),
          labelText: labetText,
          labelStyle: TextStyle(
            fontFamily: 'Adobe Devanagari',
            color: kColor,
            fontSize: _height * 0.02,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
              color: kColor.withOpacity(0.7),
              fontSize: _height * 0.02,
              fontFamily: 'Adobe Devanagari'),
          suffixIcon: icon != null ? Icon(
            icon,
            color: kColor,
          ) : null,
        ),
      ),
    );
  }
}
