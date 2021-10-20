import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// Colors
const kColor = Color(0xff0F357B);
const klightGrey = Color(0xffF8F8F8);
const kColorRed = Color(0xffD61B2F);
const kBlueAccent = Color(0xff00A5BB);
const kOrange = Color(0xffFFBA00);
const kDarkBlue = Color(0xff0B6987);
const kLightGreen = Color(0xff96D8C2);
const kgreyText = Color(0xffF5F5F5);
const kGreen = Color(0xff1BA42F);
const kDarkText = Color(0xff070707);
const snackBarColor =  Color(0xff0F357B);
const kDarkGrey =  Color(0xff707070);
//Fonts
const smalText = 'Adobe Devanagari';

//style
// roboto slab bold
TextStyle kStyle =
    GoogleFonts.robotoSlab(color: kColor, fontWeight: FontWeight.bold);

double resizeText(String text) {
  double size = 0.0;
  if (text.length < 11) {
    size = 15;
  }
  if (text.length < 20 && text.length >= 11) {
    size = 13;
  } else if (text.length < 27 && text.length >= 20) {
    size = 10;
  } else if (text.length >= 27) {
    size = 8;
  }
  return size;
}

void showAlert(context, title, message, error, onPressed) {
  double _width = MediaQuery.of(context).size.width;
  Alert(
    context: context,
    type: error == true ? AlertType.error : AlertType.success,
    style: AlertStyle(
      backgroundColor: klightGrey,
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: GoogleFonts.zillaSlab(
        fontWeight: FontWeight.w600,
        color: kColor,
        fontSize: _width * 0.05,
      ),
      descTextAlign: TextAlign.center,
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: error == true ? kColorRed : kGreen,
        fontWeight: FontWeight.bold,
        fontSize: _width * 0.07,
      ),
      alertAlignment: Alignment.center,
    ),
    title: title,
    desc: message,
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: _width * 0.04),
        ),
        onPressed: onPressed,
        gradient: LinearGradient(colors: [kColor, kBlueAccent]),
        width: _width * 0.45,
      )
    ],
  ).show();
}

void showConfirmation(context, title, message, onSubmit, onCancel) {
  double _width = MediaQuery.of(context).size.width;
  Alert(
    context: context,
    type: AlertType.warning,
    style: AlertStyle(
      backgroundColor: klightGrey,
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: GoogleFonts.zillaSlab(
        fontWeight: FontWeight.w600,
        color: kColor,
        fontSize: _width * 0.05,
      ),
      descTextAlign: TextAlign.center,
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: kColorRed,
        fontWeight: FontWeight.bold,
        fontSize: _width * 0.07,
      ),
      alertAlignment: Alignment.center,
    ),
    title: title,
    desc: message,
    buttons: [
      DialogButton(
        child: Text(
          "Cancel",
          style: TextStyle(color: Colors.white, fontSize: _width * 0.04),
        ),
        onPressed: onCancel,
        gradient: LinearGradient(colors: [kColorRed, kColorRed]),
        width: _width * 0.45,
      ),
      DialogButton(
        child: Text(
          "I confirm",
          style: TextStyle(color: Colors.white, fontSize: _width * 0.04),
        ),
        onPressed: onSubmit,
        gradient: LinearGradient(colors: [kColor, kColor]),
        width: _width * 0.45,
      ),
    ],
  ).show();
}

showNotification(context, title, message, onPressed) {
  double _width = MediaQuery.of(context).size.width;
  Alert(
    context: context,
    style: AlertStyle(
      backgroundColor: klightGrey,
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: GoogleFonts.zillaSlab(
        fontWeight: FontWeight.w600,
        color: kColor,
        fontSize: _width * 0.04,
      ),
      descTextAlign: TextAlign.center,
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: kColor,
        fontWeight: FontWeight.bold,
        fontSize: _width * 0.055,
      ),
      alertAlignment: Alignment.center,
    ),
    title: title,
    desc: message,
    image: Image.asset("assets/images/notification.png"),
    buttons: [
      DialogButton(
        child: Text(
          "COOL",
          style: TextStyle(color: Colors.white, fontSize: _width * 0.04),
        ),
        onPressed: onPressed,
        gradient: LinearGradient(colors: [kColor, kBlueAccent]),
        width: _width * 0.45,
      )
    ],
  ).show();
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension DoubleExtension on double {
  double toDoubleRounded(int value) {
    return double.parse(this.toStringAsFixed(value));
  }
}

String convertDateTimeDisplay(String date, String initialFormat, String finalFormat) {
  final DateFormat displayFormater = DateFormat(initialFormat);
  final DateFormat serverFormater = DateFormat(finalFormat);
  final DateTime displayDate = displayFormater.parse(date);
  final String formatted = serverFormater.format(displayDate);
  return formatted;
}



 Map validateEmail(email) {

    Map response = Map();
    if(email==null){
      response['status'] = false;
      response['message'] = "- email should not be empty";
      return response;
    }
    if(!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)){
      response['status'] = false;
      response['message'] = "- please enter a correct email";
      return response;
    }
    response['status'] = true;
    response['message'] = "";
    return response;
  }

 Map validatetextField(textField) {
    Map response = Map();
    if (textField==null )  {
      response['status'] = false;
      response['message'] = "- Text field length should not be empty";
      return response;
    }

    response['status'] = true;
    response['message'] = "";
    return response;
  }
