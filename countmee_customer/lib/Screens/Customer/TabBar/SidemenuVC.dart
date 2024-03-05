import 'package:countmee/Screens/Customer/Login/LoginVC.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:package_info_plus/package_info_plus.dart';
/*
Title : SideMenuVC Screen
Purpose: SideMenuVC Screen
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class SideMenuVC extends StatefulWidget {
  @override
  _SideMenuVCState createState() => _SideMenuVCState();
}

class _SideMenuVCState extends State<SideMenuVC> {
  var menuList = [
    {"image": "iconHome.png", "title": "Home", "selected": true},
    {"image": "iconProfile.png", "title": "Profile", "selected": false},
    {"image": "iconMyOrder.png", "title": "My Orders", "selected": false},
    {
      "image": "iconNotification.png",
      "title": "Notifications",
      "selected": false
    },
    {"image": "iconSettings.png", "title": "Settings", "selected": false},
    {"image": "iconContactUS.png", "title": "Contact us", "selected": false},
  ];

  var observerName = [
    "PushToHome",
    "PushToProfile",
    "PushToOrderSummary",
    "PushToNotification",
    "PushToSettings",
    "PushToContactUs",
  ];

  var selectedIndex = 0;
  var isLogingout = false;

  @override
  void initState() {
    super.initState();
    a();
  }

  String v;
  a() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      v = "v" + packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: userObj == null
          ? Container()
          : Container(
              padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    setCustomFont(
                        userObj.name.isEmpty
                            ? userObj.phoneNumber
                            : userObj.name,
                        16,
                        textBlackColor,
                        FontWeight.w800,
                        1),
                    SizedBox(
                      height: 10,
                    ),
                    setCustomFont(userObj.email == null ? " " : userObj.email,
                        14, textBlackColor, FontWeight.w400, 1),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.46,
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        shrinkWrap: false,
                        itemCount: menuList.length,
                        itemBuilder: (context, position) {
                          return InkWell(
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                for (var item in menuList) {
                                  item["selected"] = false;
                                }
                                (menuList[position])["selected"] = true;

                                selectedIndex = position;
                                Navigator.pop(context);
                                fireObserver(observerName[position]);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                              child: Row(
                                children: [
                                  setImageNameColor(
                                      (menuList[position])["image"],
                                      25,
                                      25,
                                      ((menuList[position])["selected"] as bool)
                                          ? appColor
                                          : Color.fromRGBO(38, 46, 58, 1)),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  setCustomFont(
                                      (menuList[position])["title"],
                                      16,
                                      ((menuList[position])["selected"] as bool)
                                          ? appColor
                                          : Color.fromRGBO(38, 46, 58, 1),
                                      FontWeight.w500,
                                      1)
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                        ),
                        Column(children: [
                          Text(
                            v,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          setbuttonWithChild(
                              setImageName("iconLogout.png", 70, 70), () {
                            showAlertDialog(context);
                          }, Colors.transparent, Colors.transparent, 0),
                        ]),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  fireObserver(String name) {
    Map sytListMap = Map();
    sytListMap[name] = true;
    Observable().notifyObservers([
      "_HomeVCState",
    ], map: sytListMap);
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "Logout",
            style: TextStyle(fontSize: 18),
          ),
          content: Text(
            "Are you sure want to logout?",
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              textStyle: TextStyle(color: Colors.red, fontSize: 18),
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("No"),
            ),
            CupertinoDialogAction(
              textStyle: TextStyle(color: appColor, fontSize: 18),
              isDefaultAction: true,
              onPressed: () async {
                setState(() {
                  isLogingout = true;
                });
                postAPIRequestWithToken(logoutApi, null, context).then((value) {
                  setState(() {
                    isLogingout = false;
                  });
                  clearUserData();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginVC()),
                      (Route<dynamic> route) => false);
                });
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showLogoutDialog() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Logout'),
            content: Text('Are you sure want to logout?'),
            actions: <Widget>[
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: TextStyle(color: appColor),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  setState(() {
                    isLogingout = true;
                  });
                  postAPIRequestWithToken(logoutApi, null, context)
                      .then((value) {
                    setState(() {
                      isLogingout = true;
                    });

                    //clearUserData();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginVC()),
                        (Route<dynamic> route) => false);
                  });
                },
                /*Navigator.of(context).pop(true)*/
                child: Text(
                  'Yes',
                  style: TextStyle(color: appColor),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
