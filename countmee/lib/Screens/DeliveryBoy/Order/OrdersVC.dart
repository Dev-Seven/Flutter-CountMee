import 'dart:convert';

import 'package:countmee/Model/OrderCountModel.dart';
import 'package:countmee/Model/PandingDataModel.dart';
import 'package:countmee/Screens/DeliveryBoy/Home/OrderCell.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/DeliveredOrderCell.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/RejectedOrderCell.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

/*
Title : OrdersVC
Purpose: OrdersVC
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class OrdersVC extends StatefulWidget {
  final String strInfo;

  const OrdersVC({
    Key key,
    this.strInfo,
  }) : super(key: key);

  @override
  _OrdersVCState createState() => _OrdersVCState();
}

class _OrdersVCState extends State<OrdersVC> {
  var isDeliveredSelected = false;
  var isPendingSelected = true;
  var isRejectedSelected = false;
  var isCountLoading = false;
  var isPendingLoading = false;
  var isRejectedLoading = false;
  var isDeliveredLoading = false;
  int totalOrder = 0;
  OrderCountModel orderCount;
  List<PandingDataModel> arrPandingOrderList = List.from([PandingDataModel()]);
  List<PandingDataModel> arrRejectedOrderList = List.from([PandingDataModel()]);
  List<PandingDataModel> arrDeliveredOrderList =
      List.from([PandingDataModel()]);
  var orderId;
  var collectionId;

  @override
  void initState() {
    super.initState();
    checkConnection(context);
    if (widget.strInfo == "ViewDOrder") {
      setState(() {
        isDeliveredSelected = true;
        isPendingSelected = false;
        isRejectedSelected = false;
      });
    } else if (widget.strInfo == "ViewPOrder") {
      setState(() {
        isDeliveredSelected = false;
        isPendingSelected = true;
        isRejectedSelected = false;
      });
    } else if (widget.strInfo == "ViewROrder") {
      setState(() {
        isDeliveredSelected = false;
        isPendingSelected = false;
        isRejectedSelected = true;
      });
    }
    getOrderCount();
    getPandingOrders();
    getDiliveredOrder();
    getRejectedOrders();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        print('Order VIEW Controller onMessage.....');
        print(message.data['package_id']);
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

  getOrderCount() {
    setState(() {
      isCountLoading = true;
    });
    postAPIRequestWithToken(getOrderCountAPI, null, context).then((value) {
      setState(() {
        isCountLoading = false;
      });
      if (value[kData] is Map) {
        if (value[kStatusCode] == 200) {
          orderCount = OrderCountModel.fromJson(value[kData]);
          setState(() {
            totalOrder = orderCount.deliveredOrders +
                orderCount.pendingOrders +
                orderCount.rejectedOrders;
          });
        } else {
          showCustomToast(value[kMessage].toString(), context);
        }
      } else {
        showCustomToast(value.toString(), context);
      }
    });
  }

  getPandingOrders() {
    setState(() {
      isPendingLoading = true;
    });
    postAPIRequestWithToken(getPandingOrderListAPI, null, context)
        .then((value) {
      setState(() {
        isPendingLoading = false;
      });
      if (value is Map) {
        if (value[kStatusCode] == 200) {
          _handlePandingListResponse(value[kData]);
        } else {
          showCustomToast(value[kMessage], context);
        }
      } else {
        showCustomToast(value, context);
      }
    });
  }

  _handlePandingListResponse(value) {
    print(value);
    var arrData = value
        .map<PandingDataModel>((json) => PandingDataModel.fromJson(json))
        .toList();
    arrPandingOrderList = arrData;
  }

  getDiliveredOrder() {
    setState(() {
      isDeliveredLoading = true;
    });
    postAPIRequestWithToken(getDeliveredOrdersListAPI, null, context)
        .then((value) {
      setState(() {
        isDeliveredLoading = false;
      });
      if (value is Map) {
        if (value[kStatusCode] == 200) {
          _handleDeliveredListResponse(value[kData]);
        } else {
          print(value[kMessage]);
        }
      } else {
        showCustomToast(value, context);
      }
    });
  }

  _handleDeliveredListResponse(value) {
    print(value);
    var arrData = value
        .map<PandingDataModel>((json) => PandingDataModel.fromJson(json))
        .toList();
    arrDeliveredOrderList = arrData;
  }

  getRejectedOrders() {
    setState(() {
      isRejectedLoading = true;
    });
    postAPIRequestWithToken(getRejectedOrderListAPI, null, context)
        .then((value) {
      setState(() {
        isRejectedLoading = false;
      });
      if (value is Map) {
        if (value[kStatusCode] == 200) {
          _handleRejectListResponse(value[kData]);
        } else {
          showCustomToast(value[kMessage], context);
        }
      } else {
        showCustomToast(value, context);
      }
    });
  }

  _handleRejectListResponse(value) {
    var arrData = value
        .map<PandingDataModel>((json) => PandingDataModel.fromJson(json))
        .toList();
    arrRejectedOrderList = arrData;
    print("$arrRejectedOrderList");
  }

  @override
  Widget build(BuildContext context) {
    if (isConnected == true) {
      setState(() {
        getOrderCount();
        getPandingOrders();
        getDiliveredOrder();
        getRejectedOrders();
        isConnected = false;
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Container(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        setCustomFont(
                          "Total Orders",
                          13,
                          Colors.white,
                          FontWeight.w400,
                          1,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        setCustomFont(
                          totalOrder.toString(),
                          28,
                          Colors.white,
                          FontWeight.w600,
                          1,
                        ),
                      ],
                    ),
                  ),
                  height: 82,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: appColor,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isRejectedSelected = false;
                        isPendingSelected = false;
                        isDeliveredSelected = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          setCustomFont(
                              "Delivered Order",
                              13,
                              isDeliveredSelected
                                  ? Colors.white
                                  : textBlackColor,
                              FontWeight.w400,
                              1),
                          SizedBox(
                            height: 10,
                          ),
                          isCountLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: setButtonIndicator(
                                      3,
                                      isDeliveredSelected
                                          ? Colors.white
                                          : Color.fromRGBO(2, 167, 7, 1)),
                                )
                              : setCustomFont(
                                  orderCount == null
                                      ? ""
                                      : orderCount.deliveredOrders.toString(),
                                  28,
                                  isDeliveredSelected
                                      ? Colors.white
                                      : Color.fromRGBO(2, 167, 7, 1),
                                  FontWeight.w600,
                                  1,
                                ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: isDeliveredSelected ? appColor : Colors.white,
                          shape: BoxShape.rectangle,
                          boxShadow: [getdefaultShadow()]),
                      height: Device.screenWidth / 4.8,
                      width: Device.screenWidth / 3.4,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isRejectedSelected = false;
                        isPendingSelected = true;
                        isDeliveredSelected = false;
                      });
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          setCustomFont(
                              "Pending Order",
                              13,
                              isPendingSelected ? Colors.white : textBlackColor,
                              FontWeight.w400,
                              1),
                          SizedBox(
                            height: 10,
                          ),
                          isCountLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: setButtonIndicator(
                                      3,
                                      isPendingSelected
                                          ? Colors.white
                                          : Color.fromRGBO(230, 154, 0, 1)))
                              : setCustomFont(
                                  orderCount == null
                                      ? ""
                                      : orderCount.pendingOrders.toString(),
                                  28,
                                  isPendingSelected
                                      ? Colors.white
                                      : Color.fromRGBO(230, 154, 0, 1),
                                  FontWeight.w600,
                                  1),
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: isPendingSelected ? appColor : Colors.white,
                          shape: BoxShape.rectangle,
                          boxShadow: [getdefaultShadow()]),
                      height: Device.screenWidth / 4.8,
                      width: Device.screenWidth / 3.4,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isRejectedSelected = true;
                        isPendingSelected = false;
                        isDeliveredSelected = false;
                      });
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          setCustomFont(
                              "Rejected Order",
                              13,
                              isRejectedSelected
                                  ? Colors.white
                                  : textBlackColor,
                              FontWeight.w400,
                              1),
                          SizedBox(
                            height: 10,
                          ),
                          isCountLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: setButtonIndicator(
                                      3, Color.fromRGBO(255, 0, 0, 1)))
                              : setCustomFont(
                                  orderCount == null
                                      ? ""
                                      : orderCount.rejectedOrders.toString(),
                                  28,
                                  isRejectedSelected
                                      ? Colors.white
                                      : Color.fromRGBO(255, 0, 0, 1),
                                  FontWeight.w600,
                                  1),
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: isRejectedSelected ? appColor : Colors.white,
                          shape: BoxShape.rectangle,
                          boxShadow: [getdefaultShadow()]),
                      height: Device.screenWidth / 4.8,
                      width: Device.screenWidth / 3.4,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              (isDeliveredSelected && isDeliveredLoading)
                  ? Container(
                      height: MediaQuery.of(context).size.height * .50,
                      child: Center(child: setButtonIndicator(2, appColor)),
                    )
                  : (isPendingSelected && isPendingLoading)
                      ? Container(
                          height: MediaQuery.of(context).size.height * .50,
                          child: Center(child: setButtonIndicator(2, appColor)),
                        )
                      : (isRejectedSelected && isRejectedLoading)
                          ? Container(
                              height: MediaQuery.of(context).size.height * .50,
                              child: Center(
                                  child: setButtonIndicator(2, appColor)),
                            )
                          : Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                shrinkWrap: false,
                                itemCount: isDeliveredSelected
                                    ? arrDeliveredOrderList.length
                                    : isPendingSelected
                                        ? arrPandingOrderList.length
                                        : arrRejectedOrderList.length,
                                itemBuilder: (context, position) {
                                  return orderCount == null
                                      ? Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.50,
                                          child: Center(
                                              child: setButtonIndicator(
                                                  2, appColor)),
                                        )
                                      : isDeliveredSelected
                                          ? (orderCount.deliveredOrders == 0)
                                              ? Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .50,
                                                  child: Center(
                                                    child: setCustomFont(
                                                        "No data found",
                                                        15,
                                                        Colors.grey,
                                                        FontWeight.w400,
                                                        1.5),
                                                  ),
                                                )
                                              : DeliveredOrderCell(
                                                  objOrder:
                                                      arrDeliveredOrderList[
                                                          position],
                                                  isFromNotification: false)
                                          : isRejectedSelected
                                              ? (orderCount.rejectedOrders == 0)
                                                  ? Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .50,
                                                      child: Center(
                                                        child: setCustomFont(
                                                            "No data found",
                                                            15,
                                                            Colors.grey,
                                                            FontWeight.w400,
                                                            1.5),
                                                      ),
                                                    )
                                                  : RejectedOrderCell(
                                                      objOrder:
                                                          arrRejectedOrderList[
                                                              position])
                                              : (orderCount.pendingOrders == 0)
                                                  ? Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .50,
                                                      child: Center(
                                                        child: setCustomFont(
                                                            "No data found",
                                                            15,
                                                            Colors.grey,
                                                            FontWeight.w400,
                                                            1.5),
                                                      ),
                                                    )
                                                  : OrderCell(
                                                      objOrder:
                                                          arrPandingOrderList[
                                                              position],
                                                    );
                                },
                              ),
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
    );
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
}
