import 'dart:convert';

import 'package:countmee/Model/PandingDataModel.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/MapVC.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/OrderDeliveredVC.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/UploadImages.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/drop.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:timeago/timeago.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

import '../TabBar/TabBarVC.dart';

/*
Title : AcceptedOrderVC
Purpose: AcceptedOrderVC
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class AcceptedOrderVC extends StatefulWidget {
  final PandingDataModel objOrder;

  const AcceptedOrderVC({
    Key key,
    this.objOrder,
  }) : super(key: key);

  @override
  _AcceptedOrderVCState createState() => _AcceptedOrderVCState();
}

class _AcceptedOrderVCState extends State<AcceptedOrderVC> {
  var switchValue = false;
  var microWave = false;
  var val = "PDC";
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
  String dateFormat = "";
  String orderDate = "";
  bool isOTPSent = false;
  bool _isChecked = true;
  bool isStorage = true;
  List storageName = [];
  List storageAddress = [];
  List storageId = [];
  List storage = [];
  var selectedStorage = "";
  String _comingSms = 'Unknown';

  int id;
  @override
  void initState() {
    super.initState();
    imageCount.clear();
    print(widget.objOrder.packageImages);
    checkConnection(context);
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

    afterDelay(1, () async {
      await postDataRequestWithToken(collectionCentersApi, null, context)
          .then((value) {
        if (value[kData] is List) {
          setState(() {
            for (var item in value['data']) {
              storageName.add(item['name']);
              storageAddress.add(item['address']);
              storageId.add(item['id']);
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

  getOrderDetail() async {
    setState(() {
      isLoading = true;
    });
    FormData formData = FormData.fromMap({
      "order_id": widget.objOrder.id,
    });
    await postDataRequestWithToken(getOrderDetailAPI, formData, context)
        .then((value) {
      print(value);

      if (value[kStatusCode] == 200) {
        if (value[kData] is Map) {
          setState(() {
            orderDetail = PandingDataModel.fromJson(value[kData]);
            print("ok");
            print(orderDetail.is_pickup);
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
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => TabbarVC()),
            (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: setCustomFont(
              "Order Details", 20, textBlackColor, FontWeight.w600, 1),
          leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
            Navigator.pop(context);
          }, Colors.transparent, Colors.transparent, 0),
        ),
        body: isLoading && orderDetail == null
            ? Center(child: setButtonIndicator(2, appColor))
            : orderDetail.packageDetail == null &&
                    orderDetail.packageDetail[0] == null
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
                                  SizedBox(
                                    width: 15,
                                  ),
                                  setCustomFont(
                                    "Order Status",
                                    16,
                                    textBlackColor,
                                    FontWeight.w600,
                                    1,
                                  ),
                                  Spacer(),
                                  setCustomFont(
                                    "Pending",
                                    14,
                                    textBlackColor,
                                    FontWeight.w400,
                                    1,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              ),
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  boxShadow: [getShadow(0, 0, 15)]),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Spacer(),
                                  setCustomFont("Order No. :", 16,
                                      textBlackColor, FontWeight.w600, 1),
                                  setCustomFont(
                                    orderDetail != null
                                        ? orderDetail.orderNumber ?? ""
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
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
                                      orderDetail != null &&
                                              orderDetail.users != null &&
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
                                      orderDetail != null &&
                                              orderDetail.users != null &&
                                              orderDetail
                                                      .users[1].mobileNumber1 !=
                                                  null
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      setCustomFont("Address Details", 16,
                                          textBlackColor, FontWeight.w600, 1),
                                      InkWell(
                                          onTap: () {
                                            // var source = LatLng(
                                            //     double.parse(widget.objOrder
                                            //         .updatedPickupLatitude),
                                            //     double.parse(widget.objOrder
                                            //         .updatedPickupLongitude));
                                            // var destination = LatLng(
                                            //     double.parse(widget
                                            //         .objOrder.updatedDropLatitude),
                                            //     double.parse(widget.objOrder
                                            //         .updatedDropLongitude));
                                            MapUtils.openMap(
                                                double.parse(widget.objOrder
                                                    .updatedPickupLatitude),
                                                double.parse(widget.objOrder
                                                    .updatedPickupLongitude),
                                                double.parse(widget.objOrder
                                                    .updatedDropLatitude),
                                                double.parse(widget.objOrder
                                                    .updatedDropLongitude));
                                            // pushToViewController(
                                            //     context,
                                            //     MapVC(
                                            //       pickupLocation: widget.objOrder
                                            //           .updatedPickupLocation,
                                            //       dropLocation: widget
                                            //           .objOrder.updatedDropLocation,
                                            //       pickupLat: widget.objOrder
                                            //           .updatedPickupLatitude,
                                            //       pickupLng: widget.objOrder
                                            //           .updatedPickupLongitude,
                                            //       dropLat: widget
                                            //           .objOrder.updatedDropLatitude,
                                            //       dropLng: widget.objOrder
                                            //           .updatedDropLongitude,
                                            //       mobileNo: widget.objOrder.users[1]
                                            //           .mobileNumber1,
                                            //     ),
                                            //     () {});
                                          },
                                          child: Image.asset(
                                              "assets/images/map.png",
                                              height: 30,
                                              width: 30))
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                color: Color.fromRGBO(
                                                    239, 239, 239, 1),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            ClipOval(
                                              child: Container(
                                                width: 3,
                                                height: 3,
                                                color: Color.fromRGBO(
                                                    239, 239, 239, 1),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            ClipOval(
                                              child: Container(
                                                width: 3,
                                                height: 3,
                                                color: Color.fromRGBO(
                                                    239, 239, 239, 1),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            ClipOval(
                                              child: Container(
                                                width: 3,
                                                height: 3,
                                                color: Color.fromRGBO(
                                                    239, 239, 239, 1),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            ClipOval(
                                              child: Container(
                                                width: 3,
                                                height: 3,
                                                color: Color.fromRGBO(
                                                    239, 239, 239, 1),
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
                                                  Color.fromRGBO(
                                                      287, 287, 287, 1),
                                                  FontWeight.w300,
                                                  1),
                                              SizedBox(
                                                height: 9,
                                              ),
                                              setCustomFontWithAlignment(
                                                  orderDetail != null &&
                                                          orderDetail
                                                                  .updatedPickupLocation !=
                                                              null
                                                      ? orderDetail
                                                          .updatedPickupLocation
                                                      : "",
                                                  15,
                                                  Color.fromRGBO(
                                                      287, 287, 287, 1),
                                                  FontWeight.w500,
                                                  1,
                                                  TextAlign.left),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 1,
                                                    width:
                                                        MediaQuery.of(context)
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
                                                  Color.fromRGBO(
                                                      287, 287, 287, 1),
                                                  FontWeight.w300,
                                                  1),
                                              SizedBox(
                                                height: 9,
                                              ),
                                              setCustomFontWithAlignment(
                                                  orderDetail != null &&
                                                          orderDetail
                                                                  .updatedDropLocation !=
                                                              null
                                                      ? orderDetail
                                                          .updatedDropLocation
                                                      : "",
                                                  15,
                                                  Color.fromRGBO(
                                                      287, 287, 287, 1),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
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
                                  setCustomFont("Product Details", 16,
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
                                  Row(
                                    children: [
                                      Container(
                                        child: setCustomFontWithAlignment(
                                            orderDetail != null &&
                                                    orderDetail.packageDetail !=
                                                        null &&
                                                    orderDetail.packageDetail[0]
                                                            .productDesc ==
                                                        'Others'
                                                ? orderDetail.packageDetail[0]
                                                    .otherProductDesc
                                                : orderDetail.packageDetail[0]
                                                        .productDesc ??
                                                    "",
                                            16,
                                            textBlackColor,
                                            FontWeight.w500,
                                            1,
                                            TextAlign.left),
                                      ),
                                      Spacer(),
                                      Container(
                                        height: 25,
                                        child: setbuttonWithChild(
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  setImageName(
                                                      "iconUploadFile.png",
                                                      12,
                                                      12),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  setCustomFont(
                                                      "Upload",
                                                      10,
                                                      textBlackColor,
                                                      FontWeight.w400,
                                                      1)
                                                ],
                                              ),
                                            ), () {
                                          bool isView = false;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UploadImages(
                                                        isView: isView,
                                                        packageDetails:
                                                            orderDetail
                                                                .packageDetail,
                                                        packageImages:
                                                            orderDetail
                                                                .packageImages,
                                                      ),
                                                  fullscreenDialog: false));
                                        }, Color.fromRGBO(226, 226, 226, 1),
                                            Colors.transparent, 20),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    child: setCustomFontWithAlignment(
                                        orderDetail != null &&
                                                orderDetail.packageDetail !=
                                                    null
                                            ? orderDetail
                                                    .packageDetail[0].weight ??
                                                ""
                                            : "",
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
                                        orderDetail != null &&
                                                orderDetail.packageDetail !=
                                                    null
                                            ? orderDetail.packageDetail[0]
                                                    .handleProduct ??
                                                ""
                                            : "",
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
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
                                  setCustomFont("Mode of Transport", 16,
                                      textBlackColor, FontWeight.w600, 1),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Color.fromRGBO(226, 226, 226, 1),
                                  ),
                                  Row(
                                    children: [
                                      setTransportImage(
                                          orderDetail.transportImage),
                                      SizedBox(
                                        width: 14,
                                      ),
                                      setCustomFont(
                                          orderDetail.transportMode != null
                                              ? orderDetail.transportMode
                                              : "",
                                          14,
                                          textBlackColor,
                                          FontWeight.w400,
                                          1),
                                    ],
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
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
                                  setCustomFont("Product Details", 16,
                                      textBlackColor, FontWeight.w600, 1),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Color.fromRGBO(226, 226, 226, 1)
                                        .withAlpha(500),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        child: setCustomFontWithAlignment(
                                            orderDetail != null &&
                                                    orderDetail.packageDetail !=
                                                        null &&
                                                    orderDetail.packageDetail[0]
                                                            .productDesc ==
                                                        'Others'
                                                ? orderDetail.packageDetail[0]
                                                    .otherProductDesc
                                                : orderDetail.packageDetail[0]
                                                        .productDesc ??
                                                    "",
                                            16,
                                            textBlackColor,
                                            FontWeight.w500,
                                            1,
                                            TextAlign.left),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          bool isView = true;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UploadImages(
                                                        isView: isView,
                                                        packageDetails:
                                                            orderDetail
                                                                .packageDetail,
                                                        packageImages:
                                                            orderDetail
                                                                .packageImages,
                                                      ),
                                                  fullscreenDialog: false));
                                        },
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  235, 235, 235, 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          height: 20,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.remove_red_eye,
                                                size: 15,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                height: 10,
                                                child: setCustomFont(
                                                    "View",
                                                    11,
                                                    textBlackColor,
                                                    FontWeight.w400,
                                                    1),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    child: setCustomFontWithAlignment(
                                        orderDetail != null &&
                                                orderDetail.packageDetail !=
                                                    null
                                            ? orderDetail
                                                    .packageDetail[0].weight ??
                                                ""
                                            : "",
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
                                        orderDetail != null &&
                                                orderDetail.packageDetail !=
                                                    null
                                            ? orderDetail.packageDetail[0]
                                                    .handleProduct ??
                                                ""
                                            : "",
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  boxShadow: [getShadow(0, 0, 15)]),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            orderDetail.is_delivered == "false"
                                ? orderDetail.is_pickup == "false"
                                    ? Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 20),
                                        child: Row(children: [
                                          Expanded(
                                              child: Container(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                30,
                                            child: setbuttonWithChild(
                                                setCustomFont(
                                                    "Pick Up",
                                                    16,
                                                    Colors.white,
                                                    FontWeight.w400,
                                                    1), () async {
                                              print(orderDetail
                                                  .first_deliveryboy);
                                              if (orderDetail
                                                      .first_deliveryboy ==
                                                  1) {
                                                FormData formData =
                                                    FormData.fromMap({
                                                  "package_id":
                                                      widget.objOrder.id,
                                                });
                                                postDataRequestWithToken(
                                                        "deliveryboy/order/pickup",
                                                        formData,
                                                        context)
                                                    .then((value) {
                                                  print(value);
                                                  if (value[kData] is List) {
                                                    print(value);
                                                  }
                                                });
                                                showModalBottomSheet(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          15),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          15)),
                                                              color:
                                                                  Colors.white),
                                                          height: WidgetsBinding
                                                                      .instance
                                                                      .window
                                                                      .viewInsets
                                                                      .bottom >
                                                                  0.0
                                                              ? getCalculated(
                                                                  450)
                                                              : getCalculated(
                                                                  300),
                                                          child: Center(
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 23,
                                                                ),
                                                                setCustomFont(
                                                                    "Enter OTP for delivered order",
                                                                    14,
                                                                    textBlackColor,
                                                                    FontWeight
                                                                        .w400,
                                                                    1.5),
                                                                SizedBox(
                                                                  height: 27,
                                                                ),
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          15,
                                                                          0,
                                                                          15,
                                                                          0),
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  height: 57,
                                                                  child:
                                                                      PinCodeTextField(
                                                                    autofocus:
                                                                        false,
                                                                    controller:
                                                                        controller,
                                                                    hideCharacter:
                                                                        false,
                                                                    highlight:
                                                                        true,
                                                                    pinBoxOuterPadding: EdgeInsets.fromLTRB(
                                                                        MediaQuery.of(context).size.width /
                                                                            22,
                                                                        0,
                                                                        MediaQuery.of(context).size.width /
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
                                                                    pinBoxRadius:
                                                                        5,
                                                                    maxLength:
                                                                        4,
                                                                    hasError:
                                                                        hasError,
                                                                    onTextChanged:
                                                                        (text) {
                                                                      setState(
                                                                          () {
                                                                        strOTP =
                                                                            text;
                                                                        hasError =
                                                                            false;
                                                                        // if (strOTP.length == 4) {
                                                                        //   _onSubmitTap();
                                                                        // }
                                                                      });
                                                                    },
                                                                    pinBoxWidth:
                                                                        57,
                                                                    pinBoxHeight:
                                                                        57,
                                                                    hasUnderline:
                                                                        false,
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
                                                                        Colors
                                                                            .black,
                                                                    highlightAnimationEndColor:
                                                                        Colors
                                                                            .white12,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                  ),
                                                                ),
                                                                Container(
                                                                    height: 30),
                                                                Container(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            15,
                                                                            0,
                                                                            15,
                                                                            0),
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
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
                                                                        _onSubmitTap2,
                                                                        appColor,
                                                                        Colors.purple[900],
                                                                        5)),
                                                                SizedBox(
                                                                  height: 30,
                                                                ),
                                                                setCustomFont(
                                                                    "Didn't receive the verification OTP?",
                                                                    16,
                                                                    textBlackColor,
                                                                    FontWeight
                                                                        .w400,
                                                                    1),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    if (connectionStatus ==
                                                                        DataConnectionStatus
                                                                            .connected) {
                                                                      FormData
                                                                          formData =
                                                                          FormData
                                                                              .fromMap({
                                                                        "package_id": widget
                                                                            .objOrder
                                                                            .id,
                                                                      });
                                                                      postDataRequestWithToken(
                                                                              "deliveryboy/order/pickup",
                                                                              formData,
                                                                              context)
                                                                          .then(
                                                                              (value) {
                                                                        print(
                                                                            value);
                                                                        if (value[kData]
                                                                            is List) {
                                                                          print(
                                                                              value);
                                                                        }
                                                                      });
                                                                    } else {
                                                                      showCustomToast(
                                                                          "Please check your internet connection",
                                                                          context);
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
                                                                              child: setCustomFont("Resend OTP", 15, appColor, FontWeight.w400, 1),
                                                                            )),
                                                                ),
                                                              ],
                                                            ),
                                                          ));
                                                    });
                                              } else {
                                                FormData formData =
                                                    FormData.fromMap({
                                                  "package_id":
                                                      widget.objOrder.id
                                                });

                                                await postDataRequestWithToken(
                                                        "deliveryboy/order/drop-package-send-otp",
                                                        formData,
                                                        context)
                                                    .then((value) => {
                                                          print(value),
                                                          if (value[
                                                                  kStatusCode] ==
                                                              200)
                                                            {
                                                              showGreenToast(
                                                                  "OTP received successfully",
                                                                  context),
                                                              Navigator
                                                                  .pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            TabbarVC(),
                                                                    fullscreenDialog:
                                                                        false),
                                                                (route) =>
                                                                    false,
                                                              )
                                                              //Navigator.pop(context)
                                                            }
                                                          else
                                                            {
                                                              showCustomToast(
                                                                  value[
                                                                      kMessage],
                                                                  context),
                                                            },
                                                        });
                                              }
                                            }, appColor, Colors.purple[900], 5),
                                          )),
                                          orderDetail.first_deliveryboy == 1
                                              ? SizedBox(width: 15)
                                              : Container(),
                                          orderDetail.first_deliveryboy == 1
                                              ? Expanded(
                                                  child: Container(
                                                    height: 50,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            30,
                                                    child: setbuttonWithChild(
                                                        setCustomFont(
                                                            "Cancel",
                                                            16,
                                                            Colors.white,
                                                            FontWeight.w400,
                                                            1), () {
                                                      if (connectionStatus ==
                                                          DataConnectionStatus
                                                              .connected) {
                                                        // showDialog(
                                                        //     context: context,
                                                        //     builder: (BuildContext
                                                        //         context) {
                                                        //       return CupertinoAlertDialog(
                                                        //         content: Text(
                                                        //           "Are you sure you want to cancel your order?",
                                                        //           style: TextStyle(
                                                        //               fontSize: 15),
                                                        //         ),
                                                        //         actions: <Widget>[
                                                        //           CupertinoDialogAction(
                                                        //             textStyle: TextStyle(
                                                        //                 color: Colors
                                                        //                     .red,
                                                        //                 fontSize: 18),
                                                        //             isDefaultAction:
                                                        //                 true,
                                                        //             onPressed: () {
                                                        //               Navigator.of(
                                                        //                       context)
                                                        //                   .pop(false);
                                                        //             },
                                                        //             child: Text("No"),
                                                        //           ),
                                                        //           CupertinoDialogAction(
                                                        //             textStyle: TextStyle(
                                                        //                 color:
                                                        //                     appColor,
                                                        //                 fontSize: 18),
                                                        //             isDefaultAction:
                                                        //                 true,
                                                        //             onPressed:
                                                        //                 () async {
                                                        //               setState(() {
                                                        //                 isLoading =
                                                        //                     true;
                                                        //               });
                                                        //               FormData
                                                        //                   formData =
                                                        //                   FormData
                                                        //                       .fromMap({
                                                        //                 "package_id":
                                                        //                     orderDetail
                                                        //                         .id
                                                        //                         .toString(),
                                                        //               });
                                                        //               postDataRequestWithToken(
                                                        //                       "cancel-by-dp",
                                                        //                       formData,
                                                        //                       context)
                                                        //                   .then(
                                                        //                       (value) {
                                                        //                 setState(() {
                                                        //                   isLoading =
                                                        //                       false;
                                                        //                 });
                                                        //                 print(value);
                                                        //                 if (value[
                                                        //                         kStatusCode] ==
                                                        //                     200) {
                                                        //                   if (value[
                                                        //                           kData]
                                                        //                       is Map) {
                                                        //                     showCustomToast(
                                                        //                         value[
                                                        //                             kMessage],
                                                        //                         context);
                                                        //                   } else {
                                                        //                     Navigator.of(
                                                        //                             context)
                                                        //                         .pop(
                                                        //                             false);
                                                        //                     Navigator.of(
                                                        //                             context)
                                                        //                         .pop(
                                                        //                             false);
                                                        //                     Navigator.of(
                                                        //                             context)
                                                        //                         .pop(
                                                        //                             false);
                                                        //                     Navigator.pushAndRemoveUntil(
                                                        //                         context,
                                                        //                         MaterialPageRoute(
                                                        //                           builder: (context) =>
                                                        //                               TabbarVC(),
                                                        //                           fullscreenDialog:
                                                        //                               false,
                                                        //                         ),
                                                        //                         (route) => false);
                                                        //                     showCustomToast(
                                                        //                         value[
                                                        //                             kMessage],
                                                        //                         context);
                                                        //                   }
                                                        //                 } else {
                                                        //                   showCustomToast(
                                                        //                       value[
                                                        //                           kMessage],
                                                        //                       context);
                                                        //                 }
                                                        //               });
                                                        //             },
                                                        //             child:
                                                        //                 Text("Yes"),
                                                        //           ),
                                                        //         ],
                                                        //       );
                                                        //     });
                                                        print(orderDetail.id
                                                            .toString());
                                                        FormData formData =
                                                            FormData.fromMap({
                                                          "package_id":
                                                              orderDetail.id
                                                                  .toString(),
                                                        });

                                                        postDataRequestWithToken(
                                                                'cancel-by-dp-after-accepted',
                                                                formData,
                                                                context)
                                                            .then((value) {
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                          print(value);
                                                          if (value[
                                                                  kStatusCode] ==
                                                              200) {
                                                            if (value[kData]
                                                                is Map) {
                                                              var a =
                                                                  value[kData];
                                                              print(a[
                                                                  'chargeable_amount']);

                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return CupertinoAlertDialog(
                                                                        content:
                                                                            Text(
                                                                          "If you cancel this order Rs ${a['chargeable_amount']}. will be debited. Click Yes to proceed.",
                                                                          style:
                                                                              TextStyle(fontSize: 15),
                                                                        ),
                                                                        actions: <
                                                                            Widget>[
                                                                          CupertinoDialogAction(
                                                                            textStyle:
                                                                                TextStyle(color: Colors.red, fontSize: 18),
                                                                            isDefaultAction:
                                                                                true,
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop(false);
                                                                            },
                                                                            child:
                                                                                Text("No"),
                                                                          ),
                                                                          CupertinoDialogAction(
                                                                            textStyle:
                                                                                TextStyle(color: appColor, fontSize: 18),
                                                                            isDefaultAction:
                                                                                true,
                                                                            onPressed:
                                                                                () async {
                                                                              setState(() {
                                                                                isLoading = true;
                                                                              });
                                                                              FormData formData = FormData.fromMap({
                                                                                "package_id": orderDetail.id.toString(),
                                                                              });
                                                                              postDataRequestWithToken("cancel-by-dp", formData, context).then((value) {
                                                                                setState(() {
                                                                                  isLoading = false;
                                                                                });
                                                                                print(value);
                                                                                if (value[kStatusCode] == 200) {
                                                                                  if (value[kData] is Map) {
                                                                                    showCustomToast(value[kMessage], context);
                                                                                  } else {
                                                                                    Navigator.of(context).pop(false);
                                                                                    Navigator.of(context).pop(false);
                                                                                    Navigator.of(context).pop(false);
                                                                                    Navigator.pushAndRemoveUntil(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                          builder: (context) => TabbarVC(),
                                                                                          fullscreenDialog: false,
                                                                                        ),
                                                                                        (route) => false);
                                                                                    showCustomToast(value[kMessage], context);
                                                                                  }
                                                                                } else {
                                                                                  showCustomToast(value[kMessage], context);
                                                                                }
                                                                              });
                                                                            },
                                                                            child:
                                                                                Text("Yes"),
                                                                          ),
                                                                        ]);
                                                                  });
                                                            }
                                                          }
                                                        });
                                                      } else {
                                                        showCustomToast(
                                                            "Please check your internet connection",
                                                            context);
                                                      }
                                                    }, appColor,
                                                        Colors.purple[900], 5),
                                                  ),
                                                )
                                              : Container()
                                        ]))
                                    : orderDetail.is_drop == "true"
                                        ? Container()
                                        : Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 0, 20),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 50,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            30,
                                                    child: setbuttonWithChild(
                                                        setCustomFont(
                                                            "Drop",
                                                            16,
                                                            Colors.white,
                                                            FontWeight.w400,
                                                            1), () {
                                                      print(
                                                          "ndsjnkasdksdkidjdsfkdfkoldlf;");
                                                      print(orderDetail
                                                          .is_delivered);
                                                      print(orderDetail
                                                          .is_pickup);
                                                      if (imageCount.length <
                                                          2) {
                                                        showCustomToast(
                                                            "Please upload minimum 2 images",
                                                            context);
                                                        return;
                                                      }
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              drop(
                                                            objOrder:
                                                                widget.objOrder,
                                                          ),
                                                          fullscreenDialog:
                                                              false,
                                                        ),
                                                      );
                                                    }, appColor,
                                                        Colors.purple[900], 5),
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                orderDetail.is_drop == "false"
                                                    ? Expanded(
                                                        child: Container(
                                                          height: 50,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              30,
                                                          child: setbuttonWithChild(
                                                              setCustomFont(
                                                                  "Delivered",
                                                                  16,
                                                                  Colors.white,
                                                                  FontWeight
                                                                      .w400,
                                                                  1), () {
                                                            if (connectionStatus ==
                                                                DataConnectionStatus
                                                                    .connected) {
                                                              if (imageCount
                                                                      .length <
                                                                  2) {
                                                                showCustomToast(
                                                                    "Please upload minimum 2 images",
                                                                    context);
                                                                return;
                                                              }
                                                              _onSendOTPTap();
                                                              _newTaskModalBottomSheet(
                                                                  context);
                                                            } else {
                                                              showCustomToast(
                                                                  "Please check your internet connection",
                                                                  context);
                                                            }
                                                          },
                                                              appColor,
                                                              Colors
                                                                  .purple[900],
                                                              5),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          )
                                : Container()
                          ],
                        ),
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

  _onSubmitTap2() {
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
      "pickup_address": widget.objOrder.updatedPickupLocation,
      "drop_address": widget.objOrder.updatedDropLocation,
      "pickup_latitude": widget.objOrder.updatedPickupLatitude,
      "pickup_longitude": widget.objOrder.updatedPickupLongitude,
      "drop_latitude": widget.objOrder.updatedDropLatitude,
      "drop_longitude": widget.objOrder.updatedDropLongitude,
    });

    if (connectionStatus == DataConnectionStatus.connected) {
      postDataRequestWithToken(
              "deliveryboy/order/pickup/verify-otp", formData, context)
          .then((value) {
        setState(() {
          isVerifyLoading = false;
        });

        if (value is Map) {
          showGreenToast("Order Pick Up Successfully", context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AcceptedOrderVC(
              objOrder: widget.objOrder,
            ),
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

  _onSendOTPTap() {
    FormData formData = FormData.fromMap(
        {"package_id": widget.objOrder.id, "is_deliveryboy": 0});

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
    var status = await Permission.photos.request();
    if (status == PermissionStatus.denied) {
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
                openAppSettings();
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

class MapUtils {
  MapUtils._();

  static Future<void> openMap(
      double latitude, double longitude, double lat, double lng) async {
    String googleUrl =
        'https://www.google.com/maps/dir/?api=1&origin=$latitude,$longitude&destination=$lat,$lng&travelmode=driving&dir_action=navigate';
    // 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&query=$lat,$lng';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
