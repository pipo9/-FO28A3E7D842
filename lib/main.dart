import 'package:flutter/material.dart';
import 'package:grocery/screens/auth/resetPassword.dart';
import 'package:grocery/screens/auth/signin.dart';
import 'package:grocery/screens/home.dart';
import 'package:grocery/screens/notification.dart';
import 'package:grocery/screens/order_detail.dart';
import 'package:grocery/screens/profile.dart';
import 'package:grocery/screens/splash.dart';
import 'package:grocery/screens/subs_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => LoadingScreen(),
            '/signIn': (context) => SignIn(),
            '/reset': (context) => ResetPassword(),
            '/home': (context) => Home(),
            '/profile': (context) => Profile(),
            '/order': (context) => OrderDtails(),
            '/subscripton' : (context) => SubsDetails(),
            '/notif' : (context) => Notifications(),
          }),
    );
  }
}
