import 'dart:convert';

import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'SettingsCell.dart';

/*
Title : SettingsVC
Purpose: SettingsVC
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class SettingsVC extends StatefulWidget {
  @override
  _SettingsVCState createState() => _SettingsVCState();
}

class _SettingsVCState extends State<SettingsVC> {
  var menuList = [
    "Permissions",
    "About Us",
    "Send Feedback",
    "Support",
  ];
  var orderId;
  var collectionId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        print('onMessage.....');
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;
        Map valueMap = json.decode(message.data['moredata']);
        orderId = valueMap['package_id'];
        collectionId = valueMap['collection_center_id'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title:
            setCustomFont("Settings", 20, textBlackColor, FontWeight.w600, 1),
        leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
          Navigator.pop(context);
        }, Colors.transparent, Colors.transparent, 0),
      ),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            shrinkWrap: false,
            itemCount: menuList.length,
            itemBuilder: (context, position) {
              return SettingsCell(
                title: menuList[position],
              );
            },
          ),
        ),
      ),
    );
  }
}
