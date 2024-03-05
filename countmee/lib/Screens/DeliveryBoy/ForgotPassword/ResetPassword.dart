import 'package:countmee/Screens/DeliveryBoy/Login/LoginVC.dart';
import 'package:countmee/Screens/DeliveryBoy/Register/OTPVC.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/*
Title : ResetPasswordVC
Purpose: ResetPasswordVC
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class ResetPasswordVC extends StatefulWidget {
  @override
  _ResetPasswordVCState createState() => _ResetPasswordVCState();
}

class _ResetPasswordVCState extends State<ResetPasswordVC> {
  final txtPhoneController = TextEditingController();
  var isLoading = false;
  var isPhoneValidation = false;
  var isPhoneEmpty = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnection(context);
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

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
                  "Forgot Password", 20, textBlackColor, FontWeight.w700, 1),
              leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginVC(),
                        fullscreenDialog: false));
              }, Colors.transparent, Colors.transparent, 0),
            ),
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 35,
                        ),
                        setImageName("forgotPasswordTop.png", 200, 150),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                          child: setCustomFont(
                              "Enter the mobile number associated with your account and we'll send an OTP to reset your password",
                              14,
                              textBlackColor,
                              FontWeight.w500,
                              1.9),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                            child: setTextFieldMobileNo(
                                txtPhoneController,
                                "Mobile Number",
                                10,
                                TextInputType.number,
                                isPhoneValidation,
                                isPhoneEmpty
                                    ? msgEmptyMobileNumber
                                    : msgInvalidPhoneNumber,
                                true,
                                () => {
                                      setState(() {
                                        isPhoneValidation = false;
                                      })
                                    })),
                        SizedBox(
                          height: 15,
                        ),
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
                                        child:
                                            setButtonIndicator(4, Colors.white),
                                      )
                                    : setCustomFont("Send OTP", 16,
                                        Colors.white, FontWeight.w500, 1),
                                _onSendOTPtap,
                                appColor,
                                Colors.purple[900],
                                5)),
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
        ));
  }

  _onSendOTPtap() {
    setState(() {});
    if (txtPhoneController.text.trim() == "") {
      isPhoneValidation = true;
      isPhoneEmpty = true;
      return;
    } else if (txtPhoneController.text.trim().length != 10) {
      isPhoneValidation = true;
      isPhoneEmpty = false;
      return;
    }
    setState(() {
      isLoading = true;
    });
    FormData formData = FormData.fromMap({
      "phone_number": txtPhoneController.text.trim(),
    });
    var emailString = txtPhoneController.text.trim();

    if (connectionStatus == DataConnectionStatus.connected) {
      postDataRequest(forgotPasswordApi, formData).then((value) => {
            if (value is Map)
              {
                setState(() {
                  isLoading = false;
                }),
                showGreenToast(value[kMessage].toString(), context),
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OTPVC(
                              isFromRegister: false,
                              phoneNumber: txtPhoneController.text,
                            ),
                        fullscreenDialog: false))
              }
            else
              {
                showCustomToast(value.toString(), context),
                setState(() {
                  isLoading = false;
                })
              },
          });
    } else {
      setState(() {
        isLoading = false;
      });
      showCustomToast("Please check your internet connection", context);
    }
  }
}
