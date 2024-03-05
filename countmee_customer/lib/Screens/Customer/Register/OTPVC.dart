import 'package:countmee/Model/UserModel.dart';
import 'package:countmee/Screens/Customer/ForgotPassword/ChasngePasswordVC.dart';
import 'package:countmee/Screens/Customer/Home/HomeVC.dart';
import 'package:countmee/Screens/Customer/Location/LocationVC.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:sms_autofill/sms_autofill.dart';

/*
Title : OTPVC Screen
Purpose: OTPVC Screen
Created By : Kalpesh Khandla
Last Edited By : 3 Feb 2022
*/

class OTPVC extends StatefulWidget {
  final bool isFromRegister;
  final String phoneNumber;

  OTPVC({
    Key key,
    @required this.isFromRegister,
    @required this.phoneNumber,
  }) : super(key: key);
  @override
  _OTPVCState createState() => _OTPVCState();
}

class _OTPVCState extends State<OTPVC> with CodeAutoFill {
  var controller = TextEditingController();
  bool hasError = false;
  var isButtonEnable = false;
  var isLoading = false;
  var isResendOTP = false;
  var strOTP = "";
  var maskedNewEmail = "";
  bool shouldPop = false;
  String firebaseToken = "";

  @override
  void codeUpdated() {
    setState(() {
      controller.text = code;
    });
  }

  @override
  void initState() {
    super.initState();
    getToken();
    try {
      listenForCode();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    cancel();
  }

  getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.requestPermission();
    firebaseToken = await messaging.getToken();

    print("FIREBASE CUSTOMER DEVICE TOKEN : $firebaseToken");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Center(
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: setCustomFont(
                  "Verification",
                  20,
                  textBlackColor,
                  FontWeight.w700,
                  1,
                ),
                leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
                  Navigator.pop(context);
                }, Colors.transparent, Colors.transparent, 0),
              ),
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          setImageName("verificationTop.png", 200, 170),
                          SizedBox(
                            height: 25,
                          ),
                          setCustomFont("You will get OTP via SMS", 16,
                              textBlackColor, FontWeight.w400, 1.5),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            width: MediaQuery.of(context).size.width,
                            height: 57,
                            child: PinCodeTextField(
                              autofocus: false,
                              controller: controller,
                              hideCharacter: false,
                              highlight: true,
                              pinBoxOuterPadding: EdgeInsets.fromLTRB(
                                  MediaQuery.of(context).size.width / 22,
                                  0,
                                  MediaQuery.of(context).size.width / 22,
                                  0),
                              highlightColor: Color.fromRGBO(223, 223, 223, 1),
                              defaultBorderColor:
                                  Color.fromRGBO(223, 223, 223, 1),
                              hasTextBorderColor:
                                  Color.fromRGBO(223, 223, 223, 1),
                              highlightPinBoxColor: Colors.transparent,
                              pinBoxBorderWidth: 1,
                              pinBoxRadius: 5,
                              maxLength: 4,
                              hasError: hasError,
                              onTextChanged: (text) {
                                setState(() {
                                  strOTP = text;
                                  hasError = false;
                                  // if (strOTP.length == 4) {
                                  //   _onSubmitTap();
                                  // }
                                });
                              },
                              pinBoxWidth: 57,
                              pinBoxHeight: 57,
                              hasUnderline: false,
                              wrapAlignment: WrapAlignment.center,
                              pinBoxDecoration: ProvidedPinBoxDecoration
                                  .defaultPinBoxDecoration,
                              pinTextStyle: TextStyle(fontSize: 22.0),
                              pinTextAnimatedSwitcherTransition:
                                  ProvidedPinBoxTextAnimation.scalingTransition,
                              pinTextAnimatedSwitcherDuration:
                                  Duration(milliseconds: 300),
                              highlightAnimationBeginColor: Colors.black,
                              highlightAnimationEndColor: Colors.white12,
                              keyboardType: TextInputType.number,
                            ),
                            // child: PinCodeTextField(
                            //   appContext: context,
                            //   enableActiveFill: true,
                            //   controller: controller,
                            //   obscureText: false,
                            //   cursorColor: Colors.transparent,
                            //   animationDuration: Duration(milliseconds: 300),
                            //   pinTheme: PinTheme(
                            //     shape: PinCodeFieldShape.box,
                            //     borderRadius: BorderRadius.circular(5),
                            //     borderWidth: 1,
                            //     fieldWidth: 57,
                            //     fieldHeight: 57,
                            //     inactiveFillColor: Colors.white,
                            //     inactiveColor: Color.fromRGBO(223, 223, 223, 1),
                            //     selectedColor: Color.fromRGBO(223, 223, 223, 1),
                            //     selectedFillColor: Colors.white,
                            //     activeFillColor: Colors.white,
                            //     activeColor: Color.fromRGBO(223, 223, 223, 1),
                            //   ),
                            //   length: 4,
                            //   onChanged: (text) {
                            //     setState(() {
                            //       strOTP = text;
                            //       hasError = false;
                            //     });
                            //   },
                            //   onCompleted: (val) {
                            //     _onSubmitTap();
                            //   },
                            //   keyboardType: TextInputType.number,
                            // ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              width: MediaQuery.of(context).size.width,
                              height: 57,
                              child: setbuttonWithChild(
                                  isLoading
                                      ? Container(
                                          width: 30,
                                          height: 30,
                                          child: setButtonIndicator(
                                              4, Colors.white),
                                        )
                                      : setCustomFont("Verify", 16,
                                          Colors.white, FontWeight.w400, 1),
                                  _onSubmitTap,
                                  appColor,
                                  Colors.purple[900],
                                  5)),
                          SizedBox(
                            height: 25,
                          ),
                          setCustomFont("Didn't receive the verification OTP?",
                              16, textBlackColor, FontWeight.w400, 1),
                          Container(
                            width: 200,
                            alignment: Alignment.center,
                            child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                // focusColor: Colors.transparent,
                                // highlightColor: Colors.transparent,
                                // hoverColor: Colors.transparent,
                                // splashColor: Colors.transparent,
                                onPressed: _onresendOTPTap,
                                child: isResendOTP
                                    ? Container(
                                        width: 30,
                                        height: 30,
                                        child: setButtonIndicator(3, appColor),
                                      )
                                    : Container(
                                        alignment: Alignment.center,
                                        child: setCustomFont("Resend OTP", 12,
                                            appColor, FontWeight.w400, 1),
                                      )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  setLoadingState(isLoading, context)
                ],
              ),
            ),
          )),
    );
  }

  _onSubmitTap() {
    if (widget.isFromRegister) {
      FocusScope.of(context).unfocus();
      if (strOTP.length < 1) {
        showCustomToast("Verification code is required", context);
        return;
      } else if (strOTP.length < 4) {
        showCustomToast("Please enter correct OTP", context);
        return;
      }
      setState(() {
        isLoading = true;
      });

      FormData formData = FormData.fromMap({
        "phone_number": widget.phoneNumber,
        "otp": strOTP,
        "device_token": firebaseToken,
      });

      postDataRequest(checkOTP, formData).then((value) => {
            setState(() {
              isLoading = false;
            }),
            if (value is Map)
              {
                _responseHandling(value[kData]),
                userObj = UserModel.fromJson(value[kData]),
                setUserData(),
                if (widget.isFromRegister)
                  {
                    if (userObj.latitude != null)
                      {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeVC(),
                            fullscreenDialog: false,
                          ),
                          (route) => false,
                        ),
                      }
                    else
                      {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationVC(),
                            fullscreenDialog: false,
                          ),
                          (route) => false,
                        ),
                      }
                  }
                else
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePasswordVC(
                            isFromRegister: true,
                            phoneNumber: widget.phoneNumber,
                            isFromProfile: false,
                          ),
                          fullscreenDialog: false,
                        ))
                  }
              }
            else
              {showCustomToast(value.toString(), context)},
          });
    } else {
      FocusScope.of(context).unfocus();
      if (strOTP.length < 1) {
        showCustomToast("Verification code is required", context);
        return;
      } else if (strOTP.length < 4) {
        showCustomToast("Please enter correct OTP", context);
        return;
      }
      setState(() {
        isLoading = true;
      });

      FormData formData = FormData.fromMap({
        "phone_number": widget.phoneNumber,
        "otp": strOTP,
        "device_token": firebaseToken,
      });

      postDataRequest(checkOTP, formData).then((value) => {
            setState(() {
              isLoading = false;
            }),
            print(value),
            if (value is Map)
              {
                _responseHandling(value[kData]),
                userObj = UserModel.fromJson(value[kData]),
                setUserData(),
                if (widget.isFromRegister)
                  {
                    if (userObj.latitude != null)
                      {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeVC(),
                            fullscreenDialog: false,
                          ),
                          (route) => false,
                        ),
                      }
                    else
                      {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationVC(),
                            fullscreenDialog: false,
                          ),
                          (route) => false,
                        ),
                      }
                  }
                else
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePasswordVC(
                            isFromRegister: true,
                            phoneNumber: widget.phoneNumber,
                            isFromProfile: false,
                          ),
                          fullscreenDialog: false,
                        ))
                  }
              }
            else
              {showCustomToast(value.toString(), context)},
          });
    }
  }

  _responseHandling(userData) {
    UserModel user = UserModel.fromJson(userData);
    userObj = user;
    setUserData();
    setState(() {
      isLoading = false;
    });

    if (user.isConfirm == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTPVC(
                    isFromRegister: true,
                    phoneNumber: userObj.phoneNumber,
                  ),
              fullscreenDialog: false));
    } else {}
  }

  _onresendOTPTap() {
    setState(() {
      isResendOTP = true;
    });
    FormData formData = FormData.fromMap({
      "phone_number": widget.phoneNumber,
    });
    postDataRequest(resendOTPApi, formData).then((value) => {
          setState(() {
            isResendOTP = false;
          }),
          if (value is Map)
            {
              listenForCode(),
              showGreenToast(value[kMessage].toString(), context),
            }
          else
            {
              showCustomToast(value.toString(), context),
              setState(() {
                isLoading = false;
              })
            },
        });
  }
}
