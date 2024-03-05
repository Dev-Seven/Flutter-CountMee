import 'package:countmee/Model/UserAPIDetails.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/CountryCode.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

/*
Title : ReceiverDetailsVC Screen
Purpose: ReceiverDetailsVC Screen
Created By : Kalpesh Khandla
Last Edited By : 3 Feb 2022
*/

class ReceiverDetailsVC extends StatefulWidget {
  final Function updateUserDetail;
  final String url, dropAddress;
  UserAPIDetails objUser;
  final bool isEdit;

  ReceiverDetailsVC(
      {Key key,
      this.updateUserDetail,
      this.objUser,
      this.url,
      this.isEdit,
      this.dropAddress})
      : super(key: key);
  @override
  _ReceiverDetailsVCState createState() => _ReceiverDetailsVCState();
}

class _ReceiverDetailsVCState extends State<ReceiverDetailsVC> {
  var deliveryContactMe = false;
  var isLoading = false;
  final txtFirstNameController = TextEditingController();
  final txtAddressController = TextEditingController();
  final txtLandmarkController = TextEditingController();
  final txtMobileNumberController = TextEditingController();
  final txtMobileNumber2Controller = TextEditingController();
  final txtSecondMobileNumberController = TextEditingController();
  final txtAddressTypeController = TextEditingController();
  final txtLinkController = TextEditingController();
  final txtCountryCodeController = TextEditingController();
  TextEditingController _controllerPeople, _controllerMessage;
  bool isAddressEmpty = false;
  bool isFNameEmpty = false;

  var isAddressTypeEmpty = false;
  bool isLandMarkEmpty = false;
  var isPhone1Validation = false;
  var isPhone1Empty = false;
  var isPhone1Invalid = false;
  var isPhone2Validation = false;
  var isPhone2Empty = false;
  var isPhone2Invalid = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    txtFirstNameController.text = widget.objUser.name ?? "";
    txtAddressController.text = widget.objUser.address == ""
        ? widget.dropAddress
        : widget.objUser.address;
    txtMobileNumberController.text = widget.objUser.mobileNumber1 ?? "";
    txtMobileNumber2Controller.text = widget.objUser.mobileNumber2 ?? "";
    txtLinkController.text = widget.objUser.googleMapLink == ""
        ? widget.url
        : widget.objUser.googleMapLink;
  }

  Future<void> initPlatformState() async {
    _controllerPeople = TextEditingController();
    _controllerMessage = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: setCustomFont(
            "Receiver Details", 20, textBlackColor, FontWeight.w700, 1),
        leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
          Navigator.pop(context);
        }, Colors.transparent, Colors.transparent, 0),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: setCustomFont(
                    "Delivery Contact", 14, textBlackColor, FontWeight.w400, 1),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        deliveryContactMe = true;
                        txtFirstNameController.text = widget.objUser.name == ""
                            ? userObj.name
                            : widget.objUser.name;
                        txtMobileNumberController.text =
                            widget.objUser.mobileNumber1 == ""
                                ? userObj.phoneNumber
                                : widget.objUser.mobileNumber1;
                      });
                    },
                    child: Container(
                      child: setImageName(
                          deliveryContactMe
                              ? "iconRadioSelected.png"
                              : "iconRadioNormal.png",
                          30,
                          30),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Me',
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(
                    width: 55,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        deliveryContactMe = false;

                        txtFirstNameController.text =
                            txtFirstNameController.text == userObj.name
                                ? ""
                                : widget.objUser.name;
                        txtMobileNumberController.text =
                            txtMobileNumberController.text ==
                                    userObj.phoneNumber
                                ? ""
                                : widget.objUser.mobileNumber1;
                      });
                    },
                    child: Container(
                      child: setImageName(
                          deliveryContactMe
                              ? "iconRadioNormal.png"
                              : "iconRadioSelected.png",
                          30,
                          30),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  new Text(
                    'Someone else',
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: setTextField(
                      txtFirstNameController,
                      "Name",
                      false,
                      TextInputType.text,
                      isFNameEmpty,
                      msgEmptyName,
                      (value) => {
                            setState(() {
                              isFNameEmpty = false;
                            })
                          })),
              SizedBox(
                height: 15,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: setTextFieldDynamic(
                      txtAddressController,
                      "Enter Address",
                      false,
                      TextInputType.text,
                      14,
                      isAddressEmpty,
                      msgEmptyAddress,
                      (value) => {
                            setState(() {
                              isAddressEmpty = false;
                            })
                          },
                      null)),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: 50,
                      height: isPhone1Validation ? 80 : 57,
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
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color.fromRGBO(244, 247, 250, 1),
                                        width: 1),
                                  ),
                                  border: new OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      borderSide: new BorderSide(
                                          color: Color.fromRGBO(
                                              244, 247, 250, 1))),
                                  filled: false,
                                  fillColor: backgroundColor,
                                  hintText: "+91",
                                  hintStyle: TextStyle(
                                      color: Color.fromRGBO(164, 165, 169, 1),
                                      fontFamily: popinsRegFont,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(244, 247, 250, 1)),
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
                      padding: const EdgeInsets.only(right: 15),
                      child: setTextFieldMobileNo(
                          txtMobileNumberController,
                          "Mobile No1. ",
                          10,
                          TextInputType.number,
                          isPhone1Validation,
                          isPhone1Empty
                              ? msgEmptyMobileNumber
                              : msgInvalidPhoneNumber,
                          false,
                          (value) => {
                                setState(() {
                                  isPhone1Validation = false;
                                })
                              }),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: 50,
                      height: isPhone2Validation ? 80 : 57,
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
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color.fromRGBO(244, 247, 250, 1),
                                        width: 1),
                                  ),
                                  border: new OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      borderSide: new BorderSide(
                                          color: Color.fromRGBO(
                                              244, 247, 250, 1))),
                                  filled: false,
                                  fillColor: backgroundColor,
                                  hintText: "+91",
                                  hintStyle: TextStyle(
                                      color: Color.fromRGBO(164, 165, 169, 1),
                                      fontFamily: popinsRegFont,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(244, 247, 250, 1)),
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
                      padding: const EdgeInsets.only(right: 15),
                      child: setTextFieldMobileNo(
                          txtMobileNumber2Controller,
                          "Mobile No2.",
                          10,
                          TextInputType.number,
                          isPhone2Validation,
                          isPhone2Empty
                              ? msgEmptyMobileNumber
                              : msgInvalidPhoneNumber,
                          false,
                          (value) => {
                                setState(() {
                                  isPhone2Validation = false;
                                }),
                              }),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Theme(
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
                        enabled: false,
                        maxLines: 3,
                        obscureText: false,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: txtLinkController,
                        onChanged: (value) =>
                            {widget.objUser.googleMapLink = value},
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          prefixIcon: setImageName("iconLink.png", 20, 20),
                          errorMaxLines: 3,
                          errorText: null,
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(15, 30, 0, 10),
                          disabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(244, 247, 250, 1),
                                width: 1),
                          ),
                          border: new OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: new BorderSide(
                                  color: Color.fromRGBO(244, 247, 250, 1))),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Google MapLink",
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              color: Colors.grey,
                              height: txtLinkController.text == "" ? 2.8 : 1.2),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(244, 247, 250, 1)),
                          ),
                        ),
                        cursorColor: Colors.black,
                      ))),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 57,
                      child: setbuttonWithChild(
                          isLoading
                              ? Container(
                                  width: 30,
                                  height: 30,
                                  child: setButtonIndicator(4, Colors.white),
                                )
                              : setCustomFont(
                                  "Save", 16, Colors.white, FontWeight.w400, 1),
                          () {
                        updateReciverDetail();
                      }, appColor, Colors.purple[900], 5)),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateReciverDetail() {
    if (txtFirstNameController.text.trim() == "") {
      setState(() {
        isFNameEmpty = true;
      });
      return;
    }

    if (txtAddressController.text.trim() == "") {
      setState(() {
        isAddressEmpty = true;
      });
      return;
    }

    if (txtMobileNumberController.text.trim() == "") {
      setState(() {
        isPhone1Validation = true;
        isPhone1Empty = true;
        isPhone1Invalid = false;
      });
      return;
    }
    if (txtMobileNumberController.text.trim().length != 10) {
      setState(() {
        isPhone1Validation = true;
        isPhone1Empty = false;
        isPhone1Invalid = true;
      });
      return;
    }
    if (txtMobileNumber2Controller.text.trim() != "") {
      if (txtMobileNumber2Controller.text.trim().length != 10) {
        setState(() {
          isPhone2Validation = true;
          isPhone2Empty = false;
          isPhone2Invalid = true;
        });
        return;
      }
    }

    widget.objUser.name = "";
    widget.objUser.address = "";
    widget.objUser.mobileNumber1 = "";
    widget.objUser.mobileNumber2 = "";
    widget.objUser.googleMapLink = "";

    setState(() {
      widget.objUser.name = txtFirstNameController.text;
      widget.objUser.address = txtAddressController.text;
      widget.objUser.mobileNumber1 = txtMobileNumberController.text;
      widget.objUser.mobileNumber2 = txtMobileNumber2Controller.text;
      widget.objUser.googleMapLink = widget.url;

      widget.isEdit == true
          ? showGreenToast(
              "Receiver details have been edited successfully.", context)
          : showGreenToast(
              "Receiver details have been added successfully.", context);
      widget.updateUserDetail(widget.objUser);
      afterDelay(1, () {
        Navigator.pop(context);
      });
    });
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
}
