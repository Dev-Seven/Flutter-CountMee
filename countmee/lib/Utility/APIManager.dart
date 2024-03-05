import 'dart:convert';
import 'dart:io';
import 'package:countmee/Screens/DeliveryBoy/Login/LoginVC.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'Global.dart';

/*
Title : Global File
Purpose:  Global File
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

// var apiURL =  "http://3.23.153.100/countmee-courier/api/";
// var apiURL = "http://67.205.148.222/countmee-courier/api/";
var apiURL = "http://countmee.com/countmee-courier/api/";

const String loginApi = "login";
const String registerApi = "register";
const String registerVarificationApi = "register_verification";
const String checkOTP = "verify_otp";
const String resendOTPApi = "resend_otp";
const String addDeviceTrokenApi = "add_device_token";
const String logoutApi = "logout";
const String forgotPasswordApi = "forgot_password";
const String cmsPageApi = "cms_page";
const String newPasswordPostApi = "submit_reset_password";
// const String newPasswordPostApi = "forgot_pwd_post";
const String getUser = "get_user";
const String changePasswordAPI = "profile/change-password";
// const String changePasswordAPI = "submit_reset_password";
const String addCardAPI = "user/card/add";
const String getCardlistAPI = "user/card/list";
const String removeCard = "user/card/delete";
const String socialLoginAPI = "social_login";
const String autoLoginAPI = "auto_login";
const String getStateList = "state/list";
const String getCityList = "city/list";
const String getSettings = "settings";
const String getDeliveryLocation = "customer/updatelocation";

const String updateProfileAPI = "deliveryboy/updateprofile";
const String getProfileAPI = "deliveryboy/get-profile";
const String getSupportAPI = "support_data";
const String uploadDocAPI = "deliveryboy/upload-document";
const String getUploadedDocAPI = "deliveryboy/get-document";
const String getOrderCountAPI = "deliveryboy/order/dashboard-count";
const String getPastOrderAPI = "deliveryboy/order/past";
const String getRejectedOrderListAPI = "deliveryboy/order/rejected-list";
const String getPandingOrderListAPI = "deliveryboy/order/pending";
const String getDeliveredOrdersListAPI = "deliveryboy/order/delivered";
const String supportapi = "deliveryboy/support/send";
const String getOrderDetailAPI = "deliveryboy/order/detail";
const String acceptOrderAPI = "deliveryboy/order/accept";
const String rejectOrderAPI = "deliveryboy/order/reject";
const String collectionCentersApi = "collection-centers";
const String commissionListApi = "deliveryboy/commission/list";
const String deliverySuccessApi = "deliveryboy/order/delivery-success";
const String sendSupportMessageAPI = "customer/support/send";
const String deliveryVerificationAPI =
    "deliveryboy/order/send-verification-code";
const String notificationAPI = "deliveryboy/notification/list";
const String collectionCenterDetailsAPI = "collection-center-details";

const String authorisationToken =
    "eyJpdiI6IkcwRlgvS1pyYjZXZjJ0b212NkxNd0E9PSIsInZhbHVlIjoicDJjSW0zTFM3ZWk2bFp6VExMUUY2SU0zVXJVSU5wUmNGZHdQRy9lQkNuOS8vL1QvQU5tbzVrR3FBN1k4aTZ1MSIsIm1hYyI6ImEwMjViNjYzOGIwZTRiMTAxN2U5ZjM3OWJkZTk1OTY2MDg5YmExZWY5YzdlY2RjM2FmZWYxNTJjMGI3YzRmOGQifQ==";

void getHttp() async {
  try {
    Response response = await Dio().get("http://www.google.com");
  } catch (e) {
    print(e);
  }
}

Future<dynamic> getresponse(String url) async {
  try {
    Response response = await Dio().get(url);
    var responseJson = json.decode(response.data);
    if (response.statusCode == 200) {
      if (responseJson[kStatusCode] as int == 200) {
        return responseJson;
      } else {
        return responseJson[kMessage];
      }
    } else {
      return responseJson[kMessage];
    }
  } catch (e) {
    print(e);
  }
}

Future<dynamic> postDataRequest(String urlPath, FormData params) async {
  try {
    var header = Options(
      headers: {
        "AuthorizationUser": authorisationToken,
      },
    );
    Response<String> response =
        await Dio().post(apiURL + urlPath, data: params, options: header);
    var responseJson = json.decode(response.data);
    if (response.statusCode == 200) {
      if (responseJson[kStatusCode] as int == 200 ||
          responseJson[kStatusCode] as int == 102) {
        return responseJson;
      } else {
        return responseJson[kMessage];
      }
    } else {
      return responseJson[kMessage];
    }
  } catch (e) {
    return e.toString();
  }
}

Future<dynamic> postDataRequestWithToken(
    String urlPath, FormData params, BuildContext context) async {
  try {
    var header = Options(
      headers: {
        "authorization": "bearer" + userObj.token,
        "AuthorizationUser": authorisationToken,
      },
    );
    Response<String> response =
        await Dio().post(apiURL + urlPath, data: params, options: header);
    var responseJson = json.decode(response.data);

    if (response.statusCode == 200) {
      if (responseJson["status_code"] as int == 200) {
        return responseJson;
      } else if (responseJson["status_code"] as int == 500) {
        clearUserData();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginVC()),
            (Route<dynamic> route) => false);
        return;
      } else if (responseJson["status_code"] as int == 101) {
        showCustomToast(responseJson["message"], context);
        return;
      } else {
        return responseJson;
      }
    } else {
      return responseJson;
    }
  } catch (e) {
    return e.toString();
  }
}

Future<dynamic> postAPIRequestWithToken(
    String urlPath, FormData params, BuildContext context) async {
  try {
    var header = Options(
      headers: {
        "authorization": "bearer" + userObj.token,
        "AuthorizationUser": authorisationToken,
      },
    );
    Response<String> response =
        await Dio().post(apiURL + urlPath, data: params, options: header);
    var responseJson = json.decode(response.data);
    if (response.statusCode == 200) {
      if (responseJson[kStatusCode] as int == 500) {
        clearUserData();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginVC()),
            (Route<dynamic> route) => false);
        return;
      }
      return responseJson;
    } else {
      showCustomToast(responseJson[kMessage], context);
      return null;
    }
  } catch (e) {
    if (e is DioError) {
      var error = e;
      var errorDetail = error.error as SocketException;
      showCustomToast(errorDetail.osError.message.toString(), context);
      return errorDetail.osError.message.toString();
    }
    return e.toString();
  }
}
