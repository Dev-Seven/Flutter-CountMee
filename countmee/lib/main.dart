import 'dart:convert';

import 'package:countmee/Model/PandingDataModel.dart';
import 'package:countmee/Screens/DeliveryBoy/Login/LoginVC.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/OrderDetailVC.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'Screens/DeliveryBoy/Order/AcceptedOrder.dart';
import 'Screens/DeliveryBoy/Order/DeliveredOrderDetailVC.dart';
import 'Screens/DeliveryBoy/TabBar/TabBarVC.dart';
import 'Screens/Splash/SplashVC.dart';

/*
Title : Entry Point of a App
Purpose:  Entry Point of a App
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

const String TAG = "BackGround_Work";
AndroidNotificationChannel channel;
String firebaseToken = "";
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext myAppContext;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

String selectedNotificationPayload;
double currentLong;
double currentLat;
PandingDataModel orderDetail;
String _currentAddress;
bool isLoading = false;
Position _currentPosition;

Future<void> onSelectNotification(dynamic payload) async {
  print(payload);
  if (payload != null) {
    debugPrint('App Start notification payload: ' + payload);
  }
}

updateLatLong(BuildContext context) {
  FormData formData;
  formData = FormData.fromMap({
    "location": _currentAddress,
    "latitude": _currentPosition.latitude,
    "longitude": _currentPosition.longitude,
  });

  postDataRequestWithToken(getDeliveryLocation, formData, context)
      .then((value) {
    if (value is Map) {
      print(value);
    } else {
      print(
        value.toString(),
      );
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('onMessage.....');
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;
    _showNotification(message);
  });

  // getToken();
  runApp(MyApp());
}

Future<void> _showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'default_notification_channel_id',
    'your channel name',
    // 'your channel description',
    importance: Importance.high,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound('cuckoo_sms'),
    playSound: true,
    showWhen: true,
    fullScreenIntent: true,
    icon: "@mipmap/ic_launcher",
    ticker: 'ticker',
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification.title,
    message.notification.body,
    platformChannelSpecifics,
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint(
        'notification payload: $payload last String ${payload.split(",").last}',
      );
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
    isConsumedOnce = true;
    // int id;
    // if (message.data['moredata'].contains(r'^[0-9]+$')) {
    //   id = int.parse(message.data['moredata'].replaceAll(RegExp('[^0-9]'), ''));
    // }
    Map valueMap = json.decode(message.data['moredata']);
    FormData formData = FormData.fromMap({
      "order_id": valueMap['package_id'],
    });
    await postDataRequestWithToken(
            getOrderDetailAPI, formData, navigatorKey.currentState.context)
        .then((value) {
      print(value);

      isLoading = false;

      print(value);
      print("hii");
      if (value[kStatusCode] == 200) {
        if (value[kData] is Map) {
          orderDetail = PandingDataModel.fromJson(value[kData]);
        }
      } else {
        isLoading = false;
      }
    });
    print(message.data["message"]);
    Map<String, dynamic> map = jsonDecode(message.data["message"]);
    String name = map['title'];
    print(name);
    print(message.data['message'].toString().contains("accepted"));
    if (orderDetail.first_deliveryboy == 0) {
      Navigator.push(
        navigatorKey.currentState.context,
        MaterialPageRoute(
          builder: (context) => AcceptedOrderVC(
            objOrder: orderDetail,
          ),
          fullscreenDialog: false,
        ),
      );
    } else if (name.contains("accepted")) {
      Navigator.pushAndRemoveUntil(
          navigatorKey.currentState.context,
          MaterialPageRoute(
              builder: (context) => TabbarVC(), fullscreenDialog: false),
          (route) => false);
    } else if (name.contains("Cancellation")) {
      Navigator.pushAndRemoveUntil(
          navigatorKey.currentState.context,
          MaterialPageRoute(
              builder: (context) => TabbarVC(), fullscreenDialog: false),
          (route) => false);
    } else if (name.contains("delivered")) {
      Navigator.push(
        navigatorKey.currentState.context,
        MaterialPageRoute(
          builder: (context) => DeliveredOrderDetailVC(
            objOrder: orderDetail,
          ),
          fullscreenDialog: false,
        ),
      );
    } else {
      Navigator.push(
        navigatorKey.currentState.context,
        MaterialPageRoute(
          builder: (context) => OrderDetailVC(
            orderId: valueMap['package_id'],
            collectionId: message.data['collection_center_id'],
          ),
          fullscreenDialog: false,
        ),
      );
    }
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (userObj == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginVC(),
            fullscreenDialog: false,
          ),
          (route) => false,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      setState(() {
        isConsumedOnce = true;
      });
      Map valueMap = json.decode(message.data['moredata']);

      FormData formData = FormData.fromMap({
        "order_id": valueMap['package_id'],
      });
      await postDataRequestWithToken(
              getOrderDetailAPI, formData, navigatorKey.currentState.context)
          .then((value) {
        print(value);

        isLoading = false;

        print(value);
        print("hii");
        if (value[kStatusCode] == 200) {
          if (value[kData] is Map) {
            orderDetail = PandingDataModel.fromJson(value[kData]);
          }
        } else {
          isLoading = false;
        }
      });
      print(message.data["message"]);
      Map<String, dynamic> map = jsonDecode(message.data["message"]);
      String name = map['title'];
      print(name);
      print(message.data['message'].toString().contains("accepted"));
      if (orderDetail.first_deliveryboy == 0) {
        Navigator.push(
          navigatorKey.currentState.context,
          MaterialPageRoute(
            builder: (context) => AcceptedOrderVC(
              objOrder: orderDetail,
            ),
            fullscreenDialog: false,
          ),
        );
      } else if (name.contains("accepted")) {
        Navigator.pushAndRemoveUntil(
            navigatorKey.currentState.context,
            MaterialPageRoute(
                builder: (context) => TabbarVC(), fullscreenDialog: false),
            (route) => false);
      } else {
        Navigator.push(
          navigatorKey.currentState.context,
          MaterialPageRoute(
            builder: (context) => OrderDetailVC(
              orderId: valueMap['package_id'],
              collectionId: message.data['collection_center_id'],
            ),
            fullscreenDialog: false,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    myAppContext = context;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Delivery Partner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashVC(),
    );
  }
}
