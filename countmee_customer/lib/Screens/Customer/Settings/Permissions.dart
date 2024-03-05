import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:flutter/material.dart';

/*
Title : Permissions Screen
Purpose: Permissions Screen
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class Permissions extends StatefulWidget {
  const Permissions({Key key}) : super(key: key);

  @override
  _PermissionsState createState() => _PermissionsState();
}

class _PermissionsState extends State<Permissions> {
  var permissionList = [
    "Location Permission",
    "Camera Permission",
    "Storage Permission",
    "Contact Permission",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: setCustomFont(
            "Permissions", 20, textBlackColor, FontWeight.w600, 1),
        leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
          Navigator.pop(context);
        }, Colors.transparent, Colors.transparent, 0),
      ),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            shrinkWrap: false,
            itemCount: permissionList.length,
            itemBuilder: (context, position) {
              return Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      boxShadow: [getdefaultShadow()]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 50,
                      child: setCustomFont(permissionList[position], 16,
                          textBlackColor, FontWeight.w400, 1),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
