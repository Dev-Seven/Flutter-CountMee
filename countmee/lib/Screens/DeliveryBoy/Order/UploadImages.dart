import 'dart:io';

import 'package:countmee/Model/PandingDataModel.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
Title : UploadImages
Purpose: UploadImages
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class UploadImages extends StatefulWidget {
  final bool isView;
  final List<PackageDetail> packageDetails;
  final List<PackageImage> packageImages;

  const UploadImages({
    Key key,
    this.isView,
    this.packageImages,
    this.packageDetails,
  }) : super(key: key);

  @override
  _UploadImagesState createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  dynamic side1Image;
  String side1path;
  dynamic side2Image;
  dynamic side2;
  String side2path;
  dynamic side3Image;
  String side3path;
  dynamic side4Image;
  String side4path;
  dynamic bottomImage;
  String bottompath;
  dynamic topImage;

  String toppath;
  var imageUploadName = "UploadProductImage.png";
  var greyColor = Color.fromRGBO(178, 178, 178, 1);
  List<String> arrImagePaths = [];
  var isLoading = false;
  var isImageLoading = false;

  @override
  void initState() {
    super.initState();
    imageCount.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: setCustomFont(
            "Order Details", 20, textBlackColor, FontWeight.w600, 1),
        leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
          Navigator.pop(context);
        }, Colors.transparent, Colors.transparent, 0),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          setCustomFont("Product Details", 16, textBlackColor,
                              FontWeight.w600, 1),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 1,
                            color: Color.fromRGBO(226, 226, 226, 1),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: setCustomFontWithAlignment(
                                widget.packageDetails[0].productDesc == 'Others'
                                    ? widget.packageDetails[0].otherProductDesc
                                    : widget.packageDetails[0].productDesc ??
                                        "",
                                16,
                                textBlackColor,
                                FontWeight.w500,
                                1,
                                TextAlign.left),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            child: setCustomFontWithAlignment(
                                widget.packageDetails[0].weight ?? "",
                                14,
                                textBlackColor,
                                FontWeight.w400,
                                1,
                                TextAlign.left),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            child: setCustomFontWithAlignment(
                                widget.packageDetails[0].handleProduct ?? "",
                                14,
                                textBlackColor,
                                FontWeight.w400,
                                1,
                                TextAlign.left),
                          ),
                          SizedBox(
                            height: 8,
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
                            padding: EdgeInsets.fromLTRB(15, 18, 10, 0),
                            alignment: Alignment.centerLeft,
                            child: setCustomFont(
                                "Upload parcel images from all sides.",
                                14,
                                textBlackColor,
                                FontWeight.w500,
                                1),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          widget.isView
                              ? Padding(
                                  padding: EdgeInsets.fromLTRB(15, 18, 10, 0),
                                  child: GridView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.all(0),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: widget
                                                          .packageImages
                                                          .length ==
                                                      2
                                                  ? 2
                                                  : widget.packageImages
                                                              .length ==
                                                          4
                                                      ? 2
                                                      : 3,
                                              childAspectRatio:
                                                  widget.packageImages.length ==
                                                          2
                                                      ? 0.99
                                                      : widget.packageImages
                                                                  .length ==
                                                              4
                                                          ? 0.99
                                                          : 0.82,
                                              mainAxisSpacing: 10.0,
                                              crossAxisSpacing: 10.0),
                                      itemCount: widget.packageImages.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          width: Device.screenWidth / 3.7,
                                          height: Device.screenWidth / 3.2,
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
                                              child: setPackageImage(widget
                                                  .packageImages[index].image),
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 0, 15, 0),
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
                                                    width: Device.screenWidth /
                                                        3.7,
                                                    height: Device.screenWidth /
                                                        3.2,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            width: 2,
                                                            color: appColor,
                                                          ),
                                                        ),
                                                        child: Image.file(
                                                            side1Image,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        setImageName(
                                                            imageUploadName,
                                                            30,
                                                            30),
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
                                                    width: Device.screenWidth /
                                                        3.7,
                                                    height: Device.screenWidth /
                                                        3.2,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        border: Border.all(
                                                            width: 2,
                                                            color:
                                                                Color.fromRGBO(
                                                                    235,
                                                                    235,
                                                                    235,
                                                                    1))),
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
                                                    width: Device.screenWidth /
                                                        3.7,
                                                    height: Device.screenWidth /
                                                        3.2,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            width: 2,
                                                            color: appColor,
                                                          ),
                                                        ),
                                                        child: Image.file(
                                                            side2Image,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        setImageName(
                                                            imageUploadName,
                                                            30,
                                                            30),
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
                                                    width: Device.screenWidth /
                                                        3.7,
                                                    height: Device.screenWidth /
                                                        3.2,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        border: Border.all(
                                                            width: 2,
                                                            color:
                                                                Color.fromRGBO(
                                                                    235,
                                                                    235,
                                                                    235,
                                                                    1))),
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
                                                    width: Device.screenWidth /
                                                        3.7,
                                                    height: Device.screenWidth /
                                                        3.2,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            width: 2,
                                                            color: appColor,
                                                          ),
                                                        ),
                                                        child: Image.file(
                                                            side3Image,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        setImageName(
                                                            imageUploadName,
                                                            30,
                                                            30),
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
                                                    width: Device.screenWidth /
                                                        3.7,
                                                    height: Device.screenWidth /
                                                        3.2,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        border: Border.all(
                                                            width: 2,
                                                            color:
                                                                Color.fromRGBO(
                                                                    235,
                                                                    235,
                                                                    235,
                                                                    1))),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 0, 15, 0),
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
                                                    width: Device.screenWidth /
                                                        3.7,
                                                    height: Device.screenWidth /
                                                        3.2,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            width: 2,
                                                            color: appColor,
                                                          ),
                                                        ),
                                                        child: Image.file(
                                                            side4Image,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        setImageName(
                                                            imageUploadName,
                                                            30,
                                                            30),
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
                                                    width: Device.screenWidth /
                                                        3.7,
                                                    height: Device.screenWidth /
                                                        3.2,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        border: Border.all(
                                                            width: 2,
                                                            color:
                                                                Color.fromRGBO(
                                                                    235,
                                                                    235,
                                                                    235,
                                                                    1))),
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
                                                    width: Device.screenWidth /
                                                        3.7,
                                                    height: Device.screenWidth /
                                                        3.2,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            width: 2,
                                                            color: appColor,
                                                          ),
                                                        ),
                                                        child: Image.file(
                                                            topImage,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        setImageName(
                                                            imageUploadName,
                                                            30,
                                                            30),
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
                                                    width: Device.screenWidth /
                                                        3.7,
                                                    height: Device.screenWidth /
                                                        3.2,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        border: Border.all(
                                                            width: 2,
                                                            color:
                                                                Color.fromRGBO(
                                                                    235,
                                                                    235,
                                                                    235,
                                                                    1))),
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
                                                    width: Device.screenWidth /
                                                        3.7,
                                                    height: Device.screenWidth /
                                                        3.2,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            width: 2,
                                                            color: appColor,
                                                          ),
                                                        ),
                                                        child: Image.file(
                                                            bottomImage,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        setImageName(
                                                            imageUploadName,
                                                            30,
                                                            30),
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
                                                    width: Device.screenWidth /
                                                        3.7,
                                                    height: Device.screenWidth /
                                                        3.2,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        border: Border.all(
                                                            width: 2,
                                                            color:
                                                                Color.fromRGBO(
                                                                    235,
                                                                    235,
                                                                    235,
                                                                    1))),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                  (widget.isView)
                      ? SizedBox()
                      : Container(
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
                                          child: setButtonIndicator(
                                              3, Colors.white),
                                        )
                                      : setCustomFont(
                                          "Upload",
                                          16,
                                          Colors.white,
                                          FontWeight.w400,
                                          1.2), () {
                                uploadImages();
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
                : Center(),
          ],
        ),
      ),
    );
  }

  uploadImages() {
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

    AlertMessage(
      "Parcel images have been added successfully.",
      context,
      () {
        Navigator.pop(context);
        Navigator.pop(context);
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
  //             // focusColor: Colors.transparent,
  //             // highlightColor: Colors.transparent,
  //             // hoverColor: Colors.transparent,
  //             // splashColor: Colors.transparent,
  //             child: Text('Cancel', style: TextStyle(color: Colors.red)),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           CupertinoButton(
  //             // focusColor: Colors.transparent,
  //             // highlightColor: Colors.transparent,
  //             // hoverColor: Colors.transparent,
  //             // splashColor: Colors.transparent,
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

    PickedFile picked =
        await ImagePicker().getImage(source: ImageSource.camera);
    if (picked != null) {
      _cropImage(picked, index).then((File cropped) {
        SaveImage(cropped.path);
      });
    } else {
      setState(() {
        isImageLoading = false;
      });
    }
    LoadImage(index);
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
        } else if (index == 2) {
          side2Image = cropped;
        } else if (index == 3) {
          side3Image = cropped;
        } else if (index == 4) {
          side4Image = cropped;
        } else if (index == 5) {
          topImage = cropped;
        } else if (index == 6) {
          bottomImage = cropped;
        }
      });
    }
    setState(() {
      isImageLoading = false;
    });
    return cropped;
  }

  void SaveImage(path) async {
    SharedPreferences saveimage = await SharedPreferences.getInstance();
    saveimage.setString("imagepath", path);
  }

  void LoadImage(int index) async {
    SharedPreferences saveimage = await SharedPreferences.getInstance();
    setState(() {
      if (index == 1) {
        side1path = saveimage.getString("imagepath");
      } else if (index == 2) {
        side2path = saveimage.getString("imagepath");
      } else if (index == 3) {
        side3path = saveimage.getString("imagepath");
      } else if (index == 4) {
        side4path = saveimage.getString("imagepath");
      } else if (index == 5) {
        toppath = saveimage.getString("imagepath");
      } else if (index == 6) {
        bottompath = saveimage.getString("imagepath");
      }
    });
  }
}
