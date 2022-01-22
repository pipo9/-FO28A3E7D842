import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/components/notif_box.dart';
import 'package:grocery/shared_Pref.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../const.dart';
import '../../strings.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
    SharedData.context= context;


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
                  child:  Column(
                        
                          children: [
                          SizedBox(height: _height * 0.022),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                            notifications_description,
                            style: GoogleFonts.robotoSlab(
                              color: kBlueAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),),
                          
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            height: 1,
                            width: _width * 0.2,
                            color: kBlueAccent,
                          ),
                          SizedBox(height: _height * 0.02),
                          Column(
                              children: SharedData.notifications
                                  .map(
                                    (notif) => Slidable(
                                      child: NotifBox(
                                        onTap: ()async{
                                          await _firestore.collection("notifications").doc(notif.id).update({
                                            "seen":true
                                          });
                                          if(notif.seen == false)
                                           Navigator.pop(context);
                                         
                                        },
                                        width: _width,
                                        height: _height,
                                        title:notif.title,
                                        body: notif.body,
                                        seen:notif.seen
                                      ),
                                      actionPane: SlidableDrawerActionPane(),
                                      actionExtentRatio: 0.2,
                                      secondaryActions: <Widget>[
                                        IconSlideAction(
                                          caption: 'delete',
                                          color: Colors.transparent,
                                          icon: Icons.delete,
                                          onTap: () async {
                                            setState(() {
                                            SharedData.notifications.remove(notif);
                                            });
                                            await _firestore
                                                .collection("notifications")
                                                .doc(notif.id)
                                                .delete();
                                          },
                                          foregroundColor: Colors.black,
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList())
                        ])
                     ))),
    );
  }
}
