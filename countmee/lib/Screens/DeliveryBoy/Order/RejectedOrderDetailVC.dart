import 'dart:convert';

import 'package:countmee/Model/PandingDataModel.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/*
Title : RejectedOrderDetailsVC
Purpose: RejectedOrderDetailsVC
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class RejectedOrderDetailsVC extends StatefulWidget {
  final PandingDataModel objOrder;

  const RejectedOrderDetailsVC({Key key, this.objOrder}) : super(key: key);
  @override
  _RejectedOrderDetailsVCState createState() => _RejectedOrderDetailsVCState();
}

class _RejectedOrderDetailsVCState extends State<RejectedOrderDetailsVC> {
  var isLoading = false;
  PandingDataModel orderDetail;
  var orderId;
  var collectionId;
  String dateFormat = "";
  String orderDate = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  getOrderDetail() {
    setState(() {
      isLoading = true;
    });
    FormData formData = FormData.fromMap({
      "order_id": widget.objOrder.id,
    });
    postDataRequestWithToken(getOrderDetailAPI, formData, context)
        .then((value) {
      if (value[kStatusCode] == 200) {
        if (value[kData] is Map) {
          setState(() {
            orderDetail = PandingDataModel.fromJson(value[kData]);
            dateFormat = widget.objOrder.createdAt.split("T")[0];
            orderDate =
                DateFormat('dd-MM-yyyy').format(DateTime.parse(dateFormat));
          });
          setState(() {
            isLoading = false;
          });
        } else {
          showCustomToast(value[kMessage], context);
        }
      } else {
        setState(() {
          isLoading = false;
        });
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
      body: SafeArea(
        child: isLoading && orderDetail == null
            ? Center(child: setButtonIndicator(2, appColor))
            : orderDetail.packageDetail == null &&
                    orderDetail.packageDetail[0] == null
                ? Center(child: setButtonIndicator(2, appColor))
                : SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: setImageName(
                                "orderRejectedBanner.png", 140, 95),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          setCustomFont(
                              "Order Rejected",
                              14,
                              Color.fromRGBO(
                                255,
                                29,
                                26,
                                1,
                              ),
                              FontWeight.w500,
                              1),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Spacer(),
                                setCustomFont("Order No. :", 16, textBlackColor,
                                    FontWeight.w600, 1),
                                setCustomFont(
                                    orderDetail != null
                                        ? orderDetail.orderNumber
                                        : "",
                                    14,
                                    textBlackColor,
                                    FontWeight.w400,
                                    1),
                                Spacer(),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Color.fromRGBO(178, 178, 178, 1),
                                ),
                                Spacer(),
                                setCustomFont(orderDate != null ? "Date :" : "",
                                    16, textBlackColor, FontWeight.w600, 1),
                                setCustomFont(
                                    orderDate != null ? " $orderDate" : "",
                                    14,
                                    textBlackColor,
                                    FontWeight.w400,
                                    1),
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
                            padding: EdgeInsets.fromLTRB(18, 10, 15, 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                setCustomFont("Address Details", 16,
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
                                                orderDetail.updatedPickupLocation !=
                                                        null
                                                    ? orderDetail
                                                        .updatedPickupLocation
                                                    : orderDetail
                                                                .pickupLocation !=
                                                            null
                                                        ? orderDetail
                                                            .pickupLocation
                                                        : "",
                                                16,
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.70,
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
                                                orderDetail.dropLocation != null
                                                    ? orderDetail.dropLocation
                                                    : "",
                                                16,
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
                                Container(
                                  child: setCustomFontWithAlignment(
                                      orderDetail.packageDetail[0]
                                                  .productDesc ==
                                              'Others'
                                          ? orderDetail
                                              .packageDetail[0].otherProductDesc
                                          : orderDetail.packageDetail[0]
                                                  .productDesc ??
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
                                      orderDetail.packageDetail[0].weight ?? "",
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
                                      orderDetail
                                              .packageDetail[0].handleProduct ??
                                          "",
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
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
