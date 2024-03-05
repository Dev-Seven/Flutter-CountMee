import 'package:countmee/Screens/Customer/Home/HomeVC.dart';
import 'package:countmee/Screens/Customer/Login/LoginVC.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

/*
Title : Onboarding Screen of a App
Purpose:Onboarding Screen of a App
Created By : Kalpesh Khandla
Last Edited By : 3 Feb 2022
*/

class SplashVC extends StatefulWidget {
  @override
  _SplashVCState createState() => _SplashVCState();
}

class _SplashVCState extends State<SplashVC> {
  @override
  void initState() {
    super.initState();
    checkLocationStatus();

    /* For getting user data */
    getuserData();

    afterDelay(3, () {
      if (userObj != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeVC(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            child: setImageWithName("SplashBack.png"),
          ),
          Center(
            child: setImageName(
              "appLogo.png",
              MediaQuery.of(context).size.height / 2.5,
              MediaQuery.of(context).size.width / 2.5,
            ),
          )
        ],
      ),
    );
  }
}
