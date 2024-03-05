import 'dart:convert';

import 'package:countmee/Model/SupportDataModel.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:url_launcher/url_launcher.dart';

/*
Title : ContactUsVC
Purpose: ContactUsVC
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class ContactUsVC extends StatefulWidget {
  @override
  _ContactUsVCState createState() => _ContactUsVCState();
}

class _ContactUsVCState extends State<ContactUsVC> {
  final txtNameController = TextEditingController();
  final txtEmailController = TextEditingController();
  final txtMessageController = TextEditingController();

  List<SupportDataModel> arrSupportData = List.from([SupportDataModel()]);
  String supportEmail = "";
  String supportNumber = "";
  var orderId;
  var collectionId;
  var isNameEmpty = false;
  var isEmailEmpty = false;
  var isMsgEmpty = false;

  @override
  void initState() {
    super.initState();
    getSupportData();
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
          title: setCustomFont(
              "Contact Us", 20, textBlackColor, FontWeight.w600, 1),
          leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
            Navigator.pop(context);
          }, Colors.transparent, Colors.transparent, 0),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 35,
                ),
                setImageName("contactUsBanner.png", 223, 120),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 0,
                    ),
                    GestureDetector(
                      onTap: () {
                        var email = supportEmail;
                        _makePhoneCall('mailto:$email');
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            setImageName("iconSupportMail.png", 40, 40),
                            SizedBox(
                              height: 10,
                            ),
                            setCustomFont(
                              supportEmail ?? "",
                              14,
                              textBlackColor,
                              FontWeight.w400,
                              1,
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            boxShadow: [getdefaultShadow()]),
                        height: Device.screenWidth / 4,
                        width: Device.screenWidth / 2.5,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        var number = supportNumber;
                        _makePhoneCall('tel:$number');
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            setImageName("iconCall.png", 40, 40),
                            SizedBox(
                              height: 10,
                            ),
                            setCustomFont(
                              supportNumber ?? "",
                              14,
                              textBlackColor,
                              FontWeight.w400,
                              1,
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            boxShadow: [getdefaultShadow()]),
                        height: Device.screenWidth / 4,
                        width: Device.screenWidth / 2.5,
                      ),
                    ),
                    SizedBox(
                      width: 0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: setTextField(
                        txtNameController,
                        "Name",
                        false,
                        TextInputType.text,
                        isNameEmpty,
                        msgEmptyName,
                        (val) => {
                              setState(() {
                                isNameEmpty = false;
                              }),
                            })),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: setTextField(
                        txtEmailController,
                        "Email",
                        false,
                        TextInputType.text,
                        isEmailEmpty,
                        msgEmptyEmail,
                        (val) => {
                              setState(() {
                                isEmailEmpty = false;
                              }),
                            })),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: setTextFieldDynamic(
                        txtMessageController,
                        "Message",
                        false,
                        TextInputType.emailAddress,
                        14,
                        isMsgEmpty,
                        msgEmptyMsg,
                        (val) => {
                              setState(() {
                                isMsgEmpty = false;
                              }),
                            })),
                SizedBox(
                  height: 15,
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: 57,
                    child: setbuttonWithChild(
                        setCustomFont(
                            "Send", 16, Colors.white, FontWeight.w400, 1.2),
                        () {
                      if (connectionStatus == DataConnectionStatus.connected) {
                        sendSupportData();
                      } else {
                        showCustomToast(
                            "Please check your internet connection", context);
                      }
                    }, appColor, Colors.purple[900], 5)),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: orderId != null
                //       ? Container(child: _newTaskModalBottomSheet(context))
                //       : Container(),
                // ),
              ],
            ),
          ),
        )));
  }

  Future<void> _makePhoneCall(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // _newTaskModalBottomSheet(context) {
  //   afterDelay(1, () {
  //     showModalBottomSheet(
  //         backgroundColor: Colors.transparent,
  //         context: context,
  //         builder: (BuildContext context) {
  //           return NotificationBottomSheet(
  //             orderId: orderId,
  //             collectionId: collectionId,
  //           );
  //         });
  //   });
  // }

  sendSupportData() {
    if (txtNameController.text.trim() == "") {
      setState(() {
        isNameEmpty = true;
      });

      return;
    }

    if (txtEmailController.text.trim() == "") {
      setState(() {
        isEmailEmpty = true;
      });

      return;
    }

    if (txtMessageController.text.trim() == "") {
      setState(() {
        isMsgEmpty = true;
      });

      return;
    }
    FormData formData = FormData.fromMap({
      "name": txtNameController.text,
      "email": txtEmailController.text,
      "message": txtMessageController.text,
    });

    postDataRequestWithToken(sendSupportMessageAPI, formData, context)
        .then((value) {
      if (value is Map) {
        if (value[kStatusCode] == 200) {
          showGreenToast(
              "Your message has been submitted successfully", context);
          txtNameController.text = "";
          txtEmailController.text = "";
          txtMessageController.text = "";
        } else {
          showCustomToast(value[kMessage] as String, context);
        }
      } else {
        showCustomToast(value as String, context);
      }
    });
  }

  getSupportData() {
    postDataRequest(getSupportAPI, null).then((value) {
      if (value[kData] is List) {
        var arrData = value[kData]
            .map<SupportDataModel>((json) => SupportDataModel.fromJson(json))
            .toList();
        setState(() {
          arrSupportData = arrData;
        });

        supportData = arrSupportData;
        for (var items in arrSupportData) {
          if (items.type == "support_contact") {
            setState(() {
              supportNumber = items.name;
            });
          } else if (items.type == "support_mail") {
            setState(() {
              supportEmail = items.name;
            });
          }
        }
      }
    });
  }
}
