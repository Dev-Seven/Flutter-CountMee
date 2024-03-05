import 'dart:convert';
import 'dart:io';

import 'package:countmee/Model/DocumentModel.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
Title : DocumentVC
Purpose: DocumentVC
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class DocumentVC extends StatefulWidget {
  @override
  _DocumentVCState createState() => _DocumentVCState();
}

class _DocumentVCState extends State<DocumentVC> {
  final txtAadharController = TextEditingController();
  final txtVehicleController = TextEditingController();
  File _pickedAadharImage;
  String _aadharImagepath;
  File _pickedVehicleImage;
  String _vehicleImagepath;
  var canSave = false;
  String _error;
  var isLoading = false;
  var isDocLoading = false;
  DocumentModel objDoc;
  var isVehicleNoValidation = false;
  var isVehicleNoInvalid = false;
  var isVehicleNoEmpty = false;
  var isAadharNoValidation = false;
  var isAadharNoInvalid = false;
  var isAadharNoEmpty = false;
  var aadhaarImage;
  var vehicleImage;
  var isImageLoading = false;
  var orderId;
  var collectionId;

  @override
  void initState() {
    super.initState();

    checkConnection(context);
    getDocumentDetail();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        print('onMessage.....');
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;
        Map valueMap = json.decode(message.data['moredata']);
        orderId = valueMap['package_id'];
        collectionId = valueMap['collection_center_id'];
      });
    });
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isConnected == true) {
      setState(() {
        getDocumentDetail();
        isConnected = false;
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title:
            setCustomFont("Documents", 20, textBlackColor, FontWeight.w600, 1),
        leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
          Navigator.pop(context);
        }, Colors.transparent, Colors.transparent, 0),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 17, 0, 0),
                            alignment: Alignment.topLeft,
                            width: double.infinity,
                            child: setCustomFont("Aadhaar Card", 18,
                                textBlackColor, FontWeight.w500, 1),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: setDigitTextField(
                                txtAadharController,
                                "Enter Aadhaar number",
                                false,
                                TextInputType.number,
                                isAadharNoValidation,
                                isAadharNoEmpty
                                    ? msgEmptyAadharNo
                                    : msgInvalidAadharNo,
                                () => {
                                      setState(() {
                                        isAadharNoValidation = false;
                                        isAadharNoEmpty = false;
                                      })
                                    }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
                                child: InkWell(
                                  onTap: () {
                                    loadAssets(true);
                                  },
                                  child: DottedBorder(
                                    color: Colors.grey,
                                    dashPattern: [6, 6],
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(12),
                                    padding: EdgeInsets.all(6),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      child: objDoc != null
                                          ? setDocumentImage(aadhaarImage)
                                          : _pickedAadharImage != null
                                              ? Container(
                                                  width: double.infinity,
                                                  child: Image.file(
                                                      _pickedAadharImage,
                                                      fit: BoxFit.cover),
                                                )
                                              : Container(
                                                  color: Colors.white,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        setImageName(
                                                            "iconUploadCloud.png",
                                                            43,
                                                            31),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        setCustomFont(
                                                            "Upload your document here \n(docx, pdf, xlsx)",
                                                            14,
                                                            textBlackColor
                                                                .withAlpha(400),
                                                            FontWeight.w400,
                                                            1.5)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          boxShadow: [getdefaultShadow()]),
                      height: Device.screenHeight / 2.5,
                      width: Device.screenWidth - 30,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 17, 0, 0),
                            alignment: Alignment.topLeft,
                            width: double.infinity,
                            child: setCustomFont("Vehicle No. & RC Book", 18,
                                textBlackColor, FontWeight.w500, 1),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                              child: setTextFieldMobileNo(
                                  txtVehicleController,
                                  "Enter Vehicle number",
                                  10,
                                  TextInputType.text,
                                  isVehicleNoValidation,
                                  isVehicleNoEmpty
                                      ? msgEmptyVehicleNo
                                      : msgInvalidVehicleNo,
                                  false,
                                  (val) => {
                                        print(val),
                                        setState(() {
                                          isVehicleNoValidation = false;
                                          isVehicleNoEmpty = false;
                                        })
                                      })),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                                child: InkWell(
                                  onTap: () {
                                    loadAssets(false);
                                  },
                                  child: DottedBorder(
                                    color: Colors.grey,
                                    dashPattern: [6, 6],
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(12),
                                    padding: EdgeInsets.all(6),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      child: objDoc != null
                                          ? setDocumentImage(vehicleImage)
                                          : _pickedVehicleImage != null
                                              ? Container(
                                                  width: double.infinity,
                                                  child: Image.file(
                                                      _pickedVehicleImage,
                                                      fit: BoxFit.cover),
                                                )
                                              : Container(
                                                  color: Colors.white,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        setImageName(
                                                            "iconUploadCloud.png",
                                                            43,
                                                            31),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        setCustomFont(
                                                            "Upload your document here \n(docx, pdf, xlsx)",
                                                            14,
                                                            textBlackColor
                                                                .withAlpha(400),
                                                            FontWeight.w400,
                                                            1.5)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          boxShadow: [getdefaultShadow()]),
                      height: Device.screenHeight / 2.5,
                      width: Device.screenWidth - 30,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        height: 57,
                        width: double.infinity,
                        child: setbuttonWithChild(
                            isLoading
                                ? setButtonIndicator(1, Colors.white)
                                : setCustomFont("Save", 16, Colors.white,
                                    FontWeight.w400, 1.5), () {
                          if (connectionStatus ==
                              DataConnectionStatus.connected) {
                            updateDocument();
                          } else {
                            showCustomToast(
                                "Please check your internet connection",
                                context);
                          }
                        }, appColor, Colors.purple[900], 5)),
                    SizedBox(
                      height: 30,
                    ),
                    // Align(
                    //   alignment: Alignment.bottomCenter,
                    //   child: orderId != null
                    //       ? Container(child: _newTaskModalBottomSheet(context))
                    //       : Container(),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          (isImageLoading)
              ? Container(
                  color: Colors.white,
                  child: Center(
                    child: setButtonIndicator(2, appColor),
                  ),
                )
              : Center(),
        ],
      ),
    );
  }

  updateDocument() async {
    checkAllDetails();
    if (canSave == true) {
      FormData formData;
      setState(() {
        isLoading = true;
      });
      formData = FormData.fromMap({
        "adharcard_number": txtAadharController.text.trim(),
        "vehicle_number": txtVehicleController.text.trim(),
        "vehicle_file": await MultipartFile.fromFile(
          _pickedVehicleImage.path,
          filename: "${userObj.name}vehicle_file.png",
        ),
        "adharcard_file": await MultipartFile.fromFile(
          _pickedAadharImage.path,
          filename: "${userObj.name}adharcard_file.png",
        ),
      });
      postAPIRequestWithToken(uploadDocAPI, formData, context).then((value) {
        setState(() {
          isLoading = false;
        });
        if (value[kStatusCode] == 200) {
          AlertMessage("Your documents have been saved.", context, () {
            Navigator.of(context).pop(false);
            Navigator.of(context).pop(false);
            pushToViewController(context, DocumentVC(), () {});
          });
        } else {
          showCustomToast(value.toString(), context);
        }
      });
    }
  }

  // _newTaskModalBottomSheet(context) {
  //   afterDelay(1, () {
  //     showModalBottomSheet(
  //         backgroundColor: Colors.transparent,
  //         context: context,
  //         builder: (BuildContext context) {
  //           return NotificationBottomSheet(
  //             orderId: orderId,
  //             collectionId: collectionId,
  //           );
  //         });
  //   });
  // }

  getDocumentDetail() {
    setState(() {
      isDocLoading = true;
    });
    postAPIRequestWithToken(getUploadedDocAPI, null, context).then((value) {
      print("DOCUMENT VC :$value['message']");
      if (value is Map) {
        if (value['message'].toString() != 'No Document Found') {
          objDoc = DocumentModel.fromJson(value[kData]);
          setState(() {
            isDocLoading = false;

            txtAadharController.text = objDoc.adharcardNumber;
            txtVehicleController.text = objDoc.vehicleNumber;
            aadhaarImage = objDoc.adharcardFile;
            vehicleImage = objDoc.vehicleDocument;
          });
        }
      } else {
        print("Upload  DOC Error");
      }
    });
  }

  Future<void> loadAssets(bool isForAadhar) async {
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
    _showPickOptionDialog(context, isForAadhar);
  }

  _loadPicker(ImageSource source, bool isForAaadhar) async {
    Navigator.pop(context);

    setState(() {
      isImageLoading = true;
    });

    PickedFile picked = await ImagePicker().getImage(source: source);

    if (picked != null) {
      _cropImage(picked, isForAaadhar).then((File cropped) {
        SaveImage(cropped.path, isForAaadhar);
      });
    } else {
      setState(() {
        isImageLoading = false;
      });
    }
    LoadImage(isForAaadhar);
  }

  Future<File> _cropImage(PickedFile picked, bool isForAaadhar) async {
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
        if (isForAaadhar) {
          _pickedAadharImage = cropped;
        } else {
          _pickedVehicleImage = cropped;
        }
      });
    }
    setState(() {
      isImageLoading = false;
    });
    return cropped;
  }

  void _showPickOptionDialog(BuildContext context, bool isForAaadhar) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                      title: Text('Select from gallery'),
                      onTap: () {
                        _loadPicker(ImageSource.gallery, isForAaadhar);
                      }),
                  ListTile(
                    title: Text('Capture from camera'),
                    onTap: () {
                      _loadPicker(ImageSource.camera, isForAaadhar);
                    },
                  ),
                ],
              ),
            ));
  }

  void SaveImage(path, bool isForAaadhar) async {
    SharedPreferences saveimage = await SharedPreferences.getInstance();
    if (isForAaadhar) {
      saveimage.setString("aadharimagepath", path);
    } else {
      saveimage.setString("vehicleimagepath", path);
    }
  }

  void LoadImage(bool isForAadhar) async {
    SharedPreferences saveimage = await SharedPreferences.getInstance();
    setState(() {
      if (isForAadhar) {
        _aadharImagepath = saveimage.getString("aadharimagepath");
      } else {
        _vehicleImagepath = saveimage.getString("vehicleimagepath");
      }
    });
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
  //                 'This app needs access to Storage in order to upload an image as profile picture',
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
                  'This app needs access to Photos in order to upload an image as profile picture',
                  style: TextStyle(fontFamily: popinsRegFont),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoButton(
              // focusColor: Colors.transparent,
              // highlightColor: Colors.transparent,
              // hoverColor: Colors.transparent,
              // splashColor: Colors.transparent,
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
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

  checkAllDetails() {
    if (objDoc != null) {
      if (objDoc.adharcardFile != null &&
          objDoc.vehicleDocument != null &&
          objDoc.adharcardNumber != "" &&
          objDoc.vehicleNumber != "") {
        setState(() {
          canSave = false;
          showCustomToast("You have already uploaded your documents", context);
        });
        return;
      }
    }
    if (txtAadharController.text.trim() == "") {
      setState(() {
        isAadharNoValidation = true;
        isAadharNoEmpty = true;
        canSave = false;
      });
      return;
    } else if (!isAadharNumber(txtAadharController.text)) {
      setState(() {
        isAadharNoValidation = true;
        isAadharNoInvalid = true;
        canSave = false;
      });
      return;
    }
    if (_pickedAadharImage == null) {
      setState(() {
        canSave = false;
        showCustomToast("Please upload your aadhaar card", context);
      });
      return;
    }
    if (txtVehicleController.text.trim() == "") {
      setState(() {
        isVehicleNoValidation = true;
        isVehicleNoEmpty = true;
        canSave = false;
      });
      return;
    } else if (!isVehicleNumber(txtVehicleController.text)) {
      setState(() {
        isVehicleNoValidation = true;
        isVehicleNoInvalid = true;
        canSave = false;
      });
      return;
    }
    if (_pickedVehicleImage == null) {
      setState(() {
        canSave = false;
        showCustomToast("Please upload your RC book", context);
      });
      return;
    }

    canSave = true;
  }
}
