import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/components/text_fields.dart';
import 'package:grocery/components/header_sign_in_up.dart';
import 'package:grocery/components/gradient_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../const.dart';
import '../../strings.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String email = '';

  TextEditingController emailTextController = new TextEditingController();

  bool loading = false;

  toggleSpinner() {
    setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: klightGrey,
      
      body: ModalProgressHUD(
          inAsyncCall: loading,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  HeaderSignInUp(
                    image: 'assets/images/forgotPassword.png',
                    title: sign_in_reset_password,
                    comment: reset_password_description,
                  ),
                  Textfields(
                    inputType: TextInputType.emailAddress,
                    labetText: fill_info_email_labet,
                    hintText: fill_info_email_hint,
                    icon: Icons.email,
                    onChanged: (value) {
                      email = value;
                    },
                    controller: emailTextController,
                  ),
                  SizedBox(height: _height * 0.04),
                  GradientButton(
                    color1: kColor,
                    color2: kBlueAccent,
                    text: support_send,
                    textColor: Color(0xffF8F8F8),
                    height: 44,
                    width: 310,
                    borderRadius: 10,
                    onpressed: () {},
                  ),
                  SizedBox(height: _height * 0.05),
                  InkWell(onTap:(){
                    Navigator.pop(context);
                  },
                  child:Text(
                          go_back,
                          style: GoogleFonts.zillaSlab(
                            fontWeight: FontWeight.w600,
                            color: kColor,
                            fontSize: _width * 0.035,
                          ),
                        ),),
                  SizedBox(height: _height * 0.05),
                  Container(
                      width: 65,
                      height: 65,
                      child: Image.asset('assets/images/logo_second.png')),
                ],
              ),
            ),
          )),
    );
  }
}
