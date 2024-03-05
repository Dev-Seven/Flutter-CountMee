import 'dart:convert';

import 'package:countmee/Model/OrderResponseModel.dart';
import 'package:countmee/Model/PackageAPIDetail.dart';
import 'package:countmee/Model/TransportModeModel.dart';
import 'package:countmee/Model/UserAPIDetails.dart';
import 'package:countmee/Screens/Customer/Package/AddProductVC.dart';
import 'package:countmee/Screens/Customer/Package/CheckoutVC.dart';
import 'package:countmee/Screens/Customer/Package/ReceiverDetailsVC.dart';
import 'package:countmee/Screens/Customer/Package/SenderDetailVC.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_place/google_place.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:math' show cos, sqrt, asin;

class SendPackage extends StatefulWidget {
  final UserAPIDetails senderData;
  String nameTxt;
  String addressTxt;
  String addressAsTxt;
  String receiverNameTxt;
  String receiverAddressName;
  String addresstypeTxt;

  SendPackage({
    this.senderData,
  });

  @override
  _SendPackageState createState() => _SendPackageState();
}

class _SendPackageState extends State<SendPackage> {
  var txtModeOfTransportController = TextEditingController();
  final txtShipmentChargesController = TextEditingController();
  var isShipmentEmpty = false;
  var isLoading = false;
  List<TransportModeModel> modeOfTransport = [];
  var pickupLocation = "";
  var dropLocation = "";
  var pickupLatlng = Location();
  var dropLatlng = Location();
  var kInitialPosition = LatLng(-33.8567844, 151.213108);
  var selectedTransportMode;
  var courierCharge = "50";
  var dropLat, dropLng, pickupLat, pickupLng;
  PackageAPIDetail objPackageDetail = PackageAPIDetail();
  UserAPIDetails senderData = UserAPIDetails();
  UserAPIDetails reciverData = UserAPIDetails();
  List<String> arrImages;
  bool isTransportMode = false;
  dynamic images;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String transportName = "";
  String transportImage = "";
  var amount;
  bool isCalculateLoading = false;
  double km = 0;

  var name, mobile, address, dropAddress;

  @override
  void initState() {
    super.initState();
    setState(() {
      checkConnection(context);
      getTransportMode();
      clearUserData(senderData);
      clearUserData(reciverData);
    });
  }

  getTotalAmount() {
    setState(() {
      isCalculateLoading = true;
    });
    var courierBag;
    if (objPackageDetail.courierBag == null) {
      courierBag = 1;
    } else {
      courierBag = objPackageDetail.courierBag;
    }

    FormData formData = FormData.fromMap({
      "mode_of_transport": selectedTransportMode,
      "total_distance": km,
      "is_courier_bag": courierBag,
    });
    postDataRequestWithToken(packageAmountApi, formData, context).then((value) {
      setState(() {
        isCalculateLoading = false;
      });
      if (value[kStatusCode] == 200) {
        if (value is Map) {
          setState(() {
            amount = value[kData];
          });

          print(amount);
        } else {
          showCustomToast(value[kMessage], context);
        }
      } else if (value[kStatusCode] == 500) {
          showCustomToast(
              'Something went wrong.\nplease check after sometime.', context);
        }else {
        showCustomToast(value.toString(), context);
      }
    });
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  getTransportMode() {
    setState(() {
      isTransportMode = true;
    });

    postDataRequestWithToken(getTransportModeAPI, null, context).then((value) {
      if (value is Map) {
        if (value[kStatusCode] as int == 200) {
          _handleDataResponse(value[kData]);
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

  _handleDataResponse(value) {
    var arrData = value
        .map<TransportModeModel>((json) => TransportModeModel.fromJson(json))
        .toList();

    modeOfTransport.clear();
    setState(() {
      modeOfTransport = arrData;
      isTransportMode = false;
      if (modeOfTransport != null) {
        selectedTransportMode = modeOfTransport[0].transportId;
        transportImage = modeOfTransport[0].image;
        transportName = modeOfTransport[0].name;
      }
    });
  }

  void getLocationPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    name = userObj.name;
    mobile = userObj.phoneNumber;

    if (isConnected == true) {
      setState(() {
        getTransportMode();
        isConnected = false;
      });
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: setCustomFont(
              "Send Package", 20, textBlackColor, FontWeight.w700, 1),
          leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
            Navigator.pop(context);
          }, Colors.transparent, Colors.transparent, 0),
        ),
        body: Container(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 155,
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        color: appColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 3,
                                        height: 3,
                                        color: Color.fromRGBO(239, 239, 239, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 3,
                                        height: 3,
                                        color: Color.fromRGBO(239, 239, 239, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 3,
                                        height: 3,
                                        color: Color.fromRGBO(239, 239, 239, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 3,
                                        height: 3,
                                        color: Color.fromRGBO(239, 239, 239, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 3,
                                        height: 3,
                                        color: Color.fromRGBO(239, 239, 239, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 3,
                                        height: 3,
                                        color: Color.fromRGBO(239, 239, 239, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 3,
                                        height: 3,
                                        color: Color.fromRGBO(239, 239, 239, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 3,
                                        height: 3,
                                        color: Color.fromRGBO(239, 239, 239, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 3,
                                        height: 3,
                                        color: Color.fromRGBO(239, 239, 239, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        color: appColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          if (pickupLatlng.lat == null) {
                                            _locationUpdateEvent(true,
                                                tempInitialPosition: LatLng(
                                                    kInitialPosition.latitude,
                                                    kInitialPosition
                                                        .longitude));
                                          } else {
                                            _locationUpdateEvent(true,
                                                tempInitialPosition: LatLng(
                                                    pickupLatlng.lat,
                                                    pickupLatlng.lng));
                                          }
                                        },
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 8),
                                              setCustomFont(
                                                  "Pickup Location",
                                                  11,
                                                  Color.fromRGBO(
                                                      287, 287, 287, 1),
                                                  FontWeight.w300,
                                                  1),
                                              SizedBox(
                                                height: 9,
                                              ),
                                              setCustomFontWithAlignment(
                                                  pickupLocation == null
                                                      ? "Select Pickup Location"
                                                      : pickupLocation.length >
                                                              2
                                                          ? address =
                                                              pickupLocation
                                                          : "Select Pickup Location",
                                                  16,
                                                  Color.fromRGBO(
                                                      287, 287, 287, 1),
                                                  FontWeight.w500,
                                                  1,
                                                  TextAlign.left),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        height: 1,
                                        child: Divider(
                                          height: 1,
                                          color:
                                              Color.fromRGBO(246, 246, 246, 1),
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          if (dropLatlng.lat == null) {
                                            _locationUpdateEvent(false,
                                                tempInitialPosition: LatLng(
                                                    kInitialPosition.latitude,
                                                    kInitialPosition
                                                        .longitude));
                                          } else {
                                            _locationUpdateEvent(false,
                                                tempInitialPosition: LatLng(
                                                    dropLatlng.lat,
                                                    dropLatlng.lng));
                                          }
                                        },
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              setCustomFont(
                                                  "Drop off Location",
                                                  11,
                                                  Color.fromRGBO(
                                                      287, 287, 287, 1),
                                                  FontWeight.w300,
                                                  1),
                                              SizedBox(
                                                height: 9,
                                              ),
                                              setCustomFontWithAlignment(
                                                  dropLocation == null
                                                      ? "Drop off Location"
                                                      : dropLocation.length > 2
                                                          ? dropAddress =
                                                              dropLocation
                                                          : "Select Drop off Location",
                                                  16,
                                                  Color.fromRGBO(
                                                      287, 287, 287, 1),
                                                  FontWeight.w500,
                                                  1,
                                                  TextAlign.left),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          dropAddress != null && address != null
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Approx. distance is",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.normal,
                                                  color: textBlackColor,
                                                  height: 1),
                                            ),
                                            km <= 0
                                                ? Text(
                                                    " 0 km",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: appColor,
                                                        height: 1),
                                                  )
                                                : Text(
                                                    " $km km",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: appColor,
                                                        height: 1),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 18),
                                      Row(
                                        children: [
                                          Text(
                                            "Total  payable amount is",
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              color: textBlackColor,
                                              height: 1,
                                            ),
                                          ),
                                          Text(
                                            " ₹$amount",
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.normal,
                                              color: appColor,
                                              height: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 18),
                                    ],
                                  ),
                                )
                              : SizedBox(),
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
                  isTransportMode
                      ? Center(
                          child: Text("Transport mode loading.."),
                        )
                      : Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Container(
                            height: 118,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                boxShadow: [getShadow(0, 0, 15)]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                    child: setCustomFont(
                                      "Mode of Transport",
                                      16,
                                      textBlackColor,
                                      FontWeight.w600,
                                      1,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(11, 0, 11, 0),
                                  child: Container(
                                    height: 57,
                                    width: double.infinity,
                                    child: InkWell(
                                      focusColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        showModeOfTransportPopup();
                                      },
                                      child: Container(
                                        height: 80,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    244, 247, 250, 1))),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              child: setTransportImage(
                                                transportImage,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Text(
                                                transportName,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.black,
                                                    height: 1.2),
                                              ),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              setCustomFont(
                                "Add Product",
                                //"Package Details",
                                16,
                                textBlackColor,
                                FontWeight.w600,
                                1,
                              )
                            ],
                          ),
                          objPackageDetail.productDesc != null
                              ? Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 15, 10),
                                  width: double.infinity,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 14,
                                        ),
                                        Container(
                                          height: 75,
                                          child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            padding:
                                                EdgeInsets.fromLTRB(0, 5, 0, 0),
                                            shrinkWrap: false,
                                            itemCount: 1,
                                            itemBuilder: (context, position) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  setCustomFont(
                                                      objPackageDetail
                                                                  .productDesc ==
                                                              'Others'
                                                          ? objPackageDetail
                                                              .otherProductDesc
                                                          : objPackageDetail
                                                              .productDesc,
                                                      16,
                                                      textBlackColor,
                                                      FontWeight.w500,
                                                      1),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  setCustomFont(
                                                      objPackageDetail.weight,
                                                      14,
                                                      textBlackColor,
                                                      FontWeight.w400,
                                                      1),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  setCustomFont(
                                                      objPackageDetail
                                                          .handleProduct,
                                                      14,
                                                      textBlackColor,
                                                      FontWeight.w400,
                                                      1),
                                                  SizedBox(
                                                    height: 14,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          focusColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddProductVC(
                                                        true,
                                                        packageDetail:
                                                            getPackageDetail,
                                                        objPackage:
                                                            objPackageDetail,
                                                        arrImages:
                                                            images['arrImages'],
                                                      ),
                                                  fullscreenDialog: false),
                                            ).then((value) {
                                              if (value != null) {
                                                images = value;
                                                getTotalAmount();
                                              }
                                            });
                                          },
                                          child: Container(
                                            child: setCustomFont(
                                                "Edit Product",
                                                14,
                                                appColor,
                                                FontWeight.w400,
                                                1),
                                          ),
                                        ),
                                      ]))
                              : Container(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        child: setImageName(
                                            "iconNoProduct.png", 74, 74),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        child: setCustomFont(
                                            "No any products.",
                                            14,
                                            Color.fromRGBO(198, 198, 198, 1),
                                            FontWeight.w400,
                                            1),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        focusColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddProductVC(
                                                      false,
                                                      packageDetail:
                                                          getPackageDetail,
                                                      objPackage:
                                                          objPackageDetail,
                                                    ),
                                                fullscreenDialog: false),
                                          ).then((value) {
                                            images = value;
                                            getTotalAmount();
                                          });
                                        },
                                        child: Container(
                                          child: setCustomFont(
                                            "Package Details",
                                            14,
                                            appColor,
                                            FontWeight.w400,
                                            1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                        ],
                      ),
                      height: objPackageDetail.productDesc != null ? 170 : 200,
                      width: double.infinity,
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
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              setCustomFont("Sender Details", 16,
                                  textBlackColor, FontWeight.w600, 1)
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          pickupLocation != ""
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: setCustomFontWithAlignment(
                                          widget.nameTxt = senderData.name != ""
                                              ? senderData.name
                                              : name,
                                          14,
                                          textBlackColor,
                                          FontWeight.w700,
                                          1,
                                          TextAlign.left),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: setCustomFontWithAlignment(
                                        widget.addressTxt =
                                            senderData.address != ""
                                                ? senderData.address
                                                : address,
                                        14,
                                        textBlackColor,
                                        FontWeight.w400,
                                        1,
                                        TextAlign.left,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      focusColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          var url =
                                              "https://www.google.com/maps/search/?api=1&query=$pickupLat,$pickupLng";
                                          pushToViewController(
                                              context,
                                              SenderDetailVC(
                                                objUser: senderData,
                                                updateUserDetail:
                                                    getSenderDetail,
                                                url: pickupLat == null
                                                    ? ""
                                                    : url,
                                                address: address,
                                                isEdit: true,
                                              ),
                                              () {});
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        width: double.infinity,
                                        child: setCustomFont(
                                            "Edit Sender Details",
                                            14,
                                            appColor,
                                            FontWeight.w400,
                                            1),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          color: appColor.withAlpha(80),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                )
                              : InkWell(
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      var url =
                                          "https://www.google.com/maps/search/?api=1&query=$pickupLat,$pickupLng";
                                      pushToViewController(
                                          context,
                                          SenderDetailVC(
                                            objUser: senderData,
                                            isEdit: false,
                                            updateUserDetail: getSenderDetail,
                                            url: pickupLat == null ? "" : url,
                                            address: address,
                                          ),
                                          () {});
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: double.infinity,
                                    child: setCustomFont("Add Sender Details",
                                        14, appColor, FontWeight.w400, 1),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: appColor.withAlpha(80),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      width: double.infinity,
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
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              setCustomFont("Receiver Details", 16,
                                  textBlackColor, FontWeight.w600, 1)
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          reciverData.name != ""
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: setCustomFontWithAlignment(
                                          widget.receiverNameTxt =
                                              reciverData.name != null
                                                  ? reciverData.name
                                                  : "",
                                          14,
                                          textBlackColor,
                                          FontWeight.w700,
                                          1,
                                          TextAlign.left),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: setCustomFontWithAlignment(
                                        widget.receiverAddressName =
                                            reciverData.address != ""
                                                ? reciverData.address
                                                : "",
                                        14,
                                        textBlackColor,
                                        FontWeight.w400,
                                        1,
                                        TextAlign.left,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      focusColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          var url =
                                              "https://www.google.com/maps/search/?api=1&query=$dropLat,$dropLng";
                                          pushToViewController(
                                            context,
                                            ReceiverDetailsVC(
                                              objUser: reciverData,
                                              updateUserDetail:
                                                  getReciverDetail,
                                              url: dropLat == null ? "" : url,
                                              dropAddress: dropAddress,
                                              isEdit: true,
                                            ),
                                            () {},
                                          );
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        width: double.infinity,
                                        child: setCustomFont(
                                          "Edit Receiver Details",
                                          14,
                                          appColor,
                                          FontWeight.w400,
                                          1,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          color: appColor.withAlpha(80),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                )
                              : InkWell(
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      var url =
                                          "https://www.google.com/maps/search/?api=1&query=$dropLat,$dropLng";
                                      pushToViewController(
                                          context,
                                          ReceiverDetailsVC(
                                            objUser: reciverData,
                                            updateUserDetail: getReciverDetail,
                                            url: dropLat == null ? "" : url,
                                            dropAddress: dropAddress,
                                            isEdit: false,
                                          ),
                                          () {});
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: double.infinity,
                                    child: setCustomFont("Add Receiver Details",
                                        14, appColor, FontWeight.w400, 1),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: appColor.withAlpha(80),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      width: double.infinity,
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
                                child: setButtonIndicator(3, Colors.white),
                              )
                            : setCustomFont(
                                "Pick Up",
                                16,
                                Colors.white,
                                FontWeight.w400,
                                1.2,
                              ),
                        () {
                          createPackage();
                        },
                        appColor,
                        Colors.purple[900],
                        5,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  getPackageDetail(PackageAPIDetail obj, List<String> _arrImages) {
    arrImages = _arrImages;
    setState(() {
      objPackageDetail = PackageAPIDetail();
      objPackageDetail = obj;
    });
  }

  getSenderDetail(UserAPIDetails userObj) {
    setState(() {
      senderData = userObj;
    });

    print("SENDER DATA :$senderData");

    if (senderData.mobileNumber1 != null) {
      senderData.mobileNumber1 = userObj.mobileNumber1;
      senderData.name = userObj.name;
      senderData.address = userObj.address;
      senderData.googleMapLink = userObj.googleMapLink;
      print("${senderData.mobileNumber1}");
    } else {
      print("Mobile is Empty");
    }
  }

  getReciverDetail(UserAPIDetails userObj) {
    setState(() {
      reciverData = userObj;
    });

    print("RECEIVER DATA :$reciverData");
  }

  clearUserData(UserAPIDetails objUser) {
    objUser.deliveryContact = "";
    objUser.name = "";
    objUser.address = "";
    objUser.latitude = "";
    objUser.longitude = "";
    objUser.mobileNumber1 = "";
    objUser.mobileNumber2 = "";
    objUser.googleMapLink = "";
  }

  createPackage() async {
    if (senderData.mobileNumber1 == "") {
      senderData.mobileNumber1 = mobile;
    }
    if (senderData.name == "") {
      senderData.name = name;
    }

    if (pickupLocation.length < 2) {
      showCustomToast("Please select pickup location", context);
      return;
    }
    if (dropLocation.length < 2) {
      showCustomToast("Please select drop off location", context);
      return;
    }
    if (objPackageDetail.productDesc == null) {
      showCustomToast("Please add package details", context);
      return;
    }
    if (widget.receiverNameTxt == null ||
        widget.receiverNameTxt.isEmpty ||
        widget.receiverAddressName.isEmpty) {
      showCustomToast("Please add receiver details", context);
      return;
    }

    if (selectedTransportMode == null) {
      showCustomToast("Please select mode of transport", context);
      return;
    }

    var receiverName = widget.receiverNameTxt;
    var receiverMobile = reciverData.mobileNumber1;

    print("RECEIVER MOBILE :$receiverMobile");
    print("DISTANCE IN KILOMETER:$km.toRound");
    print("SENDER DATA : $senderData");
    print("RECEIVER DATA : $reciverData");
    print(objPackageDetail);
    List packageList = [];
    packageList.clear();
    packageList.add(objPackageDetail);

    Map<String, dynamic> requestParam = {
      "package_detail": jsonEncode(packageList),
      "pickup_latitude": pickupLatlng.lat,
      "pickup_longitude": pickupLatlng.lng,
      "drop_latitude": dropLatlng.lat,
      "drop_longitude": dropLatlng.lng,
      "pickup_address": pickupLocation,
      "drop_address": dropLocation,
      "mode_of_transport": selectedTransportMode,
      "receiver_detail": jsonEncode(reciverData),
      "sender_detail": jsonEncode(senderData),
      "total_distance": km.toString(),
    };

    List packageImage = [];
    for (var item in images['arrImages']) {
      if (item != "") {
        packageImage.add(item);
      }
    }

    for (int i = 0; i < packageImage.length; i++) {
      String paramName = "side${i + 1}";
      if (i == 4) {
        paramName = "top";
      } else if (i == 5) {
        paramName = "bottom";
      } else {
        paramName = "side${i + 1}";
      }

      requestParam.addAll({
        paramName: await MultipartFile.fromFile(
          packageImage[i],
          filename: packageImage[i].split("/").last,
        ),
      });
    }

    FormData formData = FormData.fromMap(
      requestParam,
    );

    setState(() {
      isLoading = true;
    });

    print("$formData");

    postDataRequestWithToken(createOrderAPI, formData, context).then((value) {
      print(formData.fields);
      setState(() {
        isLoading = false;
      });
      print(value);
      if (value["status_code"] == 200) {
        OrderResponseModel tempOrderResponseModel =
            new OrderResponseModel.fromJson(value);
        if (tempOrderResponseModel != null) {
          pushToViewController(
            context,
            CheckoutVC(
              receiver_name: reciverData.name,
              receiver_mobile: reciverData.mobileNumber1,
              package_detail: jsonEncode(packageList),
              mode_of_transport: transportName,
              transportImage: transportImage,
              data: tempOrderResponseModel,
            ),
            () {
              print("Else Data");
            },
          );
        }
      }else if (value[kStatusCode] == 500) {
          showCustomToast(
              'Something went wrong.\nplease check after sometime.', context);
        }else {
        showCustomToast(value[kMessage], context);
      }
    });
  }

  _locationUpdateEvent(bool isPickup, {LatLng tempInitialPosition}) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();

    var status = await Permission.photos.request();
    if (status == PermissionStatus.granted) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) {
                return Theme(
                  data: ThemeData(
                    primaryColor: appColor,
                    buttonTheme: ButtonThemeData(
                      buttonColor: appColor,
                      textTheme: ButtonTextTheme.primary,
                    ),
                  ),
                  child: PlacePicker(
                    apiKey: googleAPIKey,
                    initialPosition: tempInitialPosition,
                    selectInitialPosition: true,
                    useCurrentLocation: true,
                    desiredLocationAccuracy: LocationAccuracy.high,
                    onPlacePicked: (results) {
                      setState(() {
                        if (isPickup) {
                          pickupLocation = results.formattedAddress;
                          senderData.address = pickupLocation;
                          pickupLatlng = Location(
                              lat: results.geometry.location.lat,
                              lng: results.geometry.location.lng);
                        } else {
                          dropLocation = results.formattedAddress;
                          reciverData.address = dropLocation;
                          dropLatlng = Location(
                              lat: results.geometry.location.lat,
                              lng: results.geometry.location.lng);
                        }
                        distance();
                      });
                      Navigator.pop(context);
                    },
                  ),
                );
              },
              fullscreenDialog: false));
      if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
        await Geolocator.getCurrentPosition().then((value) => {});
      }
    } else if (status == PermissionStatus.permanentlyDenied) {}
  }

  distance() async {
    if (pickupLocation != null && dropLocation != null) {
      pickupLat = pickupLatlng.lat;
      pickupLng = pickupLatlng.lng;
      dropLat = dropLatlng.lat;
      dropLng = dropLatlng.lng;

      polylineCoordinates.clear();

      PolylineResult result = await polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(pickupLat, pickupLng),
        PointLatLng(dropLat, dropLng),
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print(result.errorMessage);
      }

      double _coordinateDistance(pickupLat, pickupLng, dropLat, dropLng) {
        var p = 0.017453292519943295;
        var c = cos;
        var a = 0.5 -
            c((dropLat - pickupLat) * p) / 2 +
            c(pickupLat * p) *
                c(dropLat * p) *
                (1 - c((dropLng - pickupLng) * p)) /
                2;

        return 12742 * asin(sqrt(a));
      }

      double totalDistance = 0.0;

      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      print("DISTANCE : $totalDistance");

      setState(() {
        km = double.parse((totalDistance).toStringAsFixed(2));
      });

      print(km);
      getTotalAmount();
    }
  }

  showModeOfTransportPopup() {
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
                itemCount: modeOfTransport.length,
                itemBuilder: (context, position) {
                  return InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      selectedTransportMode =
                          modeOfTransport[position].transportId;
                      transportName = modeOfTransport[position].name;
                      transportImage = modeOfTransport[position].image;
                      getTotalAmount();
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
                                setTransportImage(
                                  modeOfTransport[position].image,
                                ),
                                SizedBox(width: 8),
                                Container(
                                  child: setCustomFont(
                                      modeOfTransport[position].name,
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
}
