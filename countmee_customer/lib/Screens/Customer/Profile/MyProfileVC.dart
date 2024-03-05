import 'dart:convert';
import 'dart:io';

import 'package:countmee/Model/UserModel.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
Title : MyProfileVC Screen
Purpose: MyProfileVC Screen
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class MyProfileVC extends StatefulWidget {
  @override
  _MyProfileVCState createState() => _MyProfileVCState();
}

class _MyProfileVCState extends State<MyProfileVC> {
  final txtFirstNameController = TextEditingController();
  final txtLastNameController = TextEditingController();
  final txtEmailIDController = TextEditingController();
  final txtMobileNumberController = TextEditingController();
  final txtCountryCodeController = TextEditingController();

  var isProfileEditing = false;
  var isEmailEmpty = false;
  var isFNameEmpty = false;
  var isLNameEmpty = false;
  var isPhoneEmpty = false;
  var isEmailValidation = false;
  var isLoading = false;
  var isPhoneValidation = false;

  var isPhoneInvalid = false;
  var images = [];
  File _pickedImage;
  String _imagepath;
  String _error;
  var isImageLoading = false;

  @override
  void initState() {
    super.initState();
    txtFirstNameController.text = userObj.firstName;
    txtLastNameController.text = userObj.lastName;
    txtEmailIDController.text = userObj.email;
    txtMobileNumberController.text = userObj.phoneNumber;
    txtCountryCodeController.text = userObj.phoneCode;
    getuserData().then((value) {
      setState(() {});
    });
  }

  Future<UserModel> _getuserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      UserModel user =
          UserModel.fromJson(json.decode(prefs.getString('user') ?? ''));
      userObj = user;
      return userObj;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: setCustomFont(isProfileEditing ? "Edit Profile" : "Profile", 20,
            textBlackColor, FontWeight.w700, 1),
        leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
          Navigator.pop(context);
        }, Colors.transparent, Colors.transparent, 0),
        actions: [
          isProfileEditing
              ? Container()
              : Container(
                  width: 55,
                  height: 45,
                  child: setbuttonWithChild(
                      setImageName("iconEditProfile.png", 20, 20), () {
                    setState(() {
                      isProfileEditing = !isProfileEditing;
                    });
                  }, Colors.transparent, Colors.transparent, 0),
                )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: 700,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: isProfileEditing
                        ? () => {_showPickOptionDialog(context)}
                        : null,
                    child: Container(
                      height: 110,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: _pickedImage != null
                                ? ClipOval(
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      child: Image.file(_pickedImage),
                                    ),
                                  )
                                : ClipOval(
                                    child: userObj.image != null
                                        ? setProfileImage(
                                            userObj.image,
                                          )
                                        : setImageName(
                                            "userPlaceholder.png", 100, 100),
                                  ),
                            height: 102,
                            width: 102,
                            decoration: BoxDecoration(
                                border: Border.all(color: appColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(52)),
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                boxShadow: [getdefaultShadow()]),
                          ),
                          isProfileEditing
                              ? Container(
                                  alignment: Alignment.center,
                                  height: 102,
                                  width: 102,
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Row(
                                        children: [
                                          Spacer(),
                                          Container(
                                            child: ClipOval(
                                              child: Icon(Icons.camera_alt,
                                                  size: 15),
                                            ),
                                            height: 26,
                                            width: 26,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: appColor, width: 2),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(52)),
                                                color: Colors.white,
                                                shape: BoxShape.rectangle,
                                                boxShadow: [
                                                  getdefaultShadow()
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 370,
                    child: Stack(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
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
                                          })),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: setTextField(
                                      txtEmailIDController,
                                      "Email",
                                      false,
                                      TextInputType.emailAddress,
                                      isEmailValidation,
                                      isEmailEmpty
                                          ? msgEmptyEmail
                                          : msgInvalidEmail,
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 25,
                                    ),
                                    SizedBox(
                                      width: 50,
                                      height: 57,
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
                                                controller:
                                                    txtCountryCodeController,
                                                onChanged: (value) => {},
                                                decoration: InputDecoration(
                                                  errorMaxLines: 3,
                                                  errorText: null,
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          8, 30, 0, 10),
                                                  enabledBorder:
                                                      const OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Color.fromRGBO(
                                                                    244,
                                                                    247,
                                                                    250,
                                                                    1),
                                                            width: 1),
                                                  ),
                                                  border:
                                                      new OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          borderSide:
                                                              new BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          244,
                                                                          247,
                                                                          250,
                                                                          1))),
                                                  filled: false,
                                                  fillColor: backgroundColor,
                                                  hintText: "+91",
                                                  hintStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          164, 165, 169, 1),
                                                      fontFamily: popinsRegFont,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  focusedBorder:
                                                      OutlineInputBorder(
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
                                    Flexible(
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(25, 0, 25, 0),
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
                            ],
                          ),
                        ),
                        isProfileEditing
                            ? Container()
                            : InkWell(
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {},
                              )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    height: 57,
                    width: double.infinity,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 57,
                      child: isProfileEditing
                          ? setbuttonWithChild(
                              isLoading
                                  ? Container(
                                      width: 30,
                                      height: 30,
                                      child:
                                          setButtonIndicator(3, Colors.white),
                                    )
                                  : setCustomFont("Save", 16, Colors.white,
                                      FontWeight.w400, 1.2),
                              () {
                                if (isProfileEditing) {
                                  updateProfile();
                                }
                                //  else {
                                //   pushToViewController(
                                //     context,
                                //     ChangePasswordVC(
                                //       isFromRegister: false,
                                //       isFromProfile: true,
                                //     ),
                                //     () {},
                                //   );
                                // }
                              },
                              appColor,
                              Colors.purple[900],
                              5,
                            )
                          : Container(),
                    ),
                  )
                ],
              ),
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
    );
  }

  updateProfile() async {
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

    // if (txtMobileNumberController.text.trim() == "") {
    //   setState(() {
    //     isPhoneValidation = true;
    //     isPhoneEmpty = true;
    //     isPhoneInvalid = false;
    //   });
    //   setState(() {
    //     isPhoneEmpty = true;
    //   });
    //   return;
    // }
    // if (txtMobileNumberController.text.trim().length < 10) {
    //   setState(() {
    //     isPhoneValidation = true;
    //     isPhoneEmpty = false;
    //     isPhoneInvalid = true;
    //   });
    //   return;
    // }
    setState(() {
      isLoading = true;
    });
    var path = _pickedImage != null ? _pickedImage.path : "";
    FormData formData;

    if (path.length > 0) {
      formData = FormData.fromMap({
        "first_name": txtFirstNameController.text.trim(),
        "last_name": txtLastNameController.text.trim(),
        "email": txtEmailIDController.text.trim(),
        "image": await MultipartFile.fromFile(
          path,
          filename: "${userObj.name}ProfilePic.png",
        ),
      });
    } else {
      formData = FormData.fromMap({
        "first_name": txtFirstNameController.text.trim(),
        "last_name": txtLastNameController.text.trim(),
        "email": txtEmailIDController.text.trim(),
      });
    }
    postDataRequestWithToken(updateProfileAPI, formData, context).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value is Map) {
        AlertMessage(
          "Your profile has been updated successfully.",
          context,
          () {
            FocusScope.of(context).requestFocus(new FocusNode());

            setState(() {
              isProfileEditing = false;
            });
            Navigator.pop(context, false);
            //  Navigator.of(context, rootNavigator: false).pop("Discard");

            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => MyProfileVC(),
            //       fullscreenDialog: false,
            //     ));

            // Navigator.of(context).pop(false);
            // Navigator.of(context).pop(false);
          },
        );
        _getUserProfile();
        afterDelay(1, () {
          setState(() {
            isProfileEditing = false;
          });
        });
      } else {
        showCustomToast(value.toString(), context);
      }
    });
  }

  void _getUserProfile() {
    postDataRequestWithToken(getUserProfileAPI, null, context).then((value) {
      if (value is Map) {
        var token = userObj.token;
        UserModel user = UserModel.fromJson(value[kData]);
        userObj = user;
        userObj.token = token;
        setUserData();
        getuserData();
      } else {
        showCustomToast(value.toString(), context);
      }
    });
  }

  void _showPickOptionDialog(BuildContext context) {
    //_showStoragePermissionDialog;
    //if (Permission.storage.isGranted == true) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        title: Text('Select from gallery'),
                        onTap: () {
                          _loadPicker(ImageSource.gallery);
                        }),
                    ListTile(
                      title: Text('Capture from camera'),
                      onTap: () {
                        _loadPicker(ImageSource.camera);
                      },
                    ),
                  ],
                ),
              ));
    //}
  }

  _loadPicker(ImageSource source) async {
    Navigator.pop(context);

    setState(() {
      isImageLoading = true;
    });

    PickedFile picked = await ImagePicker().getImage(source: source);
    if (picked != null) {
      _cropImage(picked).then((File cropped) {
        SaveImage(cropped.path);
      });
    } else {
      setState(() {
        isImageLoading = false;
      });
    }

    LoadImage();
  }

  Future<File> _cropImage(PickedFile picked) async {
    File cropped = (await ImageCropper().cropImage(
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
        _pickedImage = cropped;
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

  void LoadImage() async {
    SharedPreferences saveimage = await SharedPreferences.getInstance();
    setState(() {
      _imagepath = saveimage.getString("imagepath");
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
}
