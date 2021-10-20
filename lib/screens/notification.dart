
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/components/notif_box.dart';
import 'package:grocery/shared_Pref.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../const.dart';
import '../../strings.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Image.asset(
            "assets/images/logo.png",
            color: kColor,
            height: 37,
            width: 58,
          ),
        ),
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
                  child: StreamBuilder(
                      stream: _firestore
                          .collection("notifications")
                          .where("to", isEqualTo: SharedData.user.uid)
                          .snapshots()
                         ,
                      builder: (context, snapshot) {
                        var data = snapshot.data;
                        if (data == null) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final List<DocumentSnapshot> docs = data.docs;
                        return Column(
                          children: docs.map((notif) =>  NotifBox(
                                width: _width,
                                height: _height,
                                title: notif["title"],
                                body: notif["body"],
                             
                            )).toList()
                      
                        );
                      })))),
    );
  }
}
