library constants;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:countmee/Model/UserModel.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import 'Constant.dart';

/*
Title : Global File  
Purpose: Frequntly used global widgets and method will take place in this file
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

UserModel userObj;
StreamSubscription<DataConnectionStatus> listener;
var InternetStatus = "Unknown";
var connectionStatus;
bool isConnected = false;

bool isEmail(String em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(em);
}

bool isValidZip(String zip) {
  bool isZipValid =
      RegExp(r"(^\d{5}$)|(^\d{5}-\d{4}$)", caseSensitive: false).hasMatch(zip);
  return isZipValid;
}

String getMaskedEmail(String email) {
  var maskedEmail = email;
  var maskedNewEmail = "";
  var end = "@";
  final startIndex = 0;
  final endIndex = maskedEmail.indexOf(end, startIndex);
  var emailStartText = maskedEmail.substring(0, endIndex);
  for (var i = 0; i < emailStartText.length; i++) {
    maskedNewEmail = maskedNewEmail + ((i < 3) ? emailStartText[i] : "*");
  }
  return maskedNewEmail =
      maskedNewEmail + maskedEmail.substring(endIndex, maskedEmail.length);
}

String getMaskedSSNNumber(String ssn) {
  var maskedEmail = ssn;
  var maskedNewEmail = "";
  final endIndex = ssn.length;
  var emailStartText = maskedEmail.substring(0, endIndex);
  for (var i = 0; i < emailStartText.length; i++) {
    maskedNewEmail = maskedNewEmail +
        ((i > emailStartText.length - 5)
            ? emailStartText[i]
            : (emailStartText[i] == " ")
                ? " "
                : "•");
  }
  return maskedNewEmail;
}

BoxShadow getShadowWithColor(Color color) {
  return BoxShadow(
    color: color,
    offset: Offset(0, 5),
    blurRadius: 15.0,
  );
}

BoxShadow getShadow(double x, double y, double b) {
  return BoxShadow(
    color: Color.fromRGBO(48, 48, 48, 0.1),
    offset: Offset(x, y),
    blurRadius: b,
  );
}

BoxShadow getdefaultShadow() {
  return BoxShadow(
    color: Color.fromRGBO(48, 48, 48, 0.1),
    offset: Offset(0, 5),
    blurRadius: 15.0,
  );
}

String getMaskedCardNumber(String email) {
  var maskedEmail = email;
  var maskedNewEmail = "";
  final endIndex = email.length;
  var emailStartText = maskedEmail.substring(0, endIndex);
  for (var i = 0; i < emailStartText.length; i++) {
    maskedNewEmail = maskedNewEmail +
        ((i > emailStartText.length - 5)
            ? emailStartText[i]
            : (emailStartText[i] == " ")
                ? " "
                : "•");
  }
  return maskedNewEmail;
}

bool validatePassword(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(value);
}

Widget myAppBar(String navTitle, BuildContext context, Image imgBackButton,
    bool isbackbutton) {
  return Platform.isIOS
      ? CupertinoNavigationBar(
          leading: isbackbutton
              ? Container(
                  alignment: Alignment.topLeft,
                  width: 40,
                  child: RawMaterialButton(
                    child: imgBackButton,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              : SizedBox(),
          middle: setBoldfont(navTitle, 18, Colors.black),
          backgroundColor: Colors.white,
        )
      : AppBar(
          leading: isbackbutton
              ? RawMaterialButton(
                  child: imgBackButton,
                  onPressed: () => Navigator.of(context).pop(),
                )
              : SizedBox(),
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.5,
          title: setBoldfont(navTitle, 18, Colors.black),
          backgroundColor: Colors.white,
        );
}

List<int> getAudioQuality() {
  return [8000, 16000, 32000];
}

Widget myAppBarWithBebas(String navTitle, BuildContext context,
    Image imgBackButton, bool isbackbutton) {
  return AppBar(
    leading: isbackbutton
        ? RawMaterialButton(
            child: imgBackButton,
            onPressed: () => Navigator.of(context).pop(),
          )
        : SizedBox(),
    iconTheme: IconThemeData(color: Colors.black),
    elevation: 0.0,
    backgroundColor: Colors.white,
  );
}

String getDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if (duration.inHours == 0) {
    return "$twoDigitMinutes:$twoDigitSeconds";
  } else {
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

bool isAppPurchased = false;

setButton(String text, double fontSize, Color fontColor, FontWeight weight,
    Function onTap, Color burttonColor, double buttonRadius) {
  return Platform.isIOS
      ? Container(
          child: CupertinoButton(
            child: setBoldfont(text, fontSize, fontColor),
            onPressed: onTap,
            color: burttonColor,
            borderRadius: new BorderRadius.circular(buttonRadius),
          ),
        )
      : Container(
          child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onTap,
              child: setCustomFont(text, fontSize, fontColor, weight, 1),
              color: burttonColor,
              // shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius)),
          // ),
        );
}

showGreenToast(String text, BuildContext context) {
  showToast(text,
      context: context,
      backgroundColor: Colors.green,
      textStyle: TextStyle(
          color: Colors.white, fontFamily: popinsRegFont, fontSize: 15),
      animation: StyledToastAnimation.slideFromTop,
      reverseAnimation: StyledToastAnimation.slideFromTop,
      position: StyledToastPosition.top,
      fullWidth: true,
      textPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
      axis: Axis.vertical,
      duration: Duration(seconds: 3));
}

showCustomToast(String text, BuildContext context) {
  showToast(text,
      context: context,
      backgroundColor: Color.fromRGBO(179, 18, 18, 1),
      textStyle: TextStyle(
          color: Colors.white,
          fontFamily: popinsRegFont,
          fontSize: 15,
          fontWeight: FontWeight.w400),
      animation: StyledToastAnimation.fade,
      fullWidth: true,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.top,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      textPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
      axis: Axis.vertical,
      duration: Duration(seconds: 3));
}

setbuttonWithChild(Widget child, Function onTap, Color burttonColor,
    Color highlight, double buttonRadius) {
  return Container(
    child: CupertinoButton(
        padding: EdgeInsets.zero,
        disabledColor: Colors.grey,
        // focusColor: Colors.transparent,
        // highlightColor: highlight,
        // hoverColor: Colors.transparent,
        // splashColor: Colors.transparent,
        onPressed: onTap,
        child: child,
        color: burttonColor,
        // shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(buttonRadius)),
    // ),
  );
}

setAuthTextField(TextEditingController controller, String hintText,
    bool secureEntry, bool validtion, String errorMSg, Function onchange) {
  return Theme(
      data: new ThemeData(
        primaryColor: Colors.green,
        primaryColorDark: Colors.red,
      ),
      child: TextFormField(
        onChanged: (value) => {onchange(value)},
        obscureText: secureEntry,
        enableSuggestions: false,
        autocorrect: false,
        controller: controller,
        decoration: InputDecoration(
          errorMaxLines: 3,
          errorText: validtion ? errorMSg : null,
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(15, 30, 0, 10),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromRGBO(244, 247, 250, 1), width: 1),
          ),
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide:
                  new BorderSide(color: Color.fromRGBO(244, 247, 250, 1))),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(
              color: Color.fromRGBO(164, 165, 169, 1),
              fontFamily: popinsRegFont,
              fontSize: 15,
              fontWeight: FontWeight.w400),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(244, 247, 250, 1)),
          ),
        ),
        cursorColor: Colors.black,
      ));
}

setAuthTextFieldMaxLength(
    TextEditingController controller,
    String hintText,
    bool secureEntry,
    bool validtion,
    String errorMSg,
    Function onchange,
    int lenght) {
  return Theme(
      data: new ThemeData(
        primaryColor: Colors.green,
        primaryColorDark: Colors.red,
      ),
      child: TextFormField(
        maxLength: lenght,
        onChanged: (value) => {onchange()},
        obscureText: secureEntry,
        enableSuggestions: false,
        autocorrect: false,
        controller: controller,
        decoration: InputDecoration(
          counterText: "",
          errorMaxLines: 3,
          errorText: validtion ? errorMSg : null,
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(15, 30, 0, 0),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromRGBO(244, 247, 250, 1), width: 1),
          ),
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide:
                  new BorderSide(color: Color.fromRGBO(244, 247, 250, 1))),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(
              color: Color.fromRGBO(164, 165, 169, 1),
              fontFamily: popinsRegFont,
              fontSize: 15,
              fontWeight: FontWeight.w400),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(244, 247, 250, 1)),
          ),
        ),
        cursorColor: Colors.black,
      ));
}

setButtonIndicator(double strokeWidth, Color backColor) {
  return CircularProgressIndicator(
    strokeWidth: strokeWidth,
    valueColor: AlwaysStoppedAnimation<Color>(backColor),
  );
}

Future<bool> getRememberMeFlag() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('rememberMe') != null) {
    return prefs.getBool('rememberMe');
  } else {
    return false;
  }
}

Future<String> getStringValueWithKey(String key) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getString(key) != null) {
    return prefs.getString(key);
  } else {
    return "";
  }
}

setStringValueWithKey(String value, String key) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

setRememberMeFlag(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("rememberMe", value);
}

setUserData() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("user", json.encode(userObj));
  print("SET USER DAT^A OBJECT   : $userObj");
}

clearUserData() async {
  final prefs = await SharedPreferences.getInstance();
  userObj = null;
  prefs.setString("user", json.encode(userObj));
  print("CLEAR DATA USER DAT^A OBJECT   : $userObj");
}

Future getuserData() async {
  final prefs = await SharedPreferences.getInstance();
  String value = prefs.getString('user');
  if (value == null || value == "null") {
    return null;
  } else {
    UserModel user = UserModel.fromJson(json.decode(value));
    userObj = user;
    return userObj;
  }
}

setLoadingState(bool isLoading, BuildContext context) {
  return isLoading
      ? Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.transparent,
        )
      : Container();
}

setTextFieldDynamic(
    TextEditingController controller,
    String hintText,
    bool secureEntry,
    TextInputType inputType,
    double fontSize,
    bool validtion,
    String errorMSg,
    Function onchange,
    dynamic focusNode) {
  return Theme(
      data: new ThemeData(
        primaryColor: Colors.green,
        primaryColorDark: Colors.red,
      ),
      child: TextField(
        style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            color: textBlackColor,
            height: 1.2),
        focusNode: focusNode,
        maxLines: 4,
        obscureText: secureEntry,
        enableSuggestions: false,
        autocorrect: false,
        controller: controller,
        onChanged: onchange,
        keyboardType: inputType,
        decoration: InputDecoration(
          errorMaxLines: 3,
          errorText: validtion ? errorMSg : null,
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(15, 30, 0, 0),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromRGBO(244, 247, 250, 1), width: 1),
          ),
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide:
                  new BorderSide(color: Color.fromRGBO(244, 247, 250, 1))),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              color: Colors.grey,
              height: 1.2),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(244, 247, 250, 1)),
          ),
        ),
        cursorColor: Colors.black,
      ));
}

setFocusTextField(
  TextEditingController controller,
  String hintText,
  TextInputType inputType,
  bool validtion,
  String errorMSg,
  Function onchange,
  dynamic focusNode,
) {
  return Theme(
      data: new ThemeData(
        primaryColor: Colors.green,
        primaryColorDark: Colors.red,
      ),
      child: TextField(
        style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            color: textBlackColor,
            height: 1.2),
        focusNode: focusNode,
        enableSuggestions: false,
        autocorrect: false,
        controller: controller,
        onChanged: onchange,
        keyboardType: inputType,
        decoration: InputDecoration(
          errorMaxLines: 3,
          errorText: validtion ? errorMSg : null,
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(15, 30, 0, 10),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromRGBO(244, 247, 250, 1), width: 1),
          ),
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide:
                  new BorderSide(color: Color.fromRGBO(244, 247, 250, 1))),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              color: Colors.grey,
              height: 1.2),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(244, 247, 250, 1)),
          ),
        ),
        cursorColor: Colors.black,
      ));
}

setTextField(
  TextEditingController controller,
  String hintText,
  bool secureEntry,
  TextInputType inputType,
  bool validtion,
  String errorMSg,
  Function onchange,
) {
  return Theme(
      data: new ThemeData(
        primaryColor: Colors.green,
        primaryColorDark: Colors.red,
      ),
      child: TextField(
        style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            color: textBlackColor,
            height: 1.2),
        obscureText: secureEntry,
        enableSuggestions: false,
        autocorrect: false,
        controller: controller,
        onChanged: onchange,
        keyboardType: inputType,
        decoration: InputDecoration(
          errorMaxLines: 3,
          errorText: validtion ? errorMSg : null,
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(15, 30, 0, 10),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromRGBO(244, 247, 250, 1), width: 1),
          ),
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide:
                  new BorderSide(color: Color.fromRGBO(244, 247, 250, 1))),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              color: Colors.grey,
              height: 1.2),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(244, 247, 250, 1)),
          ),
        ),
        cursorColor: Colors.black,
      ));
}

setTextFieldMobileNo(
    TextEditingController controller,
    String hintText,
    int maxLength,
    TextInputType inputType,
    bool validtion,
    String errorMSg,
    bool val,
    Function onchange) {
  return Theme(
      data: new ThemeData(
        primaryColor: Colors.green,
        primaryColorDark: Colors.red,
      ),
      child: TextField(
        style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            color:
                val == true ? Color.fromRGBO(164, 165, 169, 1) : textBlackColor,
            height: 1.2),
        inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
        enableSuggestions: false,
        autocorrect: false,
        readOnly: val,
        controller: controller,
        onChanged: onchange,
        keyboardType: inputType,
        decoration: InputDecoration(
          errorMaxLines: 3,
          errorText: validtion ? errorMSg : null,
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(15, 30, 0, 10),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromRGBO(244, 247, 250, 1), width: 1),
          ),
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide:
                  new BorderSide(color: Color.fromRGBO(244, 247, 250, 1))),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              color: Colors.grey,
              height: 1.2),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(244, 247, 250, 1)),
          ),
        ),
        cursorColor: Colors.black,
      ));
}

setTextFieldPassword(
  TextEditingController controller,
  String hintText,
  bool secureEntry,
  TextInputType inputType,
  bool validtion,
  String errorMSg,
  IconData suffixIconImg,
  Function onIconTap(),
  Function onchange,
) {
  return Theme(
      data: new ThemeData(
        primaryColor: Colors.green,
        primaryColorDark: Colors.red,
      ),
      child: Stack(
        children: [
          TextField(
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                color: textBlackColor,
                height: 1.2),
            obscureText: secureEntry,
            enableSuggestions: false,
            autocorrect: false,
            controller: controller,
            onChanged: (value) => {
              onchange(),
            },
            keyboardType: inputType,
            decoration: InputDecoration(
              errorMaxLines: 3,
              errorText: validtion ? errorMSg : null,
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(15, 30, 0, 10),
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromRGBO(244, 247, 250, 1), width: 1),
              ),
              border: new OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide:
                      new BorderSide(color: Color.fromRGBO(244, 247, 250, 1))),
              filled: true,
              fillColor: Colors.white,
              hintText: hintText,
              hintStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  color: Colors.grey,
                  height: 1.2),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(244, 247, 250, 1)),
              ),
            ),
            cursorColor: Colors.black,
          ),
          Positioned(
            top: 20,
            right: 15,
            child: GestureDetector(
              onTap: () {
                onIconTap();
              },
              child: Icon(
                suffixIconImg,
                size: 18,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ));
}

setTextField14(
    TextEditingController controller,
    String hintText,
    bool secureEntry,
    TextInputType inputType,
    bool validtion,
    String errorMSg,
    Function onchange,
    dynamic focusNode) {
  return Theme(
      data: new ThemeData(
        primaryColor: Colors.green,
        primaryColorDark: Colors.red,
      ),
      child: TextField(
        style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            color: textBlackColor,
            height: 1.2),
        focusNode: focusNode,
        inputFormatters: [LengthLimitingTextInputFormatter(3)],
        obscureText: secureEntry,
        enableSuggestions: false,
        autocorrect: false,
        controller: controller,
        onChanged: (value) => {onchange(value)},
        keyboardType: inputType,
        decoration: InputDecoration(
          errorMaxLines: 3,
          errorText: validtion ? errorMSg : null,
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(10, 30, 0, 10),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromRGBO(244, 247, 250, 1), width: 1),
          ),
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide:
                  new BorderSide(color: Color.fromRGBO(244, 247, 250, 1))),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              color: Colors.grey,
              height: 1.2),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(244, 247, 250, 1)),
          ),
        ),
        cursorColor: Colors.black,
      ));
}

setDigitTextField(
    TextEditingController controller,
    String hintText,
    bool secureEntry,
    TextInputType inputType,
    bool validtion,
    String errorMSg,
    Function onchange) {
  return Theme(
      data: new ThemeData(
        primaryColor: Colors.green,
        primaryColorDark: Colors.red,
      ),
      child: TextField(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        obscureText: secureEntry,
        enableSuggestions: false,
        autocorrect: false,
        controller: controller,
        onChanged: (value) => {onchange()},
        keyboardType: inputType,
        decoration: InputDecoration(
          errorMaxLines: 3,
          errorText: validtion ? errorMSg : null,
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(15, 40, 0, 10),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromRGBO(244, 247, 250, 1), width: 1),
          ),
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide:
                  new BorderSide(color: Color.fromRGBO(244, 247, 250, 1))),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(
              color: Color.fromRGBO(164, 165, 169, 1),
              fontFamily: popinsRegFont,
              fontSize: 15,
              fontWeight: FontWeight.w400),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(244, 247, 250, 1)),
          ),
        ),
        cursorColor: Colors.black,
      ));
}

setTextFieldMaxNumber(
    TextEditingController controller,
    String hintText,
    bool secureEntry,
    TextInputType inputType,
    bool validtion,
    String errorMSg,
    Function onchange,
    int maxLength) {
  return Theme(
      data: new ThemeData(
        primaryColor: Colors.green,
        primaryColorDark: Colors.red,
      ),
      child: TextField(
        maxLength: maxLength,
        obscureText: secureEntry,
        enableSuggestions: false,
        autocorrect: false,
        controller: controller,
        onChanged: (value) => {onchange()},
        keyboardType: inputType,
        decoration: InputDecoration(
          counterText: "",
          errorMaxLines: 3,
          errorText: validtion ? errorMSg : null,
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(15, 30, 0, 0),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromRGBO(244, 247, 250, 1), width: 1),
          ),
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide:
                  new BorderSide(color: Color.fromRGBO(244, 247, 250, 1))),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(
              color: Color.fromRGBO(164, 165, 169, 1),
              fontFamily: popinsRegFont,
              fontSize: 15,
              fontWeight: FontWeight.w400),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(244, 247, 250, 1)),
          ),
        ),
        cursorColor: Colors.black,
      ));
}

setMaskedDigitTextField(
    TextInputFormatter formattor,
    TextEditingController controller,
    String hintText,
    bool secureEntry,
    TextInputType inputType,
    bool validtion,
    String errorMSg,
    Function onchange) {
  return Theme(
      data: new ThemeData(
        primaryColor: Colors.green,
        primaryColorDark: Colors.red,
      ),
      child: TextField(
        inputFormatters: [formattor],
        obscureText: secureEntry,
        enableSuggestions: false,
        autocorrect: false,
        controller: controller,
        onChanged: (value) => {onchange(value)},
        keyboardType: inputType,
        decoration: InputDecoration(
          errorMaxLines: 3,
          errorText: validtion ? errorMSg : null,
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(15, 30, 0, 0),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromRGBO(244, 247, 250, 1), width: 1),
          ),
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide:
                  new BorderSide(color: Color.fromRGBO(244, 247, 250, 1))),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(
              color: Color.fromRGBO(164, 165, 169, 1),
              fontFamily: popinsRegFont,
              fontSize: 15,
              fontWeight: FontWeight.w400),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(244, 247, 250, 1)),
          ),
        ),
        cursorColor: Colors.black,
      ));
}

setPriceMaskedTextField(
    TextInputFormatter formattor,
    TextEditingController controller,
    String hintText,
    bool secureEntry,
    TextInputType inputType,
    bool validtion,
    String errorMSg,
    Function onchange) {
  return Theme(
      data: new ThemeData(
        primaryColor: Colors.green,
        primaryColorDark: Colors.red,
      ),
      child: TextField(
        inputFormatters: [formattor],
        obscureText: secureEntry,
        enableSuggestions: false,
        autocorrect: false,
        controller: controller,
        onChanged: (value) => {onchange(value)},
        keyboardType: inputType,
        decoration: InputDecoration(
          errorMaxLines: 3,
          errorText: validtion ? errorMSg : null,
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(15, 30, 0, 0),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromRGBO(244, 247, 250, 1), width: 1),
          ),
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide:
                  new BorderSide(color: Color.fromRGBO(244, 247, 250, 1))),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(
              color: Color.fromRGBO(164, 165, 169, 1),
              fontFamily: popinsRegFont,
              fontSize: 15,
              fontWeight: FontWeight.w400),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(244, 247, 250, 1)),
          ),
        ),
        cursorColor: Colors.black,
      ));
}

setMaskedTextField(
    TextInputFormatter formattor,
    TextEditingController controller,
    String hintText,
    bool secureEntry,
    TextInputType inputType,
    bool validtion,
    String errorMSg,
    Function onchange) {
  return Theme(
      data: new ThemeData(
        primaryColor: Colors.green,
        primaryColorDark: Colors.red,
      ),
      child: TextField(
        inputFormatters: [formattor],
        obscureText: secureEntry,
        enableSuggestions: false,
        autocorrect: false,
        controller: controller,
        onChanged: (value) => {onchange(value)},
        keyboardType: inputType,
        decoration: InputDecoration(
          errorMaxLines: 3,
          errorText: validtion ? errorMSg : null,
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(15, 30, 0, 10),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromRGBO(244, 247, 250, 1), width: 1),
          ),
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide:
                  new BorderSide(color: Color.fromRGBO(244, 247, 250, 1))),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(
              color: Color.fromRGBO(164, 165, 169, 1),
              fontFamily: popinsRegFont,
              fontSize: 15,
              fontWeight: FontWeight.w400),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(244, 247, 250, 1)),
          ),
        ),
        cursorColor: Colors.black,
      ));
}

setTextFieldwithTrelingImage(
    TextEditingController controller,
    String hintText,
    bool hasTreling,
    String imageName,
    Function onDropDownTap,
    Color backgroundColor,
    bool validtion,
    String errorMSg,
    Function onchange) {
  return Theme(
      data: new ThemeData(
        primaryColor: Colors.green,
        primaryColorDark: Colors.red,
      ),
      child: TextField(
        enableSuggestions: false,
        autocorrect: false,
        controller: controller,
        onChanged: (value) => {onchange()},
        decoration: InputDecoration(
            errorMaxLines: 3,
            errorText: validtion ? errorMSg : null,
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(15, 30, 0, 0),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromRGBO(244, 247, 250, 1), width: 1),
            ),
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide:
                    new BorderSide(color: Color.fromRGBO(244, 247, 250, 1))),
            filled: true,
            fillColor: backgroundColor,
            hintText: hintText,
            hintStyle: TextStyle(
                color: Color.fromRGBO(164, 165, 169, 1),
                fontFamily: popinsRegFont,
                fontSize: 15,
                fontWeight: FontWeight.w400),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(244, 247, 250, 1)),
            ),
            suffixIcon: hasTreling
                ? Container(
                    width: 40,
                    height: 40,
                    child: setbuttonWithChild(
                        setImageName(imageName, 20, 20),
                        onDropDownTap,
                        Colors.transparent,
                        Colors.transparent,
                        0),
                  )
                : null),
        cursorColor: Colors.black,
      ));
}

setReadableTextFieldwithTrelingImage(
    TextEditingController controller,
    String hintText,
    bool hasTreling,
    String imageName,
    Function onDropDownTap,
    Color backgroundColor,
    FocusNode node,
    bool validation,
    bool validtion,
    String errorMSg,
    Function onchange) {
  return Theme(
      data: new ThemeData(
        primaryColor: Colors.green,
        primaryColorDark: Colors.red,
      ),
      child: TextField(
        focusNode: node,
        readOnly: true,
        enableSuggestions: false,
        autocorrect: false,
        controller: controller,
        onChanged: (value) => {onchange()},
        decoration: InputDecoration(
            errorMaxLines: 3,
            errorText: validtion ? errorMSg : null,
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(15, 30, 0, 0),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromRGBO(244, 247, 250, 1), width: 1),
            ),
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide:
                    new BorderSide(color: Color.fromRGBO(244, 247, 250, 1))),
            filled: true,
            fillColor: backgroundColor,
            hintText: hintText,
            hintStyle: TextStyle(
                color: Color.fromRGBO(164, 165, 169, 1),
                fontFamily: popinsRegFont,
                fontSize: 15,
                fontWeight: FontWeight.w400),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(244, 247, 250, 1)),
            ),
            suffixIcon: hasTreling
                ? Container(
                    width: 40,
                    height: 40,
                    child: setbuttonWithChild(
                        setImageName(imageName, 20, 20),
                        onDropDownTap,
                        Colors.transparent,
                        Colors.transparent,
                        0),
                  )
                : null),
        cursorColor: Colors.black,
      ));
}

setProfileImageWithSize(String url, double width, double height) {
  if (url != null) {
    if (url.length > 0) {
      return CachedNetworkImage(
        imageUrl:
            "https://countmee-courier.s3.us-east-2.amazonaws.com/users/" + url,
        // works for smaller images =>                  200',
        httpHeaders: {'Referer': ''},
        height: height,
        width: width,
        imageBuilder: (context, imageProvider) => ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        ),

        errorWidget: (context, url, error) => Image(
          image: AssetImage(
            'assets/images/userPlaceholder.png',
          ),
          width: width,
          height: height,
        ),
      );
    } else {
      return Image(
        image: AssetImage(
          'assets/images/userPlaceholder.png',
        ),
        width: width,
        height: height,
      );
    }
  } else {
    return Image(
      image: AssetImage(
        'assets/images/userPlaceholder.png',
      ),
      width: width,
      height: height,
    );
  }
}

setProfileImage(String url) {
  if (url != null) {
    if (url.length > 0) {
      return CachedNetworkImage(
        imageUrl:
            "https://countmee-courier.s3.us-east-2.amazonaws.com/users/" + url,
        // works for smaller images =>                  200',
        httpHeaders: {'Referer': ''},
        height: 100,
        width: 100,

        imageBuilder: (context, imageProvider) => ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        ),

        placeholder: (context, url) => Shimmer.fromColors(
          child: ClipOval(
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage(
                "assets/images/userPlaceholder.png",
              ),
            ),
          ),
          baseColor: Colors.grey[200],
          highlightColor: Colors.grey[400],
          direction: ShimmerDirection.ltr,
        ),

        errorWidget: (context, url, error) => Image(
          image: AssetImage(
            'assets/images/userPlaceholder.png',
          ),
          width: 100,
          height: 100,
        ),
      );
    } else {
      return Image(
        image: AssetImage(
          'assets/images/userPlaceholder.png',
        ),
        width: 100,
        height: 100,
      );
    }
  } else {
    return Image(
      image: AssetImage(
        'assets/images/userPlaceholder.png',
      ),
      width: 100,
      height: 100,
    );
  }
}

checkLocationStatus() async {
  var location = Location();
  bool enabled = await location.serviceEnabled();
  if (enabled == false) {
    bool gotEnabled = await location.requestService();
  } else {
    print("ELSE");
  }
}

setTransportImage(String url) {
  if (url != null) {
    if (url.length > 0) {
      return CachedNetworkImage(
        imageUrl:
            "https://countmee-produciton.s3.ap-south-1.amazonaws.com/transport/" +
                url,
        height: 40,
        width: 40,
        placeholder: (context, url) => setImageName("iconTruck.png", 40, 20),
        errorWidget: (context, url, error) =>
            setImageName("iconTruck.png", 40, 20),
      );
    }
  }
}

setReadableTextFieldwithtrelignGreyFont(
    TextEditingController controller,
    String hintText,
    bool hasTreling,
    String imageName,
    Function onDropDownTap,
    Color backgroundColor,
    FocusNode node,
    bool validation,
    bool validtion,
    String errorMSg,
    Function onchange) {
  return Theme(
      data: new ThemeData(
        primaryColor: Colors.green,
        primaryColorDark: Colors.red,
      ),
      child: TextField(
        style: TextStyle(color: Colors.grey),
        focusNode: node,
        readOnly: true,
        enableSuggestions: false,
        autocorrect: false,
        controller: controller,
        onChanged: (value) => {onchange()},
        decoration: InputDecoration(
            errorMaxLines: 3,
            errorText: validtion ? errorMSg : null,
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(15, 30, 0, 10),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromRGBO(244, 247, 250, 1), width: 1),
            ),
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide:
                    new BorderSide(color: Color.fromRGBO(244, 247, 250, 1))),
            filled: true,
            fillColor: backgroundColor,
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                color: Color.fromRGBO(164, 165, 169, 1),
                height: 1.2),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(244, 247, 250, 1)),
            ),
            suffixIcon: hasTreling
                ? Container(
                    width: 40,
                    height: 40,
                    child: setbuttonWithChild(
                        setImageName(imageName, 20, 20),
                        onDropDownTap,
                        Colors.transparent,
                        Colors.transparent,
                        0),
                  )
                : null),
        cursorColor: Colors.grey,
      ));
}

setButtonwithImage(
    String imageName,
    Color imageColor,
    double width,
    double height,
    Function onTap,
    double buttonRadius,
    double buttonWidth,
    double buttonHeight) {
  return Container(
    width: buttonWidth,
    height: buttonHeight,
    child: CupertinoButton(
      padding: EdgeInsets.zero,
      // highlightColor: Colors.transparent,
      // focusColor: Colors.transparent,
      // hoverColor: Colors.transparent,
      // splashColor: Colors.transparent,
      disabledColor: Colors.transparent,
      onPressed: onTap,
      child: setImageName(imageName, width, height),
    ),
  );
}

setBorderButton(
    String text,
    double fontSize,
    Color fontColor,
    FontWeight weight,
    Function onTap,
    Color burttonColor,
    double buttonRadius) {
  return Container(
    decoration: BoxDecoration(
        color: burttonColor,
        border: Border.all(
          color: appColor,
          width: 2,
        ),
        borderRadius: new BorderRadius.all(Radius.circular(4))),
    child:
        setButton(text, 16, fontColor, FontWeight.w700, onTap, burttonColor, 4),
  );
}

String getDurationWithMicroSeconds(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  String twoDigitMiliSeconds = twoDigits(duration.inMilliseconds.remainder(60));
  if (duration.inHours == 0) {
    return "$twoDigitMinutes:$twoDigitSeconds:$twoDigitMiliSeconds";
  } else {
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

getCalculated(double value) {
  double devicePixelRatio = ui.window.devicePixelRatio;
  ui.Size size = ui.window.physicalSize;
  double height = size.height;
  double screenHeight = height / devicePixelRatio;

  if (screenHeight >= 800.0 && screenHeight <= 895.0) {
    // For devices Iphone 10 range. For android hd.
    return 667.0 * (value / 568.0);
  } else if (screenHeight >= 896.0) {
    // For XR and XS max.
    return 736.0 * (value / 568.0);
  } else {
    // For other.
    return screenHeight * (value / 568.0);
  }
}

void afterDelay(int seconds, Function callBack) {
  Future.delayed(Duration(seconds: seconds), () {
    callBack();
  });
}

void pushToViewController(
    BuildContext context, Widget viewController, Function callback) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => viewController, fullscreenDialog: false),
  ).then((value) {
    callback();
  });
}

double getSizeByDevice(int phoneInput, int incresedCount) {
  if (Device.get().isTablet) {
    return phoneInput + incresedCount.toDouble();
  } else {
    return phoneInput.toDouble();
  }
}

Future<String> createFolderInAppDocDir(String folderName) async {
//Get this App Document Directory
  final Directory _appDocDir = await getApplicationDocumentsDirectory();
//App Document Directory + folder name
  Directory _appDocDirFolder = Directory('${_appDocDir.path}/$folderName/');

  if (Platform.isAndroid) {
    var dir = await getExternalStorageDirectory();
    _appDocDirFolder = Directory('${dir.path}/$folderName/');
  }

  if (await _appDocDirFolder.exists()) {
//if folder already exists return path
    return _appDocDirFolder.path;
  } else {
//if folder not exists create folder and then return its path
    final Directory _appDocDirNewFolder =
        await _appDocDirFolder.create(recursive: true);
    return _appDocDirNewFolder.path;
  }
}

String setDateTime(DateTime date) {
  final DateFormat formatter = DateFormat(' dd-MMM-yy | hh:mm');
  final String formatted = formatter.format(date);
  return formatted;
}

String getFileSize(String path) {
  var file = File(path);
  var fileSizeMB = (file.lengthSync() / 1024 / 1024).toStringAsFixed(2);
  if ((file.lengthSync() / 1024 / 1024) < 1) {
    var fileSizeKB = (file.lengthSync() / 1024).toStringAsFixed(0);
    return fileSizeKB + " KB";
  } else {
    return fileSizeMB + " MB";
  }
}

removeSelectedFile(String path, BuildContext context) {
  final dir = Directory(path);
  dir.deleteSync(recursive: true);
  Navigator.pop(context, 'Remove');
}

Image setImageHeightFit(
  String path,
) {
  return Image.asset(
    "assets/images/" + path,
    fit: BoxFit.fitHeight,
  );
}

Image setImageWithName(String name) {
  return Image.asset(
    "assets/images/" + name,
    fit: BoxFit.fitWidth,
  );
}

Image setImageNameAndPathWithFit(
    String path, String name, double width, double height, BoxFit fit) {
  return Image.asset(
    "assets/images/" + path + name,
    width: width,
    height: height,
    fit: fit,
  );
}

Image setImageName(String name, double width, double height) {
  return Image.asset("assets/images/" + name, width: width, height: height);
}

checkConnection(BuildContext context) async {
  listener = DataConnectionChecker().onStatusChange.listen((status) {
    switch (status) {
      case DataConnectionStatus.disconnected:
        InternetStatus = "Please check your internet connection";
        connectionStatus = DataConnectionStatus.disconnected;
        showCustomToast(InternetStatus, context);
        break;
      case DataConnectionStatus.connected:
        (context as Element).reassemble();
        isConnected = true;
        InternetStatus = "Connected to the Internet";
        connectionStatus = DataConnectionStatus.connected;
        break;
    }
  });
  return await DataConnectionChecker().connectionStatus;
}

Image setImageNameColor(String name, double width, double height, Color color) {
  return Image.asset(
    "assets/images/" + name,
    width: width,
    height: height,
    color: color,
  );
}

Text setCustomFontLeftAlignment(String text, double size, Color color,
    FontWeight weight, double lineHeight) {
  return Text(
    text,
    softWrap: true,
    maxLines: 10,
    textAlign: TextAlign.left,
    overflow: TextOverflow.ellipsis,
    style: GoogleFonts.poppins(
        fontSize: size,
        fontWeight: weight,
        fontStyle: FontStyle.normal,
        color: color,
        height: lineHeight),
  );
}

Text setCustomFontWithWarp(String text, double size, Color color,
    FontWeight weight, double lineHeight) {
  return Text(
    text,
    softWrap: false,
    maxLines: 1,
    textAlign: TextAlign.center,
    overflow: TextOverflow.fade,
    style: GoogleFonts.poppins(
        fontSize: size,
        fontWeight: weight,
        fontStyle: FontStyle.normal,
        color: color,
        height: lineHeight),
  );
}

Text setCustomFontWithAlignment(String text, double size, Color color,
    FontWeight weight, double lineHeight, TextAlign align) {
  return Text(
    text,
    softWrap: true,
    maxLines: 2,
    textAlign: align,
    overflow: TextOverflow.ellipsis,
    style: GoogleFonts.poppins(
        fontSize: size,
        fontWeight: weight,
        fontStyle: FontStyle.normal,
        color: color,
        height: lineHeight),
  );
}

Text setCustomFont(String text, double size, Color color, FontWeight weight,
    double lineHeight) {
  return Text(
    text,
    softWrap: true,
    maxLines: 10,
    textAlign: TextAlign.center,
    overflow: TextOverflow.ellipsis,
    style: GoogleFonts.poppins(
        fontSize: size,
        fontWeight: weight,
        fontStyle: FontStyle.normal,
        color: color,
        height: lineHeight),
  );
}

Text setPoppinsfontMultiline(String text, double size, Color color,
    FontWeight weight, double lineHeight) {
  return Text(
    text,
    softWrap: true,
    maxLines: 100,
    style: TextStyle(
      height: lineHeight,
      fontSize: size,
      fontFamily: 'Poppins Regular',
      fontWeight: weight,
      color: color,
    ),
  );
}

Text setPoppinsfontWitAlignment(String text, double size, Color color,
    FontWeight weight, double lineHeight) {
  return Text(
    text,
    softWrap: true,
    textAlign: TextAlign.center,
    style: TextStyle(
      height: lineHeight,
      fontSize: size,
      fontFamily: 'Poppins Regular',
      fontWeight: weight,
      color: color,
    ),
  );
}

Text setBoldfont(String text, double size, Color color) {
  return Text(
    text,
    maxLines: 50,
    style: TextStyle(
      fontSize: size,
      fontFamily: 'Poppins Bold',
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}

Text setBoldFontMultiline(String text, double size, Color color) {
  return Text(
    text,
    maxLines: 100,
    textAlign: TextAlign.center,
    overflow: TextOverflow.ellipsis,
    softWrap: false,
    style: TextStyle(
      fontSize: size,
      fontFamily: 'Poppins Bold',
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}

Text setHeavyFont(String text, double size, Color color) {
  return Text(
    text,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    softWrap: false,
    style: TextStyle(
      fontSize: size,
      fontFamily: 'Poppins Bold',
      fontWeight: FontWeight.w900,
      color: color,
    ),
  );
}

Text setSemiboldFont(String text, double size, Color color) {
  return Text(
    text,
    maxLines: 100,
    overflow: TextOverflow.ellipsis,
    softWrap: false,
    style: TextStyle(
      fontSize: size,
      fontFamily: 'Poppins Bold',
      fontWeight: FontWeight.w600,
      color: color,
    ),
  );
}

Text setPlaceholderSubtitle(String text, double size, Color color) {
  return Text(
    text,
    maxLines: 5,
    overflow: TextOverflow.ellipsis,
    softWrap: false,
    style: TextStyle(
      fontSize: size,
      fontFamily: 'Poppins Bold',
      fontWeight: FontWeight.w600,
      color: color,
    ),
    textAlign: TextAlign.center,
  );
}

Text setNormalfont(String text, double size, Color color) {
  return Text(
    text,
    overflow: TextOverflow.fade,
    style: TextStyle(
      fontSize: size,
      fontFamily: 'Poppins Bold',
      fontWeight: FontWeight.normal,
      color: color,
    ),
    textAlign: TextAlign.center,
  );
}

Text setNormalfontWithUnderLine(String text, double size, Color color) {
  return Text(
    text,
    overflow: TextOverflow.fade,
    style: TextStyle(
        fontSize: size,
        fontFamily: 'Poppins Bold',
        fontWeight: FontWeight.normal,
        color: color,
        decoration: TextDecoration.underline),
    textAlign: TextAlign.center,
  );
}

Text setNormalfontWithAlign(
    String text, double size, Color color, TextAlign align) {
  return Text(
    text,
    overflow: TextOverflow.fade,
    style: TextStyle(
      fontSize: size,
      fontFamily: 'Poppins Bold',
      fontWeight: FontWeight.normal,
      color: color,
    ),
    textAlign: align,
  );
}

setCloudImageFull(String url) {
  if (url != null) {
    if (url.length > 0) {
      return CachedNetworkImage(
        imageUrl: "http://44.237.241.139/waitlisthero/img/user/" + url,
        // works for smaller images =>                  200',
        httpHeaders: {'Referer': ''},
        imageBuilder: (context, imageProvider) => Container(),

        errorWidget: (context, url, error) => Image(
          fit: BoxFit.cover,
          image: AssetImage(
            'assets/images/Common/widePlaceholder.png',
          ),
        ),
      );
    } else {
      return Image(
        image: AssetImage(
          'assets/images/Common/widePlaceholder.png',
        ),
      );
    }
  } else {
    return Image(
      image: AssetImage(
        'assets/images/Common/widePlaceholder.png',
      ),
    );
  }
}

setCloudImageWithSize(String url, double width, double height) {
  if (url != null) {
    if (url.length > 0) {
      return CachedNetworkImage(
        imageUrl: "http://44.237.241.139/waitlisthero/img/user/" + url,
        // works for smaller images =>                  200',
        httpHeaders: {'Referer': ''},
        height: height,
        width: width,

        imageBuilder: (context, imageProvider) => ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        ),

        errorWidget: (context, url, error) => Image(
          image: AssetImage(
            'assets/images/Common/user_placehorder.png',
          ),
          width: width,
          height: height,
        ),
      );
    } else {
      return Image(
        image: AssetImage(
          'assets/images/Common/user_placehorder.png',
        ),
        width: width,
        height: height,
      );
    }
  } else {
    return Image(
      image: AssetImage(
        'assets/images/Common/user_placehorder.png',
      ),
      width: width,
      height: height,
    );
  }
}

String getFormatedDate(String date) {
  DateTime tempDate;
  if (date != null) {
    if (date.contains("/")) {
      tempDate = new DateFormat("MM/dd/yyyy").parse(date.trim());
    } else {
      tempDate = new DateFormat("dd-MM-yyyy").parse(date.trim());
    }

    final DateFormat formatter = DateFormat('MMMM dd, yyy');
    final String formatted = formatter.format(tempDate);
    return formatted;
  } else {
    return "";
  }
}

setCloudImage(String url) {
  if (url != null) {
    if (url.length > 0) {
      return CachedNetworkImage(
        imageUrl: "http://44.237.241.139/waitlisthero/img/user/" + url,
        // works for smaller images =>                  200',
        httpHeaders: {'Referer': ''},
        height: 100,
        width: 100,

        imageBuilder: (context, imageProvider) => ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        ),

        errorWidget: (context, url, error) => Image(
          image: AssetImage(
            'assets/images/Common/user_placehorder.png',
          ),
          width: 100,
          height: 100,
        ),
      );
    } else {
      return Image(
        image: AssetImage(
          'assets/images/Common/user_placehorder.png',
        ),
        width: 100,
        height: 100,
      );
    }
  } else {
    return Image(
      image: AssetImage(
        'assets/images/Common/user_placehorder.png',
      ),
      width: 100,
      height: 100,
    );
  }
}

setCloudImageStylistPlaceholder(String url) {
  if (url != null) {
    if (url != "null" && url.length > 1) {
      return CachedNetworkImage(
        imageUrl: "http://44.237.241.139/waitlisthero/img/user/" + url,
        // works for smaller images =>                  200',
        httpHeaders: {'Referer': ''},
        height: 100,
        width: 100,

        imageBuilder: (context, imageProvider) => ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        ),

        errorWidget: (context, url, error) => Image(
          image: AssetImage(
            'assets/images/Common/stylistPlaceholde.png',
          ),
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        ),
      );
    } else {
      return Image(
        image: AssetImage(
          'assets/images/Common/stylistPlaceholde.png',
        ),
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    }
  }
}

AlertMessage(String text, BuildContext context, Function onpressed) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        content: Text(
          text,
          style: TextStyle(fontSize: 15),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            textStyle: TextStyle(color: appColor, fontSize: 18),
            onPressed: onpressed,
            child: Text("Ok"),
          ),
        ],
      );
    },
  );
}

const kData = "data";
const kStatus = "status";
const kStatusCode = "status_code";
const kMessage = "message";
