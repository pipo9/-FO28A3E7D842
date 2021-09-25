import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/components/text_fields.dart';
import 'package:grocery/components/gradient_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../const.dart';
import '../../strings.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String email = '';
  String name = '';
  String phone = '';

  TextEditingController emailTextController = new TextEditingController();
  TextEditingController nameTextController = new TextEditingController();
  TextEditingController phoneTextController = new TextEditingController();

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
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: _height * 0.11,
        leading:InkWell( onTap: (){
          Navigator.pushReplacementNamed(context, '/home');
        },
          child:Container(
            width: 60,
            height: 60,
            child: Image.asset('assets/images/logo_second.png')),),
        backgroundColor: klightGrey,
        title: Text(
          profile_title,
          style: GoogleFonts.robotoSlab(
            color: kColor,
            fontSize: _height * 0.028,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ModalProgressHUD(
          inAsyncCall: loading,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: _height * 0.022),
                  Text(
                    profile_description,
                    style: GoogleFonts.robotoSlab(
                      color: kBlueAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    height: 1,
                    width: _width * 0.2,
                    color: kBlueAccent,
                  ),
                  SizedBox(height: _height * 0.02),
                  Textfields(
                    inputType: TextInputType.emailAddress,
                    labetText: fill_info_name_labet,
                    hintText: fill_info_name_hint,
                    icon: Icons.person,
                    onChanged: (value) {
                      name = value;
                    },
                    controller: nameTextController,
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
                  Textfields(
                    inputType: TextInputType.emailAddress,
                    labetText: sign_in_phone_labet,
                    hintText: sign_in_phone_hint,
                    icon: Icons.phone,
                    onChanged: (value) {
                      phone = value;
                    },
                    controller: phoneTextController,
                  ),
                  SizedBox(height: _height * 0.06),
                  GradientButton(
                    color1: kColor,
                    color2: kBlueAccent,
                    text: profile_edit,
                    textColor: Color(0xffF8F8F8),
                    height: 44,
                    width: 310,
                    borderRadius: 10,
                    onpressed: () {},
                  ),
                  SizedBox(height: _height * 0.02),
                  GradientButton(
                    color1: kColor,
                    color2: kBlueAccent,
                    text: profile_update,
                    textColor: Color(0xffF8F8F8),
                    height: 44,
                    width: 310,
                    borderRadius: 10,
                    onpressed: () {},
                  ),
                  SizedBox(height: _height * 0.09),
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
