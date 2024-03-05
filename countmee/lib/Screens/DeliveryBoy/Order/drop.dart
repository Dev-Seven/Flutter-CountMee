import 'dart:convert';

import 'package:countmee/Model/PandingDataModel.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/AcceptedOrder.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/MapVC.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/OrderDeliveredVC.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart' as per;
import 'package:pin_code_text_field/pin_code_text_field.dart';
import '../TabBar/TabBarVC.dart';

/*
Title : AcceptedOrderVC
Purpose: AcceptedOrderVC
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class drop extends StatefulWidget {
  final PandingDataModel objOrder;

  const drop({
    Key key,
    this.objOrder,
  }) : super(key: key);

  @override
  _AcceptedOrderVCState createState() => _AcceptedOrderVCState();
}

class _AcceptedOrderVCState extends State<drop> {
  var switchValue = false;
  var microWave = false;
  var val = "PDC";
  String _currentAddress;
  bool ontap = false;
  var computer = false;
  var sofa = false;
  bool hasError = false;
  var controller = TextEditingController();
  var images = [];
  var txtStorageController = TextEditingController();
  String _error;
  var isLoading = false;
  var isResendOTP = false;
  var isButtonEnable = false;
  var strOTP = "";
  PandingDataModel orderDetail;
  bool isVerifyLoading = false;
  var orderId;
  var collectionId;
  var lat, long;
  String km;
  String dateFormat = "";
  String orderDate = "";
  bool isOTPSent = false;
  bool _isChecked = true;
  bool isStorage = true;
  List storageName = [];
  List storageAddress = [];
  LocationData _currentPosition;
  Location location = Location();
  List storageLatitude = [];
  List storageLongitude = [];
  List storageId = [];
  List storagenumber = [];
  List storage = [];
  int pos;
  var selectedStorage = "";
  String _comingSms = 'Unknown';

  int id;
  @override
  void initState() {
    super.initState();
    getStorageDetail();
    getOrderDetail();
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
    controller.dispose();
    super.dispose();
  }

  getStorageDetail() {
    setState(() {
      isLoading = true;
    });

    afterDelay(1, () {
      postDataRequestWithToken(collectionCentersApi, null, context)
          .then((value) {
        if (value[kData] is List) {
          setState(() {
            print("ok");

            for (var item in value['data']) {
              print(item);
              storageName.add(item['name']);
              storageAddress.add(item['address']);
              storageId.add(item['id']);
              storageLatitude.add(item['latitude']);
              storageLongitude.add(item['longitude']);
              storagenumber.add(item['phone_number']);
            }
            if (storageName.isEmpty) {
              isStorage = false;
            }
          });
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showCustomToast(value[kMessage], context);
        }
      });
    });
  }

  _onSubmitTap2() async {
    FocusScope.of(context).unfocus();

    if (strOTP == "") {
      showCustomToast("4 digit OTP is required", context);
      return;
    } else if (strOTP.length < 4) {
      showCustomToast("Please enter 4 digit OTP", context);
      return;
    }

    setState(() {
      isVerifyLoading = true;
    });

    FormData formData;

    formData = FormData.fromMap({
      "package_id": widget.objOrder.id,
      "otp": strOTP,
      "drop_address": widget.objOrder.updatedDropLocation,
      "drop_latitude": widget.objOrder.updatedDropLatitude,
      "drop_longitude": widget.objOrder.updatedDropLongitude,
    });
    print(formData);
    if (connectionStatus == DataConnectionStatus.connected) {
      postDataRequestWithToken(
              "deliveryboy/order/drop-package-accept", formData, context)
          .then((value) {
        setState(() {
          isVerifyLoading = false;
        });
        print(value);
        if (value is Map) {
          showGreenToast("Order Pick Up Successfully", context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => TabbarVC(),
            fullscreenDialog: false,
          ));

          // pushToViewController(
          //   context,
          //   OrderdeliveredVC(
          //     objOrder: widget.objOrder,
          //   ),
          //   () {},
          // );
        } else {
          setState(() {
            isVerifyLoading = false;
          });

          showCustomToast("Please enter valid Verification code", context);
        }

        // if (value == "Please enter valid Verification code") {
        //   showCustomToast(value[kMessage].toString(), context);
        // }
      });
    } else {
      setState(() {
        isVerifyLoading = false;
      });
      showCustomToast("Please check your internet connection", context);
    }
  }

  getOrderDetail() {
    setState(() {
      isLoading = true;
    });
    FormData formData = FormData.fromMap({
      "order_id": widget.objOrder.id,
    });
    postDataRequestWithToken(getOrderDetailAPI, formData, context)
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (value[kStatusCode] == 200) {
        if (value[kData] is Map) {
          setState(() {
            orderDetail = PandingDataModel.fromJson(value[kData]);
            print("ok");
            print(orderDetail);
            dateFormat = orderDetail.createdAt.split("T")[0];
            orderDate =
                DateFormat('dd-MM-yyyy').format(DateTime.parse(dateFormat));
          });
        } else {
          showCustomToast(value[kMessage], context);
        }
      } else {
        showCustomToast(value[kMessage], context);
      }
    });
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
      body: isLoading
          ? Center(child: setButtonIndicator(2, appColor))
          : SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: [
                            Spacer(),
                            setCustomFont(
                                orderDetail.id != null ? "Order No. :" : "",
                                16,
                                textBlackColor,
                                FontWeight.w600,
                                1),
                            setCustomFont(
                              orderDetail.id != null
                                  ? " " + orderDetail.orderNumber
                                  : "",
                              14,
                              textBlackColor,
                              FontWeight.w400,
                              1,
                            ),
                            Spacer(),
                            Container(
                              width: 1,
                              height: 30,
                              color: Color.fromRGBO(178, 178, 178, 1),
                            ),
                            Spacer(),
                            setCustomFont(
                              orderDate != null ? "Date :" : "",
                              16,
                              textBlackColor,
                              FontWeight.w600,
                              1,
                            ),
                            setCustomFont(
                              orderDate != null ? " $orderDate" : "",
                              14,
                              textBlackColor,
                              FontWeight.w400,
                              1,
                            ),
                            Spacer(),
                          ],
                        ),
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            boxShadow: [getShadow(0, 0, 15)]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            setCustomFont("Receiver Details", 16,
                                textBlackColor, FontWeight.w600, 1),
                            SizedBox(
                              height: 14,
                            ),
                            Divider(
                              height: 1,
                              color: Color.fromRGBO(226, 226, 226, 1),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            setCustomFont(
                                orderDetail.users[1].name != null
                                    ? orderDetail.users[1].name
                                    : "",
                                16,
                                textBlackColor,
                                FontWeight.w500,
                                1),
                            SizedBox(
                              height: 10,
                            ),
                            setCustomFont(
                                orderDetail.users[1].mobileNumber1 != null
                                    ? orderDetail.users[1].mobileNumber1
                                    : "",
                                14,
                                textBlackColor,
                                FontWeight.w400,
                                1),
                          ],
                        ),
                        height: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            boxShadow: [getShadow(0, 0, 15)]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(18, 10, 20, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                setCustomFont("Address Details", 16,
                                    textBlackColor, FontWeight.w600, 1),
                                InkWell(
                                    onTap: () {
                                      MapUtils.openMap(
                                          double.parse(widget
                                              .objOrder.updatedPickupLatitude),
                                          double.parse(widget
                                              .objOrder.updatedPickupLongitude),
                                          double.parse(widget
                                              .objOrder.updatedDropLatitude),
                                          double.parse(widget
                                              .objOrder.updatedDropLongitude));
                                      // pushToViewController(
                                      //     context,
                                      //     MapVC(
                                      //       pickupLocation: widget
                                      //           .objOrder.updatedPickupLocation,
                                      //       dropLocation: widget
                                      //           .objOrder.updatedDropLocation,
                                      //       pickupLat: widget
                                      //           .objOrder.updatedPickupLatitude,
                                      //       pickupLng: widget.objOrder
                                      //           .updatedPickupLongitude,
                                      //       dropLat: widget
                                      //           .objOrder.updatedDropLatitude,
                                      //       dropLng: widget
                                      //           .objOrder.updatedDropLongitude,
                                      //       mobileNo: widget.objOrder.users[1]
                                      //           .mobileNumber1,
                                      //     ),
                                      //     () {});
                                    },
                                    child: Image.asset("assets/images/map.png",
                                        height: 30, width: 30))
                              ],
                            ),
                            Divider(
                              height: 1,
                              color: Color.fromRGBO(226, 226, 226, 1),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Container(
                              height: 140,
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                                        height: 8,
                                      ),
                                      ClipOval(
                                        child: Container(
                                          width: 3,
                                          height: 3,
                                          color:
                                              Color.fromRGBO(239, 239, 239, 1),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      ClipOval(
                                        child: Container(
                                          width: 3,
                                          height: 3,
                                          color:
                                              Color.fromRGBO(239, 239, 239, 1),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      ClipOval(
                                        child: Container(
                                          width: 3,
                                          height: 3,
                                          color:
                                              Color.fromRGBO(239, 239, 239, 1),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      ClipOval(
                                        child: Container(
                                          width: 3,
                                          height: 3,
                                          color:
                                              Color.fromRGBO(239, 239, 239, 1),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      ClipOval(
                                        child: Container(
                                          width: 3,
                                          height: 3,
                                          color:
                                              Color.fromRGBO(239, 239, 239, 1),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      ClipOval(
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          color: appColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Spacer(),
                                        setCustomFont(
                                            "Pickup Location",
                                            11,
                                            Color.fromRGBO(287, 287, 287, 1),
                                            FontWeight.w300,
                                            1),
                                        SizedBox(
                                          height: 9,
                                        ),
                                        setCustomFontWithAlignment(
                                            orderDetail.updatedPickupLocation !=
                                                    null
                                                ? orderDetail
                                                    .updatedPickupLocation
                                                : "",
                                            15,
                                            Color.fromRGBO(287, 287, 287, 1),
                                            FontWeight.w500,
                                            1,
                                            TextAlign.left),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Container(
                                              height: 1,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.60,
                                              child: Divider(
                                                height: 1,
                                                color: Color.fromRGBO(
                                                    246, 246, 246, 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        setCustomFont(
                                            "Drop off Location",
                                            11,
                                            Color.fromRGBO(287, 287, 287, 1),
                                            FontWeight.w300,
                                            1),
                                        SizedBox(
                                          height: 9,
                                        ),
                                        setCustomFontWithAlignment(
                                            orderDetail.updatedDropLocation !=
                                                    null
                                                ? orderDetail
                                                    .updatedDropLocation
                                                : "",
                                            15,
                                            Color.fromRGBO(287, 287, 287, 1),
                                            FontWeight.w500,
                                            1,
                                            TextAlign.left),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            boxShadow: [getShadow(0, 0, 15)]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            setCustomFont("Delivery at:", 16, textBlackColor,
                                FontWeight.w600, 1),
                            SizedBox(
                              height: 14,
                            ),
                            Divider(
                              height: 1,
                              color: Color.fromRGBO(226, 226, 226, 1),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Radio(
                                    visualDensity: VisualDensity(
                                        horizontal:
                                            VisualDensity.minimumDensity),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    autofocus: true,
                                    value: "PDC",
                                    groupValue: val,
                                    onChanged: (value) {
                                      setState(() {
                                        val = value;
                                      });
                                    },
                                    activeColor: Colors.green,
                                  ),
                                  SizedBox(width: 10),
                                  setCustomFont("Pick & Drop Center (PDC)", 16,
                                      Colors.black, FontWeight.w400, 1),
                                ]),
                                SizedBox(
                                  height: 5,
                                ),
                                val == "PDC"
                                    ? isStorage == false
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15.0),
                                            child: setCustomFont(
                                                "Nearby Storage is not available",
                                                14,
                                                Colors.black,
                                                FontWeight.w400,
                                                1),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                11, 10, 11, 15),
                                            child: InkWell(
                                              onTap: () {
                                                print("om");
                                                setState(() {
                                                  ontap = !ontap;
                                                });
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: txtStorageController
                                                              .text.isEmpty
                                                          ? MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.65
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                      child: setCustomFontWithAlignment(
                                                          txtStorageController
                                                                  .text.isEmpty
                                                              ? "Please select Storage Location"
                                                              : txtStorageController
                                                                  .text,
                                                          16,
                                                          Colors.black,
                                                          FontWeight.normal,
                                                          1,
                                                          TextAlign.left),
                                                    ),
                                                    txtStorageController
                                                            .text.isEmpty
                                                        ? Icon(
                                                            Icons
                                                                .keyboard_arrow_down_rounded,
                                                            size: 25,
                                                          )
                                                        : Row(
                                                            children: [
                                                              setCustomFont(
                                                                  km +
                                                                      " " +
                                                                      "KM",
                                                                  16,
                                                                  textBlackColor,
                                                                  FontWeight
                                                                      .normal,
                                                                  1),
                                                              SizedBox(
                                                                  width: 5),
                                                              InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    print(lat);
                                                                    _currentPosition =
                                                                        await location
                                                                            .getLocation();
                                                                    List<geo.Placemark>
                                                                        placemarks =
                                                                        await geo.placemarkFromCoordinates(
                                                                            _currentPosition.latitude,
                                                                            _currentPosition.longitude);

                                                                    geo.Placemark
                                                                        place =
                                                                        placemarks[
                                                                            0];
                                                                    print(place
                                                                        .administrativeArea);
                                                                    setState(
                                                                        () {
                                                                      _currentAddress =
                                                                          "${place.street}, ${place.subLocality}, ${place.locality} ${place.postalCode}, ${place.administrativeArea},";
                                                                    });

                                                                    MapUtils.openMap(
                                                                        double.parse(_currentPosition
                                                                            .latitude
                                                                            .toString()),
                                                                        double.parse(_currentPosition
                                                                            .longitude
                                                                            .toString()),
                                                                        double.parse(storageLatitude[
                                                                            pos]),
                                                                        double.parse(
                                                                            storageLongitude[pos]));

                                                                    // pushToViewController(
                                                                    //     context,
                                                                    //     MapVC(
                                                                    //       pickupLocation:
                                                                    //           _currentAddress,
                                                                    //       dropLocation:
                                                                    //           storageAddress[pos],
                                                                    //       pickupLat: _currentPosition
                                                                    //           .latitude
                                                                    //           .toString(),
                                                                    //       pickupLng: _currentPosition
                                                                    //           .longitude
                                                                    //           .toString(),
                                                                    //       dropLat:
                                                                    //           storageLatitude[pos],
                                                                    //       dropLng:
                                                                    //           storageLongitude[pos],
                                                                    //       mobileNo: widget
                                                                    //           .objOrder
                                                                    //           .users[1]
                                                                    //           .mobileNumber1,
                                                                    //     ),
                                                                    //     () {});
                                                                  },
                                                                  child: Image.asset(
                                                                      "assets/images/map.png",
                                                                      height:
                                                                          30,
                                                                      width:
                                                                          30)),
                                                              SizedBox(
                                                                  width: 5),
                                                              Icon(
                                                                Icons
                                                                    .keyboard_arrow_down_rounded,
                                                                size: 25,
                                                              )
                                                            ],
                                                          )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                    : SizedBox(),
                                ontap == true && val == "PDC"
                                    ? Container(
                                        height: 200,
                                        child: ListView.builder(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 4, 0, 0),
                                            shrinkWrap: false,
                                            itemCount: storageName.length,
                                            itemBuilder: (context, position) {
                                              return InkWell(
                                                  focusColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    print(storageId);
                                                    setState(() {
                                                      pos = position;
                                                    });
                                                    _currentPosition =
                                                        await location
                                                            .getLocation();

                                                    setState(() {
                                                      pos = position;
                                                      var a = Geolocator.distanceBetween(
                                                              _currentPosition
                                                                  .latitude,
                                                              _currentPosition
                                                                  .longitude,
                                                              double.parse(
                                                                  storageLatitude[
                                                                      pos]),
                                                              double.parse(
                                                                  storageLongitude[
                                                                      pos])) /
                                                          1000;
                                                      print(a);
                                                      km = a.toStringAsFixed(2);
                                                      txtStorageController
                                                              .text =
                                                          storageName[position];
                                                      id = storageId[position];
                                                      selectedStorage =
                                                          storageAddress[
                                                              position];
                                                      lat = storageLatitude[
                                                          position];
                                                      long = storageLongitude[
                                                          position];
                                                      ontap = false;
                                                    });
                                                  },
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                                height: 12),
                                                            Container(
                                                              child: setCustomFont(
                                                                  storageName[
                                                                      position],
                                                                  16,
                                                                  pos == position
                                                                      ? appColor
                                                                      : textBlackColor,
                                                                  FontWeight
                                                                      .w600,
                                                                  1),
                                                            ),
                                                            SizedBox(height: 8),
                                                            pos == position
                                                                ? Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                              width: MediaQuery.of(context).size.width * .65,
                                                                              child: setCustomFontWithAlignment(storageAddress[position], 14, textBlackColor, FontWeight.w400, 1, TextAlign.left)),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              10),
                                                                    ],
                                                                  )
                                                                : Container(),
                                                            Container(
                                                              height: 1,
                                                              child: Divider(
                                                                height: 1,
                                                              ),
                                                            )
                                                          ])));
                                            }))
                                    : Container(),
                                SizedBox(
                                  height: 10,
                                ),
                                val == "PDC" &&
                                        txtStorageController.text.isNotEmpty
                                    ? Container(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              setCustomFont(
                                                  "Your selected PDC is:",
                                                  17,
                                                  textBlackColor,
                                                  FontWeight.w600,
                                                  1),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    setCustomFont(
                                                        "PDC Name: ",
                                                        16,
                                                        textBlackColor,
                                                        FontWeight.w600,
                                                        1),
                                                    SizedBox(height: 10),
                                                    setCustomFont(
                                                        txtStorageController
                                                            .text,
                                                        16,
                                                        textBlackColor,
                                                        FontWeight.w400,
                                                        1),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                              Container(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    setCustomFont(
                                                        "PDC Address: ",
                                                        16,
                                                        textBlackColor,
                                                        FontWeight.w600,
                                                        1),
                                                    SizedBox(height: 10),
                                                    setCustomFontWithAlignment(
                                                        storageAddress[pos],
                                                        16,
                                                        textBlackColor,
                                                        FontWeight.w400,
                                                        1,
                                                        TextAlign.justify),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                              Container(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    setCustomFont(
                                                        "PDC Mobile No.: ",
                                                        16,
                                                        textBlackColor,
                                                        FontWeight.w600,
                                                        1),
                                                    SizedBox(height: 10),
                                                    setCustomFont(
                                                        storagenumber[pos],
                                                        16,
                                                        textBlackColor,
                                                        FontWeight.w400,
                                                        1),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                                Row(children: [
                                  Radio(
                                    visualDensity: VisualDensity(
                                        horizontal:
                                            VisualDensity.minimumDensity),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: "DP",
                                    groupValue: val,
                                    onChanged: (value) {
                                      setState(() {
                                        val = value;
                                      });
                                    },
                                    activeColor: Colors.green,
                                  ),
                                  SizedBox(width: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          child: Text(
                                            "Broadcast to nearby Delivery Partner",
                                            softWrap: false,
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                                color: Colors.black,
                                                height: 1),
                                          )),
                                      val == "DP"
                                          ? InkWell(
                                              onTap: () async {
                                                print(lat);
                                                _currentPosition =
                                                    await location
                                                        .getLocation();
                                                List<geo.Placemark> placemarks =
                                                    await geo
                                                        .placemarkFromCoordinates(
                                                            _currentPosition
                                                                .latitude,
                                                            _currentPosition
                                                                .longitude);

                                                geo.Placemark place =
                                                    placemarks[0];
                                                print(place.administrativeArea);
                                                setState(() {
                                                  _currentAddress =
                                                      "${place.street}, ${place.subLocality}, ${place.locality} ${place.postalCode}, ${place.administrativeArea},";
                                                });

                                                MapUtils.openMap(
                                                  double.parse(_currentPosition
                                                      .latitude
                                                      .toString()),
                                                  double.parse(_currentPosition
                                                      .longitude
                                                      .toString()),
                                                  double.parse(widget.objOrder
                                                      .updatedDropLatitude),
                                                  double.parse(
                                                    widget.objOrder
                                                        .updatedDropLongitude,
                                                  ),
                                                );

                                                // pushToViewController(
                                                //     context,
                                                //     MapVC(
                                                //       pickupLocation:
                                                //           _currentAddress,
                                                //       dropLocation: widget
                                                //           .objOrder
                                                //           .updatedDropLocation,
                                                //       pickupLat:
                                                //           _currentPosition
                                                //               .latitude
                                                //               .toString(),
                                                //       pickupLng:
                                                //           _currentPosition
                                                //               .longitude
                                                //               .toString(),
                                                //       dropLat: widget.objOrder
                                                //           .updatedDropLatitude,
                                                //       dropLng: widget.objOrder
                                                //           .updatedDropLongitude,
                                                //       mobileNo: widget
                                                //           .objOrder
                                                //           .users[1]
                                                //           .mobileNumber1,
                                                //     ),
                                                //     () {});
                                              },
                                              child: Image.asset(
                                                  "assets/images/map.png",
                                                  height: 30,
                                                  width: 30))
                                          : Container()
                                    ],
                                  ),
                                ]),
                              ],
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            boxShadow: [getShadow(0, 0, 15)]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Expanded(
                            child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width - 30,
                                child: setbuttonWithChild(
                                    setCustomFont("Accept", 16, Colors.white,
                                        FontWeight.w400, 1), () {
                                  if (connectionStatus ==
                                      DataConnectionStatus.connected) {
                                    if (val == "PDC" &&
                                        txtStorageController.text.isEmpty) {
                                      showCustomToast(
                                          "Please select Storage Location",
                                          context);
                                    } else if (val == "DP") {
                                      print("ok");
                                      print(orderDetail.orderNumber);
                                      FormData formData = FormData.fromMap({
                                        "package_id": orderDetail
                                            .packageDetail[0].packageId,
                                        "is_collection": '',
                                        "deliveryboy_id": userObj.id
                                      });
                                      print(formData.fields);

                                      postDataRequestWithToken(
                                              "deliveryboy/order/drop-Package-broadcast",
                                              formData,
                                              context)
                                          .then((value) {
                                        showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(15),
                                                              topLeft: Radius
                                                                  .circular(
                                                                      15)),
                                                      color: Colors.white),
                                                  height: WidgetsBinding
                                                              .instance
                                                              .window
                                                              .viewInsets
                                                              .bottom >
                                                          0.0
                                                      ? getCalculated(450)
                                                      : getCalculated(300),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 23,
                                                        ),
                                                        setCustomFont(
                                                            "Enter OTP to deliver order",
                                                            14,
                                                            textBlackColor,
                                                            FontWeight.w400,
                                                            1.5),
                                                        SizedBox(
                                                          height: 27,
                                                        ),
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  15, 0, 15, 0),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 57,
                                                          child:
                                                              PinCodeTextField(
                                                            autofocus: false,
                                                            controller:
                                                                controller,
                                                            hideCharacter:
                                                                false,
                                                            highlight: true,
                                                            pinBoxOuterPadding: EdgeInsets.fromLTRB(
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    22,
                                                                0,
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    22,
                                                                0),
                                                            highlightColor:
                                                                Color.fromRGBO(
                                                                    223,
                                                                    223,
                                                                    223,
                                                                    1),
                                                            defaultBorderColor:
                                                                Color.fromRGBO(
                                                                    223,
                                                                    223,
                                                                    223,
                                                                    1),
                                                            hasTextBorderColor:
                                                                Color.fromRGBO(
                                                                    223,
                                                                    223,
                                                                    223,
                                                                    1),
                                                            highlightPinBoxColor:
                                                                Colors
                                                                    .transparent,
                                                            pinBoxBorderWidth:
                                                                1,
                                                            pinBoxRadius: 5,
                                                            maxLength: 4,
                                                            hasError: hasError,
                                                            onTextChanged:
                                                                (text) {
                                                              setState(() {
                                                                strOTP = text;
                                                                hasError =
                                                                    false;
                                                                // if (strOTP.length == 4) {
                                                                //   _onSubmitTap();
                                                                // }
                                                              });
                                                            },
                                                            pinBoxWidth: 57,
                                                            pinBoxHeight: 57,
                                                            hasUnderline: false,
                                                            wrapAlignment:
                                                                WrapAlignment
                                                                    .center,
                                                            pinBoxDecoration:
                                                                ProvidedPinBoxDecoration
                                                                    .defaultPinBoxDecoration,
                                                            pinTextStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        22.0),
                                                            pinTextAnimatedSwitcherTransition:
                                                                ProvidedPinBoxTextAnimation
                                                                    .scalingTransition,
                                                            pinTextAnimatedSwitcherDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        300),
                                                            highlightAnimationBeginColor:
                                                                Colors.black,
                                                            highlightAnimationEndColor:
                                                                Colors.white12,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                          ),
                                                        ),
                                                        Container(height: 30),
                                                        Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(15, 0,
                                                                    15, 0),
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 57,
                                                            child: setbuttonWithChild(
                                                                isVerifyLoading == true
                                                                    ? Container(
                                                                        width:
                                                                            30,
                                                                        height:
                                                                            30,
                                                                        child: setButtonIndicator(
                                                                            4,
                                                                            Colors.white),
                                                                      )
                                                                    : setCustomFont(
                                                                        "Verify",
                                                                        16,
                                                                        Colors
                                                                            .white,
                                                                        FontWeight
                                                                            .w400,
                                                                        1,
                                                                      ),
                                                                _onSubmitTap2,
                                                                appColor,
                                                                Colors.purple[900],
                                                                5)),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                      ],
                                                    ),
                                                  ));
                                            });
                                      });
                                    } else {
                                      showGreenToast(
                                          "Your selected PDC is: " +
                                              txtStorageController.text,
                                          context);
                                      print(orderDetail.orderNumber);
                                      FormData formData = FormData.fromMap({
                                        "collection_center_id": id,
                                        "package_id": orderDetail
                                            .packageDetail[0].packageId,
                                      });
                                      print(formData.fields);

                                      postDataRequestWithToken(
                                              "deliveryboy/order/drop-package",
                                              formData,
                                              context)
                                          .then((value) {
                                        print(value);
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => TabbarVC(),
                                              fullscreenDialog: false),
                                          (route) => false,
                                        );
                                      });
                                    }
                                  } else {
                                    showCustomToast(
                                        "Please check your internet connection",
                                        context);
                                  }
                                }, appColor, Colors.purple[900], 5))),
                        SizedBox(width: 15),
                        Expanded(
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 30,
                            child: setbuttonWithChild(
                                setCustomFont("Reject", 16, Colors.white,
                                    FontWeight.w400, 1), () {
                              Navigator.pop(context);
                            }, appColor, Colors.purple[900], 5),
                          ),
                        ),
                      ])
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _newTaskModalBottomSheet(context) {
    getCalculated(double value) {
      double height = MediaQuery.of(context).size.height;
      if (height >= 800.0 && height <= 895.0) {
        // For devices Iphone 10 range. For android hd.
        return 667.0 * (value / 568.0);
      } else if (height >= 896.0) {
        // For XR and XS max.
        return 736.0 * (value / 568.0);
      } else {
        // For other.
        return height * (value / 568.0);
      }
    }

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15)),
                  color: Colors.white),
              height: WidgetsBinding.instance.window.viewInsets.bottom > 0.0
                  ? getCalculated(450)
                  : getCalculated(300),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 23,
                    ),
                    setCustomFont("Enter OTP for delivered order", 14,
                        textBlackColor, FontWeight.w400, 1.5),
                    SizedBox(
                      height: 27,
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      width: MediaQuery.of(context).size.width,
                      height: 57,
                      child: PinCodeTextField(
                        autofocus: false,
                        controller: controller,
                        hideCharacter: false,
                        highlight: true,
                        pinBoxOuterPadding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 22,
                            0,
                            MediaQuery.of(context).size.width / 22,
                            0),
                        highlightColor: Color.fromRGBO(223, 223, 223, 1),
                        defaultBorderColor: Color.fromRGBO(223, 223, 223, 1),
                        hasTextBorderColor: Color.fromRGBO(223, 223, 223, 1),
                        highlightPinBoxColor: Colors.transparent,
                        pinBoxBorderWidth: 1,
                        pinBoxRadius: 5,
                        maxLength: 4,
                        hasError: hasError,
                        onTextChanged: (text) {
                          setState(() {
                            strOTP = text;
                            hasError = false;
                            // if (strOTP.length == 4) {
                            //   _onSubmitTap();
                            // }
                          });
                        },
                        pinBoxWidth: 57,
                        pinBoxHeight: 57,
                        hasUnderline: false,
                        wrapAlignment: WrapAlignment.center,
                        pinBoxDecoration:
                            ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                        pinTextStyle: TextStyle(fontSize: 22.0),
                        pinTextAnimatedSwitcherTransition:
                            ProvidedPinBoxTextAnimation.scalingTransition,
                        pinTextAnimatedSwitcherDuration:
                            Duration(milliseconds: 300),
                        highlightAnimationBeginColor: Colors.black,
                        highlightAnimationEndColor: Colors.white12,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(height: 30),
                    Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        width: MediaQuery.of(context).size.width,
                        height: 57,
                        child: setbuttonWithChild(
                            isVerifyLoading == true
                                ? Container(
                                    width: 30,
                                    height: 30,
                                    child: setButtonIndicator(4, Colors.white),
                                  )
                                : setCustomFont(
                                    "Verify",
                                    16,
                                    Colors.white,
                                    FontWeight.w400,
                                    1,
                                  ),
                            _onSubmitTap,
                            appColor,
                            Colors.purple[900],
                            5)),
                    SizedBox(
                      height: 30,
                    ),
                    setCustomFont("Didn't receive the verification OTP?", 16,
                        textBlackColor, FontWeight.w400, 1),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        if (connectionStatus ==
                            DataConnectionStatus.connected) {
                          _onSendOTPTap();
                        } else {
                          showCustomToast(
                              "Please check your internet connection", context);
                        }
                      },
                      child: Container(
                          width: 200,
                          alignment: Alignment.center,
                          child: isResendOTP
                              ? Container(
                                  width: 30,
                                  height: 30,
                                  child: setButtonIndicator(3, appColor),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  child: setCustomFont("Resend OTP", 15,
                                      appColor, FontWeight.w400, 1),
                                )),
                    ),
                  ],
                ),
              ));
        });
  }

  _onSubmitTap() {
    FocusScope.of(context).unfocus();

    if (strOTP == "") {
      showCustomToast("4 digit OTP is required", context);
      return;
    } else if (strOTP.length < 4) {
      showCustomToast("Please enter 4 digit OTP", context);
      return;
    }

    setState(() {
      isVerifyLoading = true;
    });

    FormData formData;

    if (widget.objOrder.dropLocation == widget.objOrder.updatedDropLocation) {
      formData = FormData.fromMap({
        "package_id": widget.objOrder.id,
        "otp": strOTP,
        "is_destination": 1
      });
    } else {
      formData = FormData.fromMap({
        "package_id": widget.objOrder.id,
        "otp": strOTP,
      });
    }

    if (connectionStatus == DataConnectionStatus.connected) {
      postDataRequestWithToken(deliverySuccessApi, formData, context)
          .then((value) {
        setState(() {
          isVerifyLoading = false;
        });

        if (value is Map) {
          showGreenToast("Order Delivered Successfully", context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OrderdeliveredVC(
                      objOrder: widget.objOrder,
                    ),
                fullscreenDialog: false),
          ).then((value) {});
        } else {
          setState(() {
            isVerifyLoading = false;
          });

          showCustomToast("Please enter valid Verification code", context);
        }

        // if (value == "Please enter valid Verification code") {
        //   showCustomToast(value[kMessage].toString(), context);
        // }
      });
    } else {
      setState(() {
        isVerifyLoading = false;
      });
      showCustomToast("Please check your internet connection", context);
    }
  }

  _onSendOTPTap() {
    FormData formData = FormData.fromMap({
      "package_id": widget.objOrder.id,
    });

    postDataRequestWithToken(deliveryVerificationAPI, formData, context)
        .then((value) => {
              if (value[kStatusCode] == 200)
                {
                  showGreenToast(value[kMessage].toString(), context),
                }
              else
                {
                  showCustomToast(value[kStatusCode], context),
                },
            });
  }

  Future<void> loadAssets() async {
    var status = await per.Permission.photos.request();
    if (status == per.PermissionStatus.denied) {
      return _showPhotoPermissionDialog();
    }
    if (images.length == 3) {
      return;
    }

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(maxImages: 1);
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (resultList == null) return;
      for (var itemObj in resultList) {
        images.add(itemObj);
      }

      if (error == null) _error = 'No Error Dectected';
    });
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
                per.openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  showStoragePopup() {
    return SingleChildScrollView(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
          child: Container(
            child: setCustomFont(
                "Storage Centers", 16, textBlackColor, FontWeight.w600, 1),
          ),
        ),
        Container(
          height: 1,
          child: Divider(
            height: 1,
            thickness: 2,
          ),
        ),
        Container(
          height: Device.screenHeight / 3,
          width: Device.screenWidth - 50,
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
            shrinkWrap: false,
            itemCount: storageName.length,
            itemBuilder: (context, position) {
              return InkWell(
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  print(storageId);
                  setState(() {
                    txtStorageController.text = (storageAddress[position]);
                    id = storageId[position];
                    selectedStorage = storageAddress[position];

                    Navigator.pop(context);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Container(
                        child: setCustomFont(storageName[position], 16,
                            textBlackColor, FontWeight.w600, 1),
                      ),
                      SizedBox(height: 8),
                      Container(
                          width: MediaQuery.of(context).size.width * .80,
                          child: setCustomFontWithAlignment(
                              storageAddress[position],
                              14,
                              textBlackColor,
                              FontWeight.w400,
                              1,
                              TextAlign.left)),
                      SizedBox(height: 10),
                      Container(
                        height: 1,
                        child: Divider(
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ));
  }
}
