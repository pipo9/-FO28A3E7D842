import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:grocery/const.dart';
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


const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
    flutterLocalNotificationsPlugin.show(
            message.notification.hashCode,
            message.notification.title,
            message.notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
                priority: Priority.high
              ),
            ));
  print('A bg message just showed up :  ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getNotifWhenChangeRoute(route) async {
    new SharedData().getNotifications();
    return route;
  }

  getdata(widget) {
    SharedData().getNotifications();
    return widget;
  }
  @override
  void initState() {
    super.initState();



    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
                priority: Priority.high
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        // showNotification(SharedData.context, message.notification.title,
        //     message.notification.body, (){
        //       Navigator.pop(context);
        //     });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    SharedData.context = context;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => SharedData(),
          ),
        ],
        child: MaterialApp(
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
