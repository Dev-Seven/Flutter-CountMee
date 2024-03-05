import 'dart:convert';
import 'dart:io';

import 'package:countmee/Screens/Customer/Login/LoginVC.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'Constant.dart';
import 'Global.dart';

/*
Title : API Manager 
Purpose: API Manager base class for defining BaseURL along with their end points
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

//var apiURL =
//  "http://3.23.153.100/countmee-courier/api/";

// Live URL
// var apiURL = "http://3.23.153.100/countmee-courier/api/";
var apiURL = "http://countmee.com/countmee-courier/api/";

// var apiURL = "http://67.205.148.222/countmee-courier/api/";

const String loginApi = "login";
const String registerApi = "register";
const String checkOTP = "verify_otp";
const String resendOTPApi = "resend_otp";
const String addDeviceTrokenApi = "add_device_token";
const String logoutApi = "logout";
const String forgotPasswordApi = "forgot_password";
const String cmsPageApi = "cms_page";
const String newPasswordPostApi = "submit_reset_password";
const String getUser = "get_user";
const String updateLocation = "customer/updatelocation";
const String getNotificationList = "customer/notification/list";
const String updateProfileAPI = "customer/updateprofile";
const String getUserProfileAPI = "deliveryboy/get-profile";
const String addCardAPI = "customer/card/add";
const String getCardListAPI = "customer/card/list";
const String addFeedbackAPI = "customer/feedback/add";
const String sendSupportMessageAPI = "customer/support/send";
const String supportapi = "deliveryboy/support/send";
const String getSupportAPI = "support_data";
const String getPastOrderAPI = "customer/order/past";
const String getOrderDetailAPI = "customer/order/detail";
const String cancelOrderAPI = "cancel-by-customer";
const String createOrderAPI = "customer/order/create";
const String placedOrderAPI = "customer/order/placed";
const String getCategoryListAPI = "category";
const String getOrderList = "customer/order/list";
const String changePasswordAPI = "profile/change-password";
const String getTransportModeAPI = "mode-of-transport-list";
const String orderTrack = "customer/order/track";
const String cityListAPI = "city";
const String descriptionListAPI = "package-description-list";
const String handlingListAPI = "handling-instruction-list";
const String weightListAPI = "package-weight-list";
const String packageAmountApi = "customer/order/calculate-price";

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
        "AuthorizationUser": authToken,
      },
    );
    Response<String> response =
        await Dio().post(apiURL + urlPath, data: params, options: header);
    var responseJson = json.decode(response.data);
    if (response.statusCode == 200) {
      if (responseJson[kStatusCode] as int == 200) {
        return responseJson;
      } else if (responseJson[kStatusCode] as int == 102) {
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
        "AuthorizationUser": authToken,
      },
    );
    Response<String> response =
        await Dio().post(apiURL + urlPath, data: params, options: header);
    var responseJson = json.decode(response.data);
    print(responseJson);
    if (response.statusCode == 200) {
      if (responseJson["status_code"] as int == 200) {
        return responseJson;
      } else if (responseJson["status_code"] as int == 500) {
        clearUserData();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginVC()),
            (Route<dynamic> route) => false);
      } else {
        return responseJson["message"];
      }
    } else {
      return responseJson["message"];
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
        "authorization": userObj.token,
        "AuthorizationUser": authToken,
      },
    );
    Response<String> response =
        await Dio().post(apiURL + urlPath, data: params, options: header);
    var responseJson = json.decode(response.data);
    if (response.statusCode == 200) {
      if (responseJson[kStatusCode] as int == 500) {
        if (response.statusCode == 500) {
          clearUserData();
          return;
        }
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
