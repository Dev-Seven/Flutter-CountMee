import 'package:countmee/Screens/Customer/Login/LoginVC.dart';
import 'package:countmee/Screens/Customer/Profile/MyProfileVC.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/*
Title : ChangePassword Screen
Purpose: ChangePassword Screen
Created By : Kalpesh Khandla
Last Edited By : 3 Feb 2022
*/

class ChangePasswordVC extends StatefulWidget {
  final bool isFromRegister;
  final String phoneNumber;
  final bool isFromProfile;

  ChangePasswordVC({
    Key key,
    @required this.isFromRegister,
    @required this.phoneNumber,
    this.isFromProfile,
  }) : super(key: key);
  @override
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
  var isOldValidation = false;
  var isOldPassEmpty = false;
  var isNewPassEmpty = false;
  var isConfPassEmpty = false;
  var isPassword = false;
  var isConfirmEmpty = false;
  var isPasswordInvalid = false;
  var isPasswordRegex = false;
  var isOldPasswordRegex = false;
  bool isHidden = true;
  bool isHidden2 = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Center(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: setCustomFont(
                "Reset Password",
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
                                  isOldPasswordRegex,
                                  isOldPassEmpty
                                      ? msgEmptyOldPassword
                                      : msgInvalidPassword,
                                  (value) => {
                                    setState(() {
                                      isOldPassEmpty = false;
                                      isOldPasswordRegex = false;
                                    })
                                  },
                                ),
                              )
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
                            isPasswordRegex,
                            isPassword
                                ? msgEmptyNewPassword
                                : msgInvalidPassword,
                            isHidden ? Icons.visibility_off : Icons.visibility,
                            () {
                              makeVisible();
                            },
                            () => {
                              setState(() {
                                isPassword = false;
                                isPasswordRegex = false;
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
                                isConfirmEmpty
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
                                        isConfirmEmpty = false;
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
                                        child:
                                            setButtonIndicator(4, Colors.white),
                                      )
                                    : setCustomFont(
                                        "Reset Password",
                                        16,
                                        Colors.white,
                                        FontWeight.w500,
                                        1,
                                      ), () {
                              widget.isFromProfile
                                  ? changePassword()
                                  : resetPassword();
                            }, appColor, Colors.purple[900], 5)),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                setLoadingState(isLoading, context)
              ],
            ),
          ),
        ));
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
        isPasswordRegex = true;
        isPassword = true;
      });
      return;
    }
    if (!validatePassword(txtNewPassword.text.trim())) {
      setState(() {
        isPasswordRegex = true;
      });
      return;
    }

    if (txtConfirmPassword.text.trim() == "") {
      setState(() {
        isPasswordInvalid = true;
        isConfirmEmpty = true;
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
          AlertMessage("Your password has been updated.", context, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginVC()),
            );
          });
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
    String oldPass = txtOldPassword.text;
    String newPass = txtNewPassword.text;
    if (txtOldPassword.text.trim() == "") {
      setState(() {
        isOldPassEmpty = true;
        isOldPasswordRegex = true;
      });
      return;
    }
    if (!validatePassword(txtOldPassword.text.trim())) {
      setState(() {
        isOldPasswordRegex = true;
      });
      return;
    }

    if (txtNewPassword.text.trim() == "") {
      setState(() {
        isPasswordRegex = true;
        isPassword = true;
      });
      return;
    }
    if (!validatePassword(txtNewPassword.text.trim())) {
      setState(() {
        isPasswordRegex = true;
      });
      return;
    }

    if (txtConfirmPassword.text.trim() == "") {
      setState(() {
        isPasswordInvalid = true;
        isConfirmEmpty = true;
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
              Navigator.of(context).pop(false);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProfileVC()),
              );
            },
          );
        } else if (value[kStatusCode] == 500) {
          showCustomToast(
              'Something went wrong.\nplease check after sometime.', context);
        } else {
          showCustomToast(value[kMessage], context);
        }
      } else {
        showCustomToast(value as String, context);
      }
    });
  }
}
