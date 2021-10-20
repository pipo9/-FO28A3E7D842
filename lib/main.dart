import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery/screens/auth/resetPassword.dart';
import 'package:grocery/screens/auth/signin.dart';
import 'package:grocery/screens/home.dart';
import 'package:grocery/screens/notification.dart';
import 'package:grocery/screens/order_detail.dart';
import 'package:grocery/screens/profile.dart';
import 'package:grocery/screens/splash.dart';
import 'package:grocery/screens/subs_detail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grocery/shared_Pref.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (context) => SharedData(),
        ),
    ],
    child:
    MaterialApp(
      debugShowCheckedModeBanner: false,
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
            '/subscripton': (context) => SubsDetails(),
            '/notif': (context) => Notifications(),
          }),
    ));
  }
}
