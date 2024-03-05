import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:flutter/material.dart';
import 'SettingsCell.dart';

/*
Title : SettingsCell Screen
Purpose: SettingsCell Screen
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title:
            setCustomFont("Settings", 20, textBlackColor, FontWeight.w700, 1),
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
