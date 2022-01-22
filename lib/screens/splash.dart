import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grocery/controllers/userController.dart';
import '../strings.dart';
import '../const.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {


  void initState() {

    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 8);
    return new Timer(
      duration,
      () async {
        var washere = await User().wasHere();

        if (washere == true) {
          await User().getUserInfo();
            await User().saveDeviceToken();
          Navigator.pushReplacementNamed(context, '/home');
        } else
          Navigator.pushReplacementNamed(context, '/signIn');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.5, sigmaY: 5.5),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment(-1.0, -1.0),
                  end: Alignment(1.0, 1.0),
                  colors: [
                    kColor.withOpacity(0.75),
                    kColorRed.withOpacity(0.88)
                  ],
                  stops: [
                    0.5,
                    1.0
                  ]),
            ),
          ),
          Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 180,
                ),
                Image.asset('assets/images/logo.png'),
                SizedBox(
                  height: 12,
                ),
                Text(
                  loading_quote,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Adobe Devanagari',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
