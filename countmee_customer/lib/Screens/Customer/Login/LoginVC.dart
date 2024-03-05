import 'package:countmee/Screens/Customer/ForgotPassword/ResetPassword.dart';
import 'package:countmee/Screens/Customer/Register/OTPVC.dart';

import 'package:countmee/Screens/Customer/Register/RagisterVC.dart';
import 'package:countmee/Screens/Customer/Register/VerifyUser.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Model/UserModel.dart';
import '../../../Utility/APIManager.dart';

/*
Title : Login  Screen
Purpose: To check whether user is logged in or not
Created By : Kalpesh Khandla
Last Edited By : 3 Feb 2022
*/

class LoginVC extends StatefulWidget {
  @override
  _LoginVCState createState() => _LoginVCState();
}

class _LoginVCState extends State<LoginVC> {
  var controller = TextEditingController();
  bool hasError = false;
  var isButtonEnable = false;
  bool isChecked = false;
  var isResendOTP = false;
  var strOTP = "";
  var maskedNewEmail = "";
  bool shouldPop = false;
  final txtEmailController = TextEditingController();
  final txtMobileNumberController = TextEditingController();
  var isPhoneValidation = false;
  var isPhoneEmpty = false;
  var isPhoneInvalid = false;
  final txtCountryCodeController = TextEditingController();
  final txtPasswordController = TextEditingController();
  var isEmailValidation = false;
  var isEmailInvalid = false;
  var isEmailEmpty = false;
  var isPasswordEmpty = false;
  var isLoading = false;
  var checkBoxValue = false;
  bool rememberMe = false;
  var isPasswordRegex = false;
  var isPassword = false;
  bool isHidden = true;
  String appSignature;

  @override
  void initState() {
    super.initState();
    //checkLocationStatus();
    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
      });
    });
    checkConnection(context);
    getStringValueWithKey("ClientRemember").then((value) => {
          setState(() {
            if (value != null) {
              txtMobileNumberController.text = value;
              value.length > 0 ? rememberMe = true : rememberMe = false;
              checkBoxValue = rememberMe;
            }
          })
        });
  }

  _launchURLBrowser() async {
    const url = 'http://countmee.com/terms-conditions.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: Device.screenWidth,
                height: MediaQuery.of(context).size.height * 0.95,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),

                      // Image.asset(
                      //   "assets/images/appLogo.png",
                      //   height: 150,
                      //   width: 150,
                      // ),

                      setImageName(
                        "appLogo.png",
                        150,
                        150,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      setCustomFont("Please sign in to your account.", 16,
                          textBlackColor, FontWeight.w400, 1.5),
                      SizedBox(
                        height: 30,
                      ),
                      /*Container(
                        child: setTextField(
                            txtEmailController,
                            "Email id",
                            false,
                            TextInputType.text,
                            isEmailValidation,
                            isEmailEmpty ? msgEmptyEmail : msgInvalidEmail,
                            (value) => {
                                  setState(() {
                                    isEmailValidation = false;
                                    isEmailEmpty = false;
                                  })
                                }),
                      ),*/
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              height: isPhoneValidation ? 80 : 57,
                              child: Stack(
                                children: [
                                  Theme(
                                      data: new ThemeData(),
                                      child: TextField(
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black,
                                            height: 1.2),
                                        enabled: false,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        controller: txtCountryCodeController,
                                        onChanged: (value) => {},
                                        decoration: InputDecoration(
                                          errorMaxLines: 3,
                                          errorText: null,
                                          isDense: true,
                                          contentPadding:
                                              EdgeInsets.fromLTRB(8, 30, 0, 10),
                                          disabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromRGBO(
                                                    244, 247, 250, 1),
                                                width: 1),
                                          ),
                                          border: new OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              borderSide: new BorderSide(
                                                  color: Color.fromRGBO(
                                                      244, 247, 250, 1))),
                                          filled: false,
                                          fillColor: backgroundColor,
                                          hintText: "+91",
                                          hintStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  164, 165, 169, 1),
                                              fontFamily: popinsRegFont,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    244, 247, 250, 1)),
                                          ),
                                        ),
                                        cursorColor: Colors.black,
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.only(right: 0),
                                child: setTextFieldMobileNo(
                                    txtMobileNumberController,
                                    "Mobile No.",
                                    10,
                                    TextInputType.phone,
                                    isPhoneValidation,
                                    isPhoneEmpty
                                        ? msgEmptyMobileNumber
                                        : msgInvalidPhoneNumber,
                                    false,
                                    (value) => {
                                          setState(() {
                                            isPhoneValidation = false;
                                          })
                                        }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // ?
                      // Container(
                      //     child: setTextFieldPassword(
                      //         txtPasswordController,
                      //         "Password",
                      //         isHidden,
                      //         TextInputType.text,
                      //         isPasswordRegex,
                      //         isPassword
                      //             ? msgEmptyPassword
                      //             : msgInvalidPassword,
                      //         isHidden
                      //             ? Icons.visibility_off
                      //             : Icons.visibility, () {
                      //   makeVisible();
                      // },
                      //         () => {
                      //               setState(() {
                      //                 isPassword = false;
                      //                 isPasswordRegex = false;
                      //               }),
                      //             })),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Container(
                      //         child: InkWell(
                      //       focusColor: Colors.transparent,
                      //       highlightColor: Colors.transparent,
                      //       hoverColor: Colors.transparent,
                      //       splashColor: Colors.transparent,
                      //       onTap: () {
                      //         setState(() {
                      //           checkBoxValue = !checkBoxValue;
                      //           rememberMe = checkBoxValue;
                      //         });
                      //       },
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //             color: checkBoxValue
                      //                 ? appColor
                      //                 : Colors.transparent,
                      //             border: Border.all(color: appColor),
                      //             borderRadius: BorderRadius.all(
                      //               Radius.circular(4),
                      //             )),
                      //         child: Padding(
                      //           padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      //           child: checkBoxValue
                      //               ? Icon(
                      //                   Icons.check,
                      //                   size: 21.0,
                      //                   color: Colors.white,
                      //                 )
                      //               : Container(
                      //                   width: 21,
                      //                   height: 21,
                      //                 ),
                      //         ),
                      //       ),
                      //     )),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     Container(
                      //       alignment: Alignment.center,
                      //       height: 25,
                      //       child: setCustomFont("Remember me", 14,
                      //           textBlackColor, FontWeight.w400, 1),
                      //     ),
                      //     Spacer(),
                      //     InkWell(
                      //       onTap: () {
                      //         _onForgotPasswordTap();
                      //       },
                      //       child: Container(
                      //         alignment: Alignment.center,
                      //         height: 25,
                      //         child: setCustomFont("Forgot Password?", 14,
                      //             textBlackColor, FontWeight.w400, 1),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Checkbox(
                                activeColor: Colors.green,
                                // visualDensity:
                                //     VisualDensity(horizontal: -4, vertical: -4),
                                // materialTapTargetSize:
                                //     MaterialTapTargetSize.shrinkWrap,
                                value: isChecked,
                                onChanged: (n) {
                                  setState(() {
                                    isChecked = n;
                                  });
                                }),
                          ),
                          Container(
                            //width: MediaQuery.of(context).size.width * 0.75,
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                setCustomFontLeftAlignment("I agree with ", 15,
                                    textBlackColor, FontWeight.w400, 1.5),
                                InkWell(
                                  onTap: () {
                                    _launchURLBrowser();
                                  },
                                  child: setCustomFontLeftAlignment(
                                      "Terms and Conditions.",
                                      15,
                                      textBlackColor,
                                      FontWeight.w600,
                                      1.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 57,
                          child: setbuttonWithChild(
                              isLoading
                                  ? Container(
                                      width: 30,
                                      height: 30,
                                      child:
                                          setButtonIndicator(3, Colors.white),
                                    )
                                  : setCustomFont("Send OTP", 16, Colors.white,
                                      FontWeight.w400, 1.2),
                              _onLoginTap,
                              appColor,
                              Colors.purple[900],
                              5)),
                      Spacer(),
                      // FlatButton(
                      //   onPressed: _onRegistertap,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text.rich(
                      //         TextSpan(
                      //           text: '',
                      //           style: GoogleFonts.poppins(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.w400,
                      //               fontStyle: FontStyle.normal,
                      //               color: textBlackColor,
                      //               height: 1),
                      //           children: <TextSpan>[
                      //             TextSpan(
                      //                 text: "Don’t have an account? ",
                      //                 style: TextStyle()),
                      //             TextSpan(
                      //               text: 'Sign Up',
                      //               style: GoogleFonts.poppins(
                      //                   fontSize: 16,
                      //                   fontWeight: FontWeight.w400,
                      //                   fontStyle: FontStyle.normal,
                      //                   color: appColor,
                      //                   height: 1),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void makeVisible() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  _onRegistertap() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegisterVC(), fullscreenDialog: false));
  }

  _onLoginTap() {
    FocusScope.of(context).unfocus();
    if (connectionStatus == DataConnectionStatus.connected) {
      if (txtMobileNumberController.text.trim() == "") {
        setState(() {
          isPhoneValidation = true;
          isPhoneEmpty = true;
          isPhoneInvalid = false;
        });
        setState(() {
          isPhoneEmpty = true;
        });
        return;
      }
      if (txtMobileNumberController.text.trim().length != 10) {
        setState(() {
          isPhoneValidation = true;
          isPhoneEmpty = false;
          isPhoneInvalid = true;
        });
        return;
      }

      /*FocusScope.of(context).unfocus();
    if (txtEmailController.text.trim() == "") {
      isEmailValidation = true;
      isEmailEmpty = true;
      return;
    }
    if (!isEmail(txtEmailController.text)) {
      isEmailValidation = true;
      return;
    }*/

      /*if (txtPasswordController.text.trim() == "") {
      setState(() {
        isPasswordRegex = true;
        isPassword = true;
      });
      return;
    }
    if (!validatePassword(txtPasswordController.text.trim())) {
      setState(() {
        isPasswordRegex = true;
      });
      return;
    }*/
      if (isChecked == true) {
        setState(() {
          isLoading = true;
        });
        setStringValueWithKey(
          rememberMe ? txtMobileNumberController.text : "",
          "ClientRemember",
        );

        FormData formData = FormData.fromMap({
          "phone_number": txtMobileNumberController.text,
          "hash_code":
              appSignature.isNotEmpty ? appSignature.toString() : 'gqQjGduG8LK',
          "role": 4,
        });

        postDataRequest(loginApi, formData).then((value) => {
              setState(() {
                isLoading = false;
              }),
              if (value is Map)
                {
                  if (value[kStatusCode] as int == 102)
                    {
                      notVerifiedUser(
                        value["data"]["phone_number"],
                      )
                    }
                  else
                    {
                      _responseHandling(value[kData]),
                    }
                }
              else
                {
                  showCustomToast(value.toString(), context),
                },
            });
      } else {
        showCustomToast("Please accept Terms and Conditions.", context);
      }
    } else {
      print(connectionStatus);
      showCustomToast("Please check your internet connection", context);
    }
  }

  _responseHandling(userData) async {
    UserModel user = UserModel.fromJson(userData);
    userObj = user;
    //setUserData();
    print(user.role);
    if (user.role == 4) {
      if (user.isConfirm == 0 || user.isConfirm == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OTPVC(
                      isFromRegister: true,
                      phoneNumber: userObj.phoneNumber,
                    ),
                fullscreenDialog: false));
      } else {
        print("LOGINB ELSE PART");
      }
    } else {
      showCustomToast("Entered mobile no. is already in use", context);
    }
  }

  notVerifiedUser(String number) {
    FormData formData = FormData.fromMap({"phone_number": number});

    postDataRequest(resendOTPApi, formData).then((value) {
      if (value is Map) {
        pushToViewController(
            context,
            VerifyUser(
              phoneNumber: number,
            ),
            () {});
      } else {
        showCustomToast(value, context);
      }
    });
  }

  _onForgotPasswordTap() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResetPasswordVC(), fullscreenDialog: false));
  }
}
