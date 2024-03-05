import 'package:countmee/Screens/DeliveryBoy/Login/LoginVC.dart';
import 'package:countmee/Screens/DeliveryBoy/Register/OTPVC.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/*
Title : OrderCell
Purpose: OrderCell
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class ChangePasswordVC extends StatefulWidget {
  final bool isFromRegister;
  final String phoneNumber;
  final bool isFromProfile;

  ChangePasswordVC(
      {Key key,
      @required this.isFromRegister,
      this.phoneNumber,
      this.isFromProfile})
      : super(key: key);
  @override
  _ChangePasswordVCState createState() => _ChangePasswordVCState();
}

class _ChangePasswordVCState extends State<ChangePasswordVC> {
  final txtNewPassword = TextEditingController();
  final txtOldPassword = TextEditingController();
  final txtConfirmPassword = TextEditingController();
  var isLoading = false;
  var isEmailValidation = false;
  var isEmailEmpty = false;
  var isOldPass = false;
  var isOldValidation = false;
  var isNewPass = false;
  var isNewValidation = false;
  var isConfPass = false;
  var isConfValidation = false;
  var isPasswordRegex = false;
  var isPasswordInvalid = false;
  bool shouldPop = true;
  bool isHidden = true;
  bool isHidden2 = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.isFromProfile
            ? Navigator.pop(context)
            : Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => OTPVC(
                          isFromRegister: false,
                          phoneNumber: widget.phoneNumber,
                        )));
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
                    "Reset Password", 20, textBlackColor, FontWeight.w700, 1),
                leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
                  Navigator.pop(context);
                }, Colors.transparent, Colors.transparent, 0),
              ),
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 35,
                          ),
                          setImageName("resetPasswordTop.png", 200, 150),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                            child: setCustomFont(
                                "Your new password must be different from previous used passwords.",
                                14,
                                textBlackColor,
                                FontWeight.w400,
                                1.9),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          widget.isFromProfile
                              ? Container(
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: setTextField(
                                      txtOldPassword,
                                      "Enter Old Password",
                                      true,
                                      TextInputType.text,
                                      isOldValidation,
                                      isOldPass
                                          ? msgEmptyOldPassword
                                          : msgInvalidPassword,
                                      () => {
                                            setState(() {
                                              isOldPass = false;
                                              isOldValidation = false;
                                            })
                                          }))
                              : Container(),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                            child: setTextFieldPassword(
                              txtNewPassword,
                              "Enter New Password",
                              isHidden,
                              TextInputType.text,
                              isNewValidation,
                              isNewPass
                                  ? msgEmptyNewPassword
                                  : msgInvalidPassword,
                              isHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              () {
                                makeVisible();
                              },
                              () => {
                                setState(() {
                                  isNewPass = false;
                                  isNewValidation = false;
                                })
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                              child: setTextFieldPassword(
                                  txtConfirmPassword,
                                  "Confirm New Password",
                                  isHidden2,
                                  TextInputType.emailAddress,
                                  isPasswordInvalid,
                                  isConfPass
                                      ? msgEmptyConfirmNewPassword
                                      : msgNewPasswordNotMatch,
                                  isHidden2
                                      ? Icons.visibility_off
                                      : Icons.visibility, () {
                                makeVisible2();
                              },
                                  () => {
                                        setState(() {
                                          isPasswordInvalid = false;
                                          isConfPass = false;
                                        })
                                      })),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width - 50,
                              height: 57,
                              child: setbuttonWithChild(
                                  isLoading
                                      ? Container(
                                          width: 30,
                                          height: 30,
                                          child: setButtonIndicator(
                                              4, Colors.white),
                                        )
                                      : setCustomFont(
                                          "Reset Password",
                                          16,
                                          Colors.white,
                                          FontWeight.w500,
                                          1), () {
                                if (connectionStatus ==
                                    DataConnectionStatus.connected) {
                                  widget.isFromProfile
                                      ? changePassword()
                                      : resetPassword();
                                } else {
                                  showCustomToast(
                                      "Please check your internet connection",
                                      context);
                                }
                              }, appColor, Colors.purple[900], 5)),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  setLoadingState(isLoading)
                ],
              ),
            ),
          )),
    );
  }

  void makeVisible() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  void makeVisible2() {
    setState(() {
      isHidden2 = !isHidden2;
    });
  }

  resetPassword() {
    FocusScope.of(context).unfocus();

    if (txtNewPassword.text.trim() == "") {
      setState(() {
        isNewValidation = true;
        isNewPass = true;
      });
      return;
    }
    if (!validatePassword(txtNewPassword.text.trim())) {
      setState(() {
        isNewValidation = true;
      });
      return;
    }

    if (txtConfirmPassword.text.trim() == "") {
      setState(() {
        isPasswordInvalid = true;
        isConfPass = true;
      });
      return;
    }

    if (txtNewPassword.text.trim() != txtConfirmPassword.text.trim()) {
      setState(() {
        isPasswordInvalid = true;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    FormData formData = FormData.fromMap({
      "phone_number": widget.phoneNumber,
      "password": txtNewPassword.text,
    });

    postDataRequestWithToken(newPasswordPostApi, formData, context)
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (value is Map) {
        if (value[kStatusCode] == 200) {
          AlertMessage(
            "Your password has been updated.",
            context,
            () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginVC()),
                  (route) => false);
            },
          );
        } else {
          showCustomToast(value[kMessage], context);
        }
      } else {
        showCustomToast(value as String, context);
      }
    });
  }

  changePassword() {
    FocusScope.of(context).unfocus();

    if (txtOldPassword.text.trim() == "") {
      setState(() {
        isOldValidation = true;
        isOldPass = true;
      });
      return;
    }
    if (!validatePassword(txtOldPassword.text.trim())) {
      setState(() {
        isOldValidation = true;
      });
      return;
    }

    if (txtNewPassword.text.trim() == "") {
      setState(() {
        isNewValidation = true;
        isNewPass = true;
      });
      return;
    }
    if (!validatePassword(txtNewPassword.text.trim())) {
      setState(() {
        isNewValidation = true;
      });
      return;
    }

    if (txtConfirmPassword.text.trim() == "") {
      setState(() {
        isPasswordInvalid = true;
        isConfPass = true;
      });
      return;
    }

    if (txtNewPassword.text.trim() != txtConfirmPassword.text.trim()) {
      setState(() {
        isPasswordInvalid = true;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });
    FormData formData = FormData.fromMap({
      "old_password": txtOldPassword.text,
      "new_password": txtNewPassword.text,
    });

    postDataRequestWithToken(changePasswordAPI, formData, context)
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (value is Map) {
        if (value[kStatusCode] == 200) {
          AlertMessage(
            "Your password has been updated.",
            context,
            () {
              Navigator.of(context).pop(false);
              Navigator.of(context).pop(false);
            },
          );
        } else {
          showCustomToast(value[kMessage], context);
        }
      } else {
        showCustomToast(value as String, context);
      }
    });
  }
}
