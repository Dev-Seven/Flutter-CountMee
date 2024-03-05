import 'dart:io';

import 'package:countmee/Model/PackageListModel.dart';
import 'package:countmee/Model/PackageAPIDetail.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
Title : AddProductVC Screen
Purpose: AddProductVC Screen
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class AddProductVC extends StatefulWidget {
  final PackageAPIDetail objPackage;
  final Function packageDetail;
  final bool isEdit;
  final dynamic arrImages;
  const AddProductVC(
    this.isEdit, {
    Key key,
    this.objPackage,
    this.packageDetail,
    this.arrImages,
  }) : super(key: key);
  @override
  _AddProductVCState createState() => _AddProductVCState();
}

class _AddProductVCState extends State<AddProductVC> {
  final txtProductWaightController = TextEditingController();
  final txtProductCareController = TextEditingController();
  final txtProductDescController = TextEditingController();
  final txtOtherProductDescController = TextEditingController();
  var checkBoxValue = true;
  var courierBag;
  var _desc = FocusNode();
  var _otherDesc = FocusNode();
  var _care = FocusNode();
  var _weight = FocusNode();
  var box1Selected = true;
  var box2Selected = false;
  var box3Selected = false;
  var images = [];
  var isLoading = false;
  var isImageLoading = false;
  var imageUploadName = "UploadProductImage.png";
  var greyColor = Color.fromRGBO(178, 178, 178, 1);
  String _error;
  var objLocalProduct = PackageAPIDetail();
  File side1Image;
  String side1path;
  File side2Image;
  String side2path;
  File side3Image;
  String side3path;
  File side4Image;
  String side4path;
  File bottomImage;
  String bottompath;
  File topImage;
  String toppath;
  List<String> arrImagePaths = [];

  var isDescEmpty = false;
  var isOtherDescEmpty = false;
  var isHandleProductEmpty = false;
  var isWeightEmpty = false;
  SharedPreferences saveimage;
  bool isOtherDesc = false;
  bool isDescription = false;
  bool isWeight = false;
  bool isHandling = false;
  List<PackageListModel> descriptionList = [];
  List<PackageListModel> weightList = [];
  List<PackageListModel> handlingList = [];

  @override
  void initState() {
    super.initState();
    if (saveimage != null) {
      saveimage.clear();
    }
    getDescriptionList();
    getWeightList();
    getHandlingList();
    objLocalProduct.parcelSize = "Small";
    objLocalProduct.courierBag = 1;
    txtProductCareController.addListener(() {
      validation();
    });
    txtProductWaightController.addListener(() {
      validation();
    });
    txtProductDescController.addListener(() {
      validation();
    });

    if (widget.isEdit == true) {
      setState(() {
        txtProductWaightController.text = widget.objPackage.weight;
        objLocalProduct.weight = widget.objPackage.weight;
        txtProductCareController.text = widget.objPackage.handleProduct;
        objLocalProduct.handleProduct = widget.objPackage.handleProduct;
        txtProductDescController.text = widget.objPackage.productDesc;
        objLocalProduct.productDesc = widget.objPackage.productDesc;
        txtOtherProductDescController.text = widget.objPackage.otherProductDesc;
        objLocalProduct.otherProductDesc = widget.objPackage.otherProductDesc;
        if (txtProductDescController.text == "Others") {
          isOtherDesc = true;
        }
        objLocalProduct.parcelSize = widget.objPackage.parcelSize;
        if (widget.objPackage.courierBag != null) {
          if (widget.objPackage.courierBag == 1) {
            checkBoxValue = true;
          } else {
            checkBoxValue = false;
          }
        } else {
          checkBoxValue = true;
        }
        objLocalProduct.courierBag = widget.objPackage.courierBag;

        if (objLocalProduct.parcelSize == "Small") {
          box1Selected = true;
          box2Selected = false;
          box3Selected = false;
        }
        if (objLocalProduct.parcelSize == "Medium") {
          box2Selected = true;
          box1Selected = false;
          box3Selected = false;
        }
        if (objLocalProduct.parcelSize == "Large") {
          box3Selected = true;
          box1Selected = false;
          box2Selected = false;
        }

        side1path = widget.arrImages[0] != "" ? widget.arrImages[0] : "";
        side2path = widget.arrImages[1] != "" ? widget.arrImages[1] : "";
        side3path = widget.arrImages[2] != "" ? widget.arrImages[2] : "";
        side4path = widget.arrImages[3] != "" ? widget.arrImages[3] : "";
        toppath = widget.arrImages[4] != "" ? widget.arrImages[4] : "";
        bottompath = widget.arrImages[5] != "" ? widget.arrImages[5] : "";

        side1Image =
            widget.arrImages[0] != "" ? File(widget.arrImages[0]) : null;
        side2Image =
            widget.arrImages[1] != "" ? File(widget.arrImages[1]) : null;
        side3Image =
            widget.arrImages[2] != "" ? File(widget.arrImages[2]) : null;
        side4Image =
            widget.arrImages[3] != "" ? File(widget.arrImages[3]) : null;
        topImage = widget.arrImages[4] != "" ? File(widget.arrImages[4]) : null;
        bottomImage =
            widget.arrImages[5] != "" ? File(widget.arrImages[5]) : null;
      });
    }
  }

  getDescriptionList() {
    setState(() {
      isDescription = true;
    });

    postDataRequestWithToken(descriptionListAPI, null, context).then((value) {
      if (value is Map) {
        if (value[kStatusCode] == 200) {
          _handleDataResponse(value[kData]);
        } else if (value[kStatusCode] == 500) {
          showCustomToast(
              'Something went wrong.\nplease check after sometime.', context);
        } else {
          showCustomToast(value[kMessage].toString(), context);
        }
      } else {
        showCustomToast(value.toString(), context);
      }
    });
  }

  _handleDataResponse(value) {
    var arrData = value
        .map<PackageListModel>((json) => PackageListModel.fromJson(json))
        .toList();

    descriptionList.clear();
    setState(() {
      descriptionList = arrData;
      isDescription = false;
    });
  }

  getWeightList() {
    setState(() {
      isWeight = true;
    });

    postDataRequestWithToken(weightListAPI, null, context).then((value) {
      if (value is Map) {
        if (value[kStatusCode] == 200) {
          _handleWeightDataResponse(value[kData]);
        } else if (value[kStatusCode] == 500) {
          showCustomToast(
              'Something went wrong.\nplease check after sometime.', context);
        }else {
          showCustomToast(value[kMessage].toString(), context);
        }
      } else {
        showCustomToast(value.toString(), context);
      }
    });
  }

  _handleWeightDataResponse(value) {
    var arrData = value
        .map<PackageListModel>((json) => PackageListModel.fromJson(json))
        .toList();

    weightList.clear();
    setState(() {
      weightList = arrData;
      isWeight = false;
    });
  }

  getHandlingList() {
    setState(() {
      isHandling = true;
    });

    postDataRequestWithToken(handlingListAPI, null, context).then((value) {
      if (value is Map) {
        if (value[kStatusCode] == 200) {
          _handleHandlingDataResponse(value[kData]);
        } else if (value[kStatusCode] == 500) {
          showCustomToast(
              'Something went wrong.\nplease check after sometime.', context);
        }else {
          showCustomToast(value[kMessage].toString(), context);
        }
      } else {
        showCustomToast(value.toString(), context);
      }
    });
  }

  _handleHandlingDataResponse(value) {
    var arrData = value
        .map<PackageListModel>((json) => PackageListModel.fromJson(json))
        .toList();

    handlingList.clear();
    setState(() {
      handlingList = arrData;
      isHandling = false;
    });
  }

  validation() {
    setState(() {
      isHandleProductEmpty = false;
      isWeightEmpty = false;
      isDescEmpty = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: setCustomFont(
              "Package Details", 20, textBlackColor, FontWeight.w700, 1),
          leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
            Navigator.pop(context);
          }, Colors.transparent, Colors.transparent, 0),
        ),
        body: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              height: isDescEmpty ? 80 : 57,
                              child: Stack(
                                children: [
                                  Theme(
                                      data: new ThemeData(),
                                      child: TextField(
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black,
                                            height: 1.2),
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        controller: txtProductDescController,
                                        onChanged: (value) {},
                                        decoration: InputDecoration(
                                          errorMaxLines: 3,
                                          errorText: isDescEmpty
                                              ? msgEmptyDescription
                                              : null,
                                          isDense: true,
                                          contentPadding:
                                              EdgeInsets.fromLTRB(8, 30, 0, 10),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color.fromRGBO(
                                                244,
                                                247,
                                                250,
                                                1,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                          border: new OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              borderSide: new BorderSide(
                                                  color: Color.fromRGBO(
                                                      244, 247, 250, 1))),
                                          filled: false,
                                          fillColor: backgroundColor,
                                          hintText: "Product Description",
                                          hintStyle: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.grey,
                                            height: 1.2,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    244, 247, 250, 1)),
                                          ),
                                        ),
                                        cursorColor: Colors.black,
                                      )),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Spacer(),
                                          Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 8,
                                            height: 57,
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      showDescriptionPopup();
                                    },
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            isOtherDesc == true
                                ? Container(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                                    height: isOtherDescEmpty ? 140 : 117,
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
                                          focusNode: _otherDesc,
                                          maxLines: 4,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          controller:
                                              txtOtherProductDescController,
                                          onChanged: (value) {
                                            setState(() {
                                              isOtherDescEmpty = false;
                                            });
                                            objLocalProduct.otherProductDesc =
                                                value.toString().trim();
                                          },
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            errorMaxLines: 3,
                                            errorText: isOtherDescEmpty
                                                ? msgEmptyOtherDescription
                                                : null,
                                            isDense: true,
                                            contentPadding: EdgeInsets.fromLTRB(
                                                8, 30, 0, 10),
                                            enabledBorder:
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
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Product Description",
                                            hintStyle: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                                color: Colors.grey,
                                                height: 1.2),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      244, 247, 250, 1)),
                                            ),
                                          ),
                                          cursorColor: Colors.black,
                                        )),
                                  )
                                : Container(),
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              height: isWeightEmpty ? 80 : 57,
                              child: Stack(
                                children: [
                                  Theme(
                                      data: new ThemeData(),
                                      child: TextField(
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black,
                                            height: 1.2),
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        controller: txtProductWaightController,
                                        onChanged: (value) {},
                                        decoration: InputDecoration(
                                          errorMaxLines: 3,
                                          errorText: isWeightEmpty
                                              ? msgEmptyWeight
                                              : null,
                                          isDense: true,
                                          contentPadding:
                                              EdgeInsets.fromLTRB(8, 30, 0, 10),
                                          enabledBorder:
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
                                          hintText: "Package weight",
                                          hintStyle: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.grey,
                                            height: 1.2,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    244, 247, 250, 1)),
                                          ),
                                        ),
                                        cursorColor: Colors.black,
                                      )),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Spacer(),
                                          Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 8,
                                            height: 57,
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      productWeight();
                                    },
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              height: isHandleProductEmpty ? 80 : 57,
                              child: Stack(
                                children: [
                                  Theme(
                                      data: new ThemeData(),
                                      child: TextField(
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black,
                                            height: 1.2),
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        controller: txtProductCareController,
                                        onChanged: (value) {},
                                        decoration: InputDecoration(
                                          errorMaxLines: 3,
                                          errorText: isHandleProductEmpty
                                              ? msgEmptyProduct
                                              : null,
                                          isDense: true,
                                          contentPadding:
                                              EdgeInsets.fromLTRB(8, 30, 0, 10),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color.fromRGBO(
                                                244,
                                                247,
                                                250,
                                                1,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                          border: new OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              borderSide: new BorderSide(
                                                  color: Color.fromRGBO(
                                                      244, 247, 250, 1))),
                                          filled: false,
                                          fillColor: backgroundColor,
                                          hintText: "Normal",
                                          hintStyle: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black,
                                            height: 1.2,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    244, 247, 250, 1)),
                                          ),
                                        ),
                                        cursorColor: Colors.black,
                                      )),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Spacer(),
                                          Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 8,
                                            height: 57,
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      showDileveryTypePopup();
                                    },
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              alignment: Alignment.centerLeft,
                              child: setCustomFont(
                                  "Select the approximate size of your parcel.",
                                  14,
                                  textBlackColor,
                                  FontWeight.w500,
                                  1),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              height: MediaQuery.of(context).size.width / 2.8,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      box1Selected = false;
                                      box2Selected = false;
                                      box3Selected = false;
                                      setState(() {
                                        box1Selected = true;
                                      });

                                      objLocalProduct.parcelSize = "Small";
                                    },
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: setImageName(
                                                box1Selected
                                                    ? "iconSmallE.png"
                                                    : "iconSmallD.png",
                                                63,
                                                54),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          setCustomFont(
                                              "Small",
                                              15,
                                              textBlackColor,
                                              FontWeight.w400,
                                              1)
                                        ],
                                      ),
                                      width: MediaQuery.of(context).size.width /
                                          3.7,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          border: Border.all(
                                            width: 2,
                                            color: box1Selected
                                                ? appColor
                                                : Color.fromRGBO(
                                                    235, 235, 235, 1),
                                          )),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      box1Selected = false;
                                      box2Selected = false;
                                      box3Selected = false;
                                      setState(() {
                                        box2Selected = true;
                                      });
                                      objLocalProduct.parcelSize = "Medium";
                                    },
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: setImageName(
                                                box2Selected
                                                    ? "iconMediumE.png"
                                                    : "iconMediumD.png",
                                                63,
                                                54),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          setCustomFont(
                                              "Medium",
                                              15,
                                              textBlackColor,
                                              FontWeight.w400,
                                              1)
                                        ],
                                      ),
                                      width: MediaQuery.of(context).size.width /
                                          3.7,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          border: Border.all(
                                              width: 2,
                                              color: box2Selected
                                                  ? appColor
                                                  : Color.fromRGBO(
                                                      235, 235, 235, 1))),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      box1Selected = false;
                                      box2Selected = false;
                                      box3Selected = false;
                                      setState(() {
                                        box3Selected = true;
                                      });
                                      objLocalProduct.parcelSize = "Large";
                                    },
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: setImageName(
                                                box3Selected
                                                    ? "iconLargeE.png"
                                                    : "iconLargeD.png",
                                                63,
                                                54),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          setCustomFont(
                                              "Large",
                                              15,
                                              textBlackColor,
                                              FontWeight.w400,
                                              1)
                                        ],
                                      ),
                                      width: MediaQuery.of(context).size.width /
                                          3.7,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          border: Border.all(
                                              width: 2,
                                              color: box3Selected
                                                  ? appColor
                                                  : Color.fromRGBO(
                                                      235, 235, 235, 1))),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      child: InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        checkBoxValue = !checkBoxValue;
                                        courierBag = checkBoxValue;
                                        if (courierBag == true) {
                                          objLocalProduct.courierBag = 1;
                                        } else {
                                          objLocalProduct.courierBag = 0;
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: checkBoxValue
                                              ? appColor
                                              : Colors.transparent,
                                          border: Border.all(color: appColor),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4),
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: checkBoxValue
                                            ? Icon(
                                                Icons.check,
                                                size: 21.0,
                                                color: Colors.white,
                                              )
                                            : Container(
                                                width: 21,
                                                height: 21,
                                              ),
                                      ),
                                    ),
                                  )),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 25,
                                    child: setCustomFont("Courier Bag", 14,
                                        textBlackColor, FontWeight.w400, 1),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            boxShadow: [getShadow(0, 0, 15)]),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 18, 15, 0),
                              alignment: Alignment.centerLeft,
                              child: setCustomFont("Upload parcel images", 14,
                                  textBlackColor, FontWeight.w500, 1),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              alignment: Alignment.centerLeft,
                              child: setCustomFont(
                                  "* Minimum 2 images is mandatory",
                                  12,
                                  textBlackColor,
                                  FontWeight.w500,
                                  1),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      loadAssets(1);
                                    },
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: side1Image != null
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.7,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.2,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 2,
                                                    color: appColor,
                                                  ),
                                                ),
                                                child: Image.file(
                                                  side1Image,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                setImageName(
                                                    imageUploadName, 30, 30),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                setCustomFont(
                                                    "Side 1",
                                                    15,
                                                    greyColor,
                                                    FontWeight.w400,
                                                    1)
                                              ],
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.7,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.2,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Color.fromRGBO(
                                                        235, 235, 235, 1))),
                                          ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      loadAssets(2);
                                    },
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: side2Image != null
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.7,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.2,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 2,
                                                    color: appColor,
                                                  ),
                                                ),
                                                child: Image.file(side2Image,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                setImageName(
                                                    imageUploadName, 30, 30),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                setCustomFont(
                                                    "Side 2",
                                                    15,
                                                    greyColor,
                                                    FontWeight.w400,
                                                    1)
                                              ],
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.7,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.2,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Color.fromRGBO(
                                                        235, 235, 235, 1))),
                                          ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      loadAssets(3);
                                    },
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: side3Image != null
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.7,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.2,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 2,
                                                    color: appColor,
                                                  ),
                                                ),
                                                child: Image.file(side3Image,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                setImageName(
                                                    imageUploadName, 30, 30),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                setCustomFont(
                                                    "Side 3",
                                                    15,
                                                    greyColor,
                                                    FontWeight.w400,
                                                    1)
                                              ],
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.7,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.2,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Color.fromRGBO(
                                                        235, 235, 235, 1))),
                                          ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 11,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      loadAssets(4);
                                    },
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: side4Image != null
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.7,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.2,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 2,
                                                    color: appColor,
                                                  ),
                                                ),
                                                child: Image.file(side4Image,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                setImageName(
                                                    imageUploadName, 30, 30),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                setCustomFont(
                                                    "Side 4",
                                                    15,
                                                    greyColor,
                                                    FontWeight.w400,
                                                    1)
                                              ],
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.7,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.2,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Color.fromRGBO(
                                                        235, 235, 235, 1))),
                                          ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      loadAssets(5);
                                    },
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: topImage != null
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.7,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.2,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 2,
                                                    color: appColor,
                                                  ),
                                                ),
                                                child: Image.file(topImage,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                setImageName(
                                                    imageUploadName, 30, 30),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                setCustomFont(
                                                    "Top",
                                                    15,
                                                    greyColor,
                                                    FontWeight.w400,
                                                    1)
                                              ],
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.7,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.2,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Color.fromRGBO(
                                                        235, 235, 235, 1))),
                                          ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      loadAssets(6);
                                    },
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: bottomImage != null
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.7,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.2,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 2,
                                                    color: appColor,
                                                  ),
                                                ),
                                                child: Image.file(bottomImage,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                setImageName(
                                                    imageUploadName, 30, 30),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                setCustomFont(
                                                    "Bottom",
                                                    15,
                                                    greyColor,
                                                    FontWeight.w400,
                                                    1)
                                              ],
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.7,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.2,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Color.fromRGBO(
                                                        235, 235, 235, 1))),
                                          ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            boxShadow: [getShadow(0, 0, 15)]),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      height: 57,
                      width: double.infinity,
                      child: Container(
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
                                  : setCustomFont("Save", 16, Colors.white,
                                      FontWeight.w400, 1.2), () {
                            addProduct();
                          }, appColor, Colors.purple[900], 5)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              (isImageLoading)
                  ? Container(
                      color: Colors.white,
                      child: Center(
                        child: setButtonIndicator(2, appColor),
                      ))
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  showDescriptionPopup() {
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
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                shrinkWrap: true,
                itemCount: descriptionList.length,
                itemBuilder: (context, position) {
                  return InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      txtProductDescController.text =
                          (descriptionList[position].name);
                      objLocalProduct.productDesc =
                          descriptionList[position].name;
                      if (txtProductDescController.text == "Others") {
                        setState(() {
                          isOtherDesc = true;
                        });
                      } else {
                        setState(() {
                          objLocalProduct.otherProductDesc = "";
                          isOtherDesc = false;
                        });
                      }
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
                                Container(
                                  child: setCustomFont(
                                      descriptionList[position].name,
                                      14,
                                      textBlackColor,
                                      FontWeight.w400,
                                      1),
                                ),
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
              )),
        );
      },
    );
  }

  productWeight() {
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
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                shrinkWrap: true,
                itemCount: weightList.length,
                itemBuilder: (context, position) {
                  return InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      txtProductWaightController.text =
                          (weightList[position].name);
                      objLocalProduct.weight = weightList[position].name;
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
                                Container(
                                  child: setCustomFont(
                                      weightList[position].name,
                                      14,
                                      textBlackColor,
                                      FontWeight.w400,
                                      1),
                                ),
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
              )),
        );
      },
    );
  }

  addProduct() {
    if (txtProductDescController.text == "") {
      setState(() {
        isDescEmpty = true;
      });
      return;
    }
    if (isOtherDesc == true) {
      if (txtOtherProductDescController.text == "") {
        setState(() {
          isOtherDescEmpty = true;
          _otherDesc.requestFocus();
        });
        return;
      }
    }
    if (txtProductWaightController.text == "") {
      setState(() {
        isWeightEmpty = true;
      });
      return;
    }
    if (txtProductCareController.text == "") {
      setState(() {
        objLocalProduct.handleProduct = handlingList[1].name;
      });
    }

    List imageCount = [];
    arrImagePaths.clear();

    if (side1Image != null) {
      imageCount.add(side1Image);
      arrImagePaths.add(side1path);
    } else {
      arrImagePaths.add("");
    }
    if (side2Image != null) {
      imageCount.add(side2Image);
      arrImagePaths.add(side2path);
    } else {
      arrImagePaths.add("");
    }
    if (side3Image != null) {
      imageCount.add(side3Image);
      arrImagePaths.add(side3path);
    } else {
      arrImagePaths.add("");
    }
    if (side4Image != null) {
      imageCount.add(side4Image);
      arrImagePaths.add(side4path);
    } else {
      arrImagePaths.add("");
    }
    if (topImage != null) {
      imageCount.add(topImage);
      arrImagePaths.add(toppath);
    } else {
      arrImagePaths.add("");
    }
    if (bottomImage != null) {
      imageCount.add(bottomImage);
      arrImagePaths.add(bottompath);
    } else {
      arrImagePaths.add("");
    }
    if (imageCount.length < 2) {
      showCustomToast("Please upload minimum 2 images", context);
      return;
    }

    widget.packageDetail(objLocalProduct, arrImagePaths);
    widget.isEdit == true
        ? showGreenToast(
            "Package details have been edited successfully.", context)
        : showGreenToast(
            "Package details have been added successfully.", context);
    afterDelay(1, () {
      Navigator.of(context).pop({
        "arrImages": arrImagePaths,
      });
    });
  }

  showDileveryTypePopup() {
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
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                shrinkWrap: true,
                itemCount: handlingList.length,
                itemBuilder: (context, position) {
                  return InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      txtProductCareController.text =
                          (handlingList[position].name);
                      objLocalProduct.handleProduct =
                          handlingList[position].name;
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
                                Container(
                                  child: setCustomFont(
                                    handlingList[position].name,
                                    14,
                                    textBlackColor,
                                    FontWeight.w400,
                                    1,
                                  ),
                                ),
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
              )),
        );
      },
    );
  }

  Future<void> _showPhotoPermissionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission to Photos'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'This app needs access to Photos in order to add an image',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      color: textBlackColor,
                      height: 1),
                )
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoButton(
              // focusColor: Colors.transparent,
              // highlightColor: Colors.transparent,
              // hoverColor: Colors.transparent,
              // splashColor: Colors.transparent,
              child: Text('Cancel', style: TextStyle(color: textBlackColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoButton(
              // focusColor: Colors.transparent,
              // highlightColor: Colors.transparent,
              // hoverColor: Colors.transparent,
              // splashColor: Colors.transparent,
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> loadAssets(int index) async {
    FocusScope.of(context).unfocus();
    if (Platform.isAndroid) {
      // var status = await Permission.storage.request();
      // if (status == PermissionStatus.denied ||
      //     status == PermissionStatus.permanentlyDenied) {
      //   _showStoragePermissionDialog();
      // }
      // Permission.storage.isDenied.then((value) => {
      //       if (value)
      //         {
      //           _showStoragePermissionDialog(),
      //         }
      //     });
      Permission.photos.isDenied.then((value) => {
            if (value)
              {
                _showPhotoPermissionDialog(),
              }
          });
    }

    var status = await Permission.photos.request();
    if (status == PermissionStatus.denied) {
      return _showPhotoPermissionDialog();
    }
    if (!mounted) return;
    _loadPicker(index);
  }

  // Future<void> _showStoragePermissionDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Permission to Storage'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text(
  //                 'This app needs access to Storage in order to upload an image',
  //                 style: TextStyle(fontFamily: popinsRegFont),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           CupertinoButton(
  //             child: Text('Cancel', style: TextStyle(color: Colors.red)),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           CupertinoButton(
  //             child: Text('Approve'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               openAppSettings();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  _loadPicker(int index) async {
    setState(() {
      isImageLoading = true;
    });

    PickedFile picked = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 25);
    if (picked != null) {
      _cropImage(picked, index).then((File cropped) {
        SaveImage(cropped.path, index);
      });
    } else {
      setState(() {
        isImageLoading = false;
      });
    }
  }

  Future<File> _cropImage(PickedFile picked, int index) async {
    File cropped = (await ImageCropper().cropImage(
      compressQuality: 30,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: "Edit Image",
        statusBarColor: Colors.green,
        toolbarColor: Colors.green,
        toolbarWidgetColor: Colors.white,
      ),
      sourcePath: picked.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      maxWidth: 800,
    ));
    if (cropped != null) {
      setState(() {
        if (index == 1) {
          side1Image = cropped;
          side1path = cropped.path;
        } else if (index == 2) {
          side2Image = cropped;
          side2path = cropped.path;
        } else if (index == 3) {
          side3Image = cropped;
          side3path = cropped.path;
        } else if (index == 4) {
          side4Image = cropped;
          side4path = cropped.path;
        } else if (index == 5) {
          topImage = cropped;
          toppath = cropped.path;
        } else if (index == 6) {
          bottomImage = cropped;
          bottompath = cropped.path;
        }
      });
    }
    setState(() {
      isImageLoading = false;
    });

    return cropped;
  }

  void SaveImage(path, index) async {
    saveimage = await SharedPreferences.getInstance();
    if (index == 1) {
      saveimage.setString("imagepath1", path);
    } else if (index == 2) {
      saveimage.setString("imagepath2", path);
    } else if (index == 3) {
      saveimage.setString("imagepath3", path);
    } else if (index == 4) {
      saveimage.setString("imagepath4", path);
    } else if (index == 5) {
      saveimage.setString("imagepath5", path);
    } else if (index == 6) {
      saveimage.setString("imagepath6", path);
    }
  }

  void LoadImage(int index) async {
    saveimage = await SharedPreferences.getInstance();
    setState(() {
      if (index == 1) {
        side1path = saveimage.getString("imagepath1");
      } else if (index == 2) {
        side2path = saveimage.getString("imagepath2");
      } else if (index == 3) {
        side3path = saveimage.getString("imagepath3");
      } else if (index == 4) {
        side4path = saveimage.getString("imagepath4");
      } else if (index == 5) {
        toppath = saveimage.getString("imagepath5");
      } else if (index == 6) {
        bottompath = saveimage.getString("imagepath6");
      }
    });
  }
}
