import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/components/notif_box.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../const.dart';
import '../../strings.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {


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
          notifications_title,
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
                children: [
                  NotifBox(
                      width: _width,
                      height: _height,
                      title: "Grocurs Daily",
                      body: "this in new feature so you can see notifications",
                    ),
                  NotifBox(
                      width: _width,
                      height: _height,
                      title: "Grocurs Daily",
                      body: "this in new feature so you can see notifications",
                    ),
                  
                ],
            ),
            )
          )),
    );
  }
}
