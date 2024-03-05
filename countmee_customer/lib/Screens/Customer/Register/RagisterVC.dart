import 'package:countmee/Screens/Customer/Register/OTPVC.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/CountryCode.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Model/UserModel.dart';
import '../../../Utility/APIManager.dart';
import '../../../main.dart';

/*
Title : RegisterVC Screen
Purpose: RegisterVC Screen
Created By : Kalpesh Khandla
Last Edited By : 3 Feb 2022
*/

class RegisterVC extends StatefulWidget {
  @override
  _RegisterVCState createState() => _RegisterVCState();
}

class _RegisterVCState extends State<RegisterVC> {
  final txtFirstNameController = TextEditingController();
  final txtLastNameController = TextEditingController();
  final txtEmailIDController = TextEditingController();
  final txtMobileNumberController = TextEditingController();
  final txtPasswordController = TextEditingController();
  final txtConfirmPasswordController = TextEditingController();
  final txtCountryCodeController = TextEditingController();

  var isLoading = false;
  var isEmailEmpty = false;
  var isFNameEmpty = false;
  var isLNameEmpty = false;

  var isPassword = false;
  var isConfirmEmpty = false;
  var isPasswordInvalid = false;
  var isPasswordRegex = false;
  var isEmailValidation = false;
  var isPhoneValidation = false;
  var isPhoneEmpty = false;
  var isPhoneInvalid = false;
  bool isHidden = true;
  bool isHidden2 = true;

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
                height: 820,
                child: Column(
                  children: [
                    setImageName("appLogo.png", 150, 150),
                    setCustomFont("Let's get started.", 16, textBlackColor,
                        FontWeight.w400, 1.5),
                    Container(
                        padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: setTextField(
                            txtFirstNameController,
                            "First Name",
                            false,
                            TextInputType.text,
                            isFNameEmpty,
                            msgEmptyFirstName,
                            (value) => {
                                  setState(() {
                                    isFNameEmpty = false;
                                  })
                                })),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: setTextField(
                        txtLastNameController,
                        "Last Name",
                        false,
                        TextInputType.text,
                        isLNameEmpty,
                        msgEmptyLastName,
                        (value) => {
                          setState(() {
                            isLNameEmpty = false;
                          })
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: setTextField(
                            txtEmailIDController,
                            "Email id",
                            false,
                            TextInputType.emailAddress,
                            isEmailValidation,
                            isEmailEmpty ? msgEmptyEmail : msgInvalidEmail,
                            (value) => {
                                  setState(() {
                                    isEmailValidation = false;
                                    isEmailEmpty = false;
                                  })
                                })),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 25,
                          ),
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
                              padding: const EdgeInsets.only(right: 23),
                              child: setTextFieldMobileNo(
                                  txtMobileNumberController,
                                  "Mobile No.",
                                  10,
                                  TextInputType.phone,
                                  isPhoneValidation,
                                  isPhoneEmpty
                                      ? msgEmptyMobileNumber
                                      : msgInvalidPhoneNumber,
                                  true,
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
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: setTextFieldPassword(
                        txtPasswordController,
                        "Password",
                        isHidden,
                        TextInputType.text,
                        isPasswordRegex,
                        isPassword ? msgEmptyPassword : msgInvalidPassword,
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
                            txtConfirmPasswordController,
                            "Confirm Password",
                            isHidden2,
                            TextInputType.text,
                            isPasswordInvalid,
                            isConfirmEmpty
                                ? msgEmptyConfirmPassword
                                : msgPasswordNotMatch,
                            isHidden2 ? Icons.visibility_off : Icons.visibility,
                            () {
                          makeVisiblePass2();
                        },
                            () => {
                                  setState(() {
                                    isPasswordInvalid = false;
                                    isConfirmEmpty = false;
                                  })
                                })),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 57,
                      child: setbuttonWithChild(
                          isLoading
                              ? Container(
                                  width: 30,
                                  height: 30,
                                  child: setButtonIndicator(4, Colors.white),
                                )
                              : setCustomFont("Sign Up", 16, Colors.white,
                                  FontWeight.w400, 1), () {
                        _onRegisterTap();
                      }, appColor, Colors.purple[900], 5),
                    ),
                    Spacer(),
                    setbuttonWithChild(
                        Text.rich(
                          TextSpan(
                            text: '',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                color: textBlackColor,
                                height: 1),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Already have a account? ",
                                  style: TextStyle()),
                              TextSpan(
                                text: 'Sign In',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    color: appColor,
                                    height: 1),
                              )
                            ],
                          ),
                        ),
                        _onLoginTap,
                        Colors.transparent,
                        Colors.transparent,
                        0),
                  ],
                ),
              ),
            ),
          ),
          setLoadingState(isLoading, context),
        ],
      ),
    );
  }

  onDropdownButtonTap() {
    FocusScope.of(context).unfocus();
    showCountryCodePopup();
  }

  showCountryCodePopup() {
    showGeneralDialog(
      pageBuilder: (c, a, a2) {},
      barrierDismissible: true,
      useRootNavigator: true,
      barrierLabel: "0",
      context: context,
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder:
          (BuildContext context, Animation a, Animation b, Widget child) {
        return Transform.scale(
          scale: a.value,
          child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width - 50,
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  shrinkWrap: false,
                  itemCount: country.length,
                  itemBuilder: (context, position) {
                    return InkWell(
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        txtCountryCodeController.text =
                            (country[position])["code"];
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              alignment: Alignment.centerLeft,
                              height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 80,
                                      child: setCustomFont(
                                          (country[position])["code"],
                                          14,
                                          textBlackColor,
                                          FontWeight.w400,
                                          1),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: setCustomFont(
                                        (country[position])["name"],
                                        14,
                                        textBlackColor,
                                        FontWeight.w400,
                                        1),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              child: Divider(
                                height: 1,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )),
        );
      },
    );
  }

  _onLoginTap() {
    Navigator.pop(context);
  }

  _onRegisterTap() {
    FocusScope.of(context).unfocus();

    if (txtFirstNameController.text.trim() == "") {
      setState(() {
        isFNameEmpty = true;
      });

      return;
    }

    if (txtLastNameController.text.trim() == "") {
      setState(() {
        isLNameEmpty = true;
      });

      return;
    }

    if (txtEmailIDController.text.trim() == "") {
      setState(() {
        isEmailValidation = true;
        isEmailEmpty = true;
      });

      return;
    }
    if (!isEmail(txtEmailIDController.text)) {
      setState(() {
        isEmailValidation = true;
      });

      return;
    }
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

    if (txtPasswordController.text.trim() == "") {
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
    }
    if (txtConfirmPasswordController.text.trim() == "") {
      setState(() {
        isPasswordInvalid = true;
        isConfirmEmpty = true;
      });
      return;
    }
    if (txtPasswordController.text.trim() !=
        txtConfirmPasswordController.text.trim()) {
      setState(() {
        isPasswordInvalid = true;
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    FormData formData = FormData.fromMap({
      "device_token": firebaseToken,
      "first_name": txtFirstNameController.text,
      "last_name": txtLastNameController.text,
      "email": txtEmailIDController.text,
      "phone_number": txtMobileNumberController.text,
      "password": txtPasswordController.text,
      "role": 4,
    });

    postDataRequest(registerApi, formData).then((value) => {
          setState(() {
            isLoading = false;
          }),
          if (value is Map)
            {_responseHandling(value[kData])}
          else
            {
              showCustomToast(value.toString(), context),
              setState(() {
                isLoading = false;
              })
            }
        });
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

  void makeVisible() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  void makeVisiblePass2() {
    setState(() {
      isHidden2 = !isHidden2;
    });
  }
}
