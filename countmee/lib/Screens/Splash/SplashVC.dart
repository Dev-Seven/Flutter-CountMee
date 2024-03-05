import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:countmee/Screens/DeliveryBoy/Login/LoginVC.dart';
import 'package:countmee/Screens/DeliveryBoy/TabBar/TabBarVC.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as per;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_settings/app_settings.dart';
/*
Title : SplashVC
Purpose: SplashVC
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class SplashVC extends StatefulWidget {
  @override
  _SplashVCState createState() => _SplashVCState();
}

class _SplashVCState extends State<SplashVC> {
  bool isAllowTapOnce = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Platform.isIOS ? initPlugin() : showAlertDialog2();
    });
  }

  onDenyTap2() async {
    setState(() {
      isAllowTapOnce = false;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("IsAllow", isAllowTapOnce);

    afterDelay(1, () {
      if (userObj != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => TabbarVC(),
              fullscreenDialog: false,
            ),
            (route) => false);
      } else {
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
  }

  Future<void> showAlertDialog2() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _permissionGranted = await location.hasPermission();

    if (_permissionGranted != PermissionStatus.GRANTED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        showCustomTrackingDialog(context);
      } else {
        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          showCustomTrackingDialog2(context);
        } else {
          setState(() {
            isAllowTapOnce = true;
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("IsAllow", isAllowTapOnce);
          print("ALLOW TAPPED :$isAllowTapOnce");
          checkLocationStatus();
          getuserData();
          afterDelay(1, () {
            if (userObj != null) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => TabbarVC(),
                  fullscreenDialog: false,
                ),
                (route) => false,
              );
            } else {
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
        }
      }
    } else {
      _serviceEnabled = await location.serviceEnabled();
      print(_serviceEnabled);
      if (!_serviceEnabled) {
        showCustomTrackingDialog2(context);
      } else {
        setState(() {
          isAllowTapOnce = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("IsAllow", isAllowTapOnce);
        print("ALLOW TAPPED :$isAllowTapOnce");
        checkLocationStatus();
        getuserData();
        afterDelay(1, () {
          if (userObj != null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => TabbarVC(),
                fullscreenDialog: false,
              ),
              (route) => false,
            );
          } else {
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
      }
    }
  }

  String _authStatus = 'Unknown';
  Future<void> initPlugin() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      setState(() => _authStatus = '$status');
      // If the system can show an authorization request dialog
      if (status == TrackingStatus.denied) {
        // The user opted to never again see the permission request dialog for this
        // app. The only way to change the permission's status now is to let the
        // user manually enable it in the system settings.
        showCustomTrackingDialog(context);
      } else if (status == TrackingStatus.notDetermined) {
        final TrackingStatus status =
            await AppTrackingTransparency.requestTrackingAuthorization();
        setState(() => _authStatus = '$status');
        onDenyTap();
      } else {
        onDenyTap();
      }
    } on PlatformException {
      setState(() => _authStatus = 'PlatformException was thrown');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: setImageWithName("SplashBack.png"),
          ),
          Center(
            child: setImageName(
              "appLogo.png",
              Device.screenWidth / 2.5,
              Device.screenWidth / 2.5,
            ),
          )
        ],
      ),
    );
  }

  onDenyTap() async {
    print(_authStatus);
    if (_authStatus == "TrackingStatus.authorized") {
      setState(() {
        isAllowTapOnce = true;
      });
    } else {
      setState(() {
        isAllowTapOnce = false;
      });
      showCustomTrackingDialog(context);
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("IsAllow", isAllowTapOnce);

    afterDelay(1, () {
      if (userObj != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => TabbarVC(),
              fullscreenDialog: false,
            ),
            (route) => false);
      } else {
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
  }

  Future<void> showCustomTrackingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Column(
            children: [
              Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 80,
              ),
              Text(Platform.isIOS
                  ? 'Countmee Delivery Partner app collects location data to enable identification of nearby delivery partner even when app is closed or not in use. Please turn on \"Allow Tracking\" in Settings. You can change your choice anytime in the app settings.'
                  : 'Countmee Delivery Partner app collects location data to enable identification of nearby delivery partner even when app is closed or not in use. Please provide location access in Settings. You can change your choice anytime in the app settings.'),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              textStyle: TextStyle(color: Color.fromARGB(123, 244, 67, 54)),
              isDefaultAction: true,
              onPressed: () {
                per.openAppSettings();
              },
              child: Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

  Future<void> showCustomTrackingDialog2(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Column(
            children: [
              Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 80,
              ),
              Text(
                  'Please Turn On Location as Countmee Delivery Partner app collects location data to enable identification of nearby delivery partner even when app is closed or not in use.'),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              textStyle: TextStyle(color: Color.fromARGB(123, 244, 67, 54)),
              isDefaultAction: true,
              onPressed: () {
                AppSettings.openLocationSettings();
              },
              child: Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }
}
