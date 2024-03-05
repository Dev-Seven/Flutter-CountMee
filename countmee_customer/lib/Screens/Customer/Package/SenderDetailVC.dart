import 'package:countmee/Model/UserAPIDetails.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/CountryCode.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/*
Title : SenderDetailVC Screen
Purpose: SenderDetailVC Screen
Created By : Kalpesh Khandla
Last Edited By : 3 Feb 2022
*/

class SenderDetailVC extends StatefulWidget {
  final Function updateUserDetail;
  UserAPIDetails objUser;
  final String url, address;
  final bool isEdit;

  SenderDetailVC({
    Key key,
    this.updateUserDetail,
    this.objUser,
    this.url,
    this.address,
    this.isEdit,
  }) : super(key: key);

  @override
  _SenderDetailVCState createState() => _SenderDetailVCState();
}

class _SenderDetailVCState extends State<SenderDetailVC> {
  var deliveryContactMe = true;
  var isLoading = false;
  final txtFirstNameController = TextEditingController();
  final txtAddressController = TextEditingController();
  final txtLandmarkController = TextEditingController();
  final txtMobileNumberController = TextEditingController();
  final txtAddressTypeController = TextEditingController();
  final txtLinkController = TextEditingController();
  final txtCountryCodeController = TextEditingController();
  var isFNameEmpty = false;
  var isAddressEmpty = false;
  var isAddressTypeEmpty = false;
  bool isLandMarkEmpty = false;
  var isPhoneValidation = false;
  var isPhoneEmpty = false;
  var isPhoneInvalid = false;
  var name, address, landmark, mobileNo, addressType;

  @override
  void initState() {
    super.initState();
    txtFirstNameController.text =
        widget.objUser.name == "" ? userObj.name : widget.objUser.name;
    txtAddressController.text =
        widget.objUser.address == "" ? widget.address : widget.objUser.address;
    txtMobileNumberController.text = widget.objUser.mobileNumber1 == ""
        ? userObj.phoneNumber
        : widget.objUser.mobileNumber1;
    txtLinkController.text = widget.objUser.googleMapLink == ""
        ? widget.url
        : widget.objUser.googleMapLink;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: setCustomFont(
            "Sender Details", 20, textBlackColor, FontWeight.w700, 1),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        deliveryContactMe = true;
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
                            name = value.toString().trim(),
                            setState(() {
                              isFNameEmpty = false;
                            }),
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
                            address = value.toString().trim(),
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
                  children: [
                    SizedBox(
                      width: 15,
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
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(25, 0, 18, 0),
                        child: setTextFieldMobileNo(
                          txtMobileNumberController,
                          "Mobile No.",
                          10,
                          TextInputType.number,
                          isPhoneValidation,
                          isPhoneEmpty
                              ? msgEmptyMobileNumber
                              : msgInvalidPhoneNumber,
                          false,
                          (value) => {
                            setState(() {
                              isPhoneValidation = false;
                            }),
                            mobileNo = value,
                          },
                        ),
                      ),
                    ),
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
                        updateSenderDetail();
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

  updateSenderDetail() {
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
        isPhoneValidation = true;
        isPhoneEmpty = true;
        isPhoneInvalid = false;
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

    widget.objUser.name = "";
    widget.objUser.address = "";
    widget.objUser.mobileNumber1 = "";
    widget.objUser.googleMapLink = "";

    if (widget.isEdit == true) {
      setState(() {
        widget.objUser.name = txtFirstNameController.text;
        widget.objUser.address = txtAddressController.text;
        widget.objUser.mobileNumber1 = txtMobileNumberController.text;
        widget.objUser.googleMapLink = widget.url;

        widget.isEdit == true
            ? showGreenToast(
                "Sender details have been edited successfully", context)
            : showGreenToast(
                "Sender details have been added successfully", context);

        widget.updateUserDetail(widget.objUser);
        afterDelay(1, () {
          Navigator.pop(context);
        });
      });
    }
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
                height: MediaQuery.of(context).size.width / 2,
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
