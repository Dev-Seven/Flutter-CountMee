import 'package:countmee/Screens/Customer/Settings/SettingsVC.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:countmee/Model/SupportDataModel.dart';
import 'package:url_launcher/url_launcher.dart';

/*
Title : Contact Screen
Purpose: Contact Screen
Created By : Kalpesh Khandla
Last Edited By : 3 Feb 2022
*/

class SupportUsVc extends StatefulWidget {
  @override
  _ContactUsVCState createState() => _ContactUsVCState();
}

class _ContactUsVCState extends State<SupportUsVc> {
  final txtNameController = TextEditingController();
  final txtEmailController = TextEditingController();
  final txtMessageController = TextEditingController();
  var isEmailValidation = false;
  var isNameEmpty = false;
  var isEmailEmpty = false;
  var isMsgEmpty = false;

  List<SupportDataModel> arrSupportData = List.from([SupportDataModel()]);
  var supportEmail = "";
  var supportNumber = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getSupportData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title:
              setCustomFont("Support", 20, textBlackColor, FontWeight.w700, 1),
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
                SizedBox(height: 35),
                Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: setTextField(
                      txtNameController,
                      "Name",
                      false,
                      TextInputType.text,
                      isNameEmpty,
                      msgEmptyName,
                      (val) {
                        // txtNameController.text = val;

                        setState(() {
                          isNameEmpty = false;
                        });
                      },
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: setTextField(
                        txtEmailController,
                        "Email",
                        false,
                        TextInputType.emailAddress,
                        isEmailValidation,
                        isEmailEmpty ? msgEmptyEmail : msgInvalidEmail,
                        (val) => {
                              setState(() {
                                isEmailValidation = false;

                                isEmailEmpty = false;
                              })
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
                    TextInputType.text,
                    14,
                    isMsgEmpty,
                    msgEmptyMsg,
                    (val) => {
                      setState(() {
                        isMsgEmpty = false;
                      })
                    },
                    null,
                  ),
                ),
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
                      contactUs();
                    }, appColor, Colors.purple[900], 5)),
              ],
            ),
          ),
        )));
  }

  getSupportData() {
    setState(() {
      isLoading = true;
    });

    arrSupportData.clear();
    postDataRequest(getSupportAPI, null).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value[kData] is List) {
        var arrData = value[kData]
            .map<SupportDataModel>((json) => SupportDataModel.fromJson(json))
            .toList();
        arrSupportData = arrData;
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

  contactUs() {
    if (txtNameController.text.trim() == "") {
      setState(() {
        isNameEmpty = true;
      });

      return;
    }

    if (txtEmailController.text.trim() == "") {
      setState(() {
        isEmailValidation = true;
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
    if (!isEmail(txtEmailController.text)) {
      setState(() {
        isEmailValidation = true;
      });

      return;
    }

    FormData formData = FormData.fromMap({
      "name": txtNameController.text,
      "email": txtEmailController.text,
      "message": txtMessageController.text,
    });

    postDataRequestWithToken(supportapi, formData, context).then((value) {
      if (value is Map) {
        if (value[kStatusCode] == 200) {
          showGreenToast(
              "Your message has been submitted successfully", context);
          txtNameController.text = "";
          txtEmailController.text = "";
          txtMessageController.text = "";
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SettingsVC(), fullscreenDialog: false));
        } else if (value[kStatusCode] == 500) {
          showCustomToast(
              'Something went wrong.\nplease check after sometime.', context);
        } else {
          showCustomToast(value[kMessage] as String, context);
        }
      } else {
        showCustomToast(value as String, context);
      }
    });
  }

  Future<void> _makePhoneCall(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
