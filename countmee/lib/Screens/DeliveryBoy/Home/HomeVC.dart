import 'dart:convert';

import 'package:countmee/Model/OrderCountModel.dart';
import 'package:countmee/Model/PandingDataModel.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/DeliveredOrderCell.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/OrderDetailVC.dart';

import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

/*
Title : HomeVC
Purpose: HomeVC
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class HomeVC extends StatefulWidget {
  final orderId;

  const HomeVC({
    Key key,
    this.orderId,
  }) : super(key: key);

  @override
  _HomeVCState createState() => _HomeVCState();
}

class _HomeVCState extends State<HomeVC> {
  OrderCountModel orderCount;
  var isCountLoading = false;
  List<PandingDataModel> arrDeliveredOrderList =
      List.from([PandingDataModel()]);
  var isDeliveredLoading = false;
  var isLoading = false;
  PandingDataModel orderDetail;
  bool isFromNotification = false;
  bool isAcceptLoading = false;
  bool isRejectLoading = false;
  double totalCommission;
  var orderId;
  var collectionId;
  Position _currentPosition;
  String _currentAddress;
  bool consumedOnce = true;

  @override
  void initState() {
    super.initState();

    checkConnection(context);

    getOrderCount();
    // getPastOrder();
    getDiliveredOrder();
    // getOrderDetail();
    getCommissionDetail();

    // NotificationManger.init(context: context);

    if (isConsumedOnce == false) {
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage message) {
        print("closed app notification");
        print(message.data);
        Map valueMap = json.decode(message.data['moredata']);

        if (message != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailVC(
                orderId: valueMap['package_id'],
                collectionId: message.data['collection_center_id'],
              ),
              fullscreenDialog: false,
            ),
          );
        }
      });
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        print('onMessage.....');
        print(message.data['package_id']);
        print("coll id : ${message.data['collection_center_id']}");
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

  //   displayBottomSheet(){
  //   showBottomSheet(
  //       context: context,
  //       builder: (context) => Container(
  //         width: double.infinity,
  //         height: MediaQuery.of(context).size.height*0.1,
  //       ));
  // }

  getCommissionDetail() {
    setState(() {
      isLoading = true;
    });
    postDataRequestWithToken(commissionListApi, null, context).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value[kStatusCode] == 200) {
        setState(() {
          totalCommission =
              double.parse((value['total_commission']).toString());
          // .roundToDouble();
        });
      } else {
        showCustomToast(value[kMessage], context);
      }
    });
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
        } else {
          showCustomToast(value[kMessage].toString(), context);
        }
      } else {
        showCustomToast(value.toString(), context);
      }
    });
  }

  getPastOrder() {
    postAPIRequestWithToken(getPastOrderAPI, null, context).then((value) {
      if (value is Map) {
        if (value[kStatusCode] == 200) {
          if (value[kData] is List) {
          } else {
            showCustomToast(value[kMessage].toString(), context);
          }
        } else {
          showCustomToast(value[kMessage].toString(), context);
        }
      } else {
        showCustomToast(value.toString(), context);
      }
    });
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
          print("$value");
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
    var arrData = value
        .map<PandingDataModel>((json) => PandingDataModel.fromJson(json))
        .toList();
    arrDeliveredOrderList = arrData;
    print("${arrDeliveredOrderList.length}");
  }

  getOrderDetail() {
    setState(() {
      isLoading = true;
    });
    FormData formData = FormData.fromMap({
      "order_id": widget.orderId,
    });
    postDataRequestWithToken(getOrderDetailAPI, formData, context)
        .then((value) {
      if (value[kStatusCode] == 200) {
        if (value[kData] is Map) {
          setState(() {
            print("value[kData] = ${value[kData]}");
            orderDetail = PandingDataModel.fromJson(value[kData]);
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

  // getUserProfile() {
  //   postAPIRequestWithToken(getProfileAPI, null, context).then((value) {
  //     if (value is Map) {
  //       if (value[kStatusCode] == 200) {
  //         UserModel user = UserModel.fromJson(value[kData]);
  //         setState(() {
  //           userObj = user;
  //         });
  //         setUserData();
  //       } else {
  //         showCustomToast(value[kMessage], context);
  //       }
  //     } else {
  //       showCustomToast(value, context);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if (isConnected == true) {
      setState(() {
        getOrderCount();
        getDiliveredOrder();
        getCommissionDetail();
        isConnected = false;
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    setCustomFont(
                      "Total Commission",
                      14,
                      textBlackColor,
                      FontWeight.w400,
                      1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    setCustomFont(
                        totalCommission != null
                            ? "₹${totalCommission.toStringAsFixed(2)}"
                            : "₹0.00",
                        28,
                        appColor,
                        FontWeight.w600,
                        1),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Map sytListMap = Map();
                    sytListMap["OpenSideMenu"] = true;
                    Observable().notifyObservers([
                      "_TabbarVCState",
                    ], map: sytListMap);
                  },
                  child: ClipOval(
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey,
                      child: setProfileImage(userObj.image),
                    ),
                  ),
                  // ClipOval(
                  //   child:
                  //       setProfileImageWithSize(userObj.image, 50, 50),
                  // ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
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
                    changetabnotifier();
                    Map sytListMap = Map();
                    sytListMap["ViewDOrder"] = true;
                    Observable().notifyObservers([
                      "_TabbarVCState",
                    ], map: sytListMap);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        setCustomFont("Delivered Order", 13, textBlackColor,
                            FontWeight.w400, 1),
                        SizedBox(
                          height: 10,
                        ),
                        isCountLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: setButtonIndicator(
                                    3, Color.fromRGBO(2, 167, 7, 1)),
                              )
                            : setCustomFont(
                                orderCount == null
                                    ? ""
                                    : orderCount.deliveredOrders.toString(),
                                28,
                                Color.fromRGBO(2, 167, 7, 1),
                                FontWeight.w600,
                                1),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [getdefaultShadow()]),
                    height: Device.screenWidth / 4.5,
                    width: Device.screenWidth / 3.4,
                  ),
                ),
                InkWell(
                  onTap: () {
                    changetabnotifier();
                    Map sytListMap = Map();
                    sytListMap["ViewPOrder"] = true;
                    Observable().notifyObservers(
                      [
                        "_TabbarVCState",
                      ],
                      map: sytListMap,
                    );
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        setCustomFont(
                          "Pending Order",
                          13,
                          textBlackColor,
                          FontWeight.w400,
                          1,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        isCountLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: setButtonIndicator(
                                  3,
                                  Color.fromRGBO(230, 154, 0, 1),
                                ))
                            : setCustomFont(
                                orderCount == null
                                    ? ""
                                    : orderCount.pendingOrders.toString(),
                                28,
                                Color.fromRGBO(230, 154, 0, 1),
                                FontWeight.w600,
                                1),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [getdefaultShadow()]),
                    height: Device.screenWidth / 4.5,
                    width: Device.screenWidth / 3.4,
                  ),
                ),
                InkWell(
                  onTap: () {
                    changetabnotifier();

                    Map sytListMap = Map();
                    sytListMap["ViewROrder"] = true;
                    Observable().notifyObservers([
                      "_TabbarVCState",
                    ], map: sytListMap);
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        setCustomFont(
                          "Rejected Order",
                          13,
                          textBlackColor,
                          FontWeight.w400,
                          1,
                        ),
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
                                Color.fromRGBO(255, 0, 0, 1),
                                FontWeight.w600,
                                1),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [getdefaultShadow()]),
                    height: Device.screenWidth / 4.5,
                    width: Device.screenWidth / 3.4,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                setCustomFont(
                    "Past Orders", 16, textBlackColor, FontWeight.w600, 1),
                Spacer(),
                InkWell(
                    onTap: () {
                      changetabnotifier();
                      Map sytListMap = Map();
                      sytListMap["ViewDOrder"] = true;
                      Observable().notifyObservers([
                        "_TabbarVCState",
                      ], map: sytListMap);
                    },
                    child: Container(
                      child: setCustomFont(
                          "View All", 12, appColor, FontWeight.w500, 1),
                      height: 25,
                      alignment: Alignment.center,
                    )),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
            isDeliveredLoading
                ? Container(
                    height: MediaQuery.of(context).size.height * .50,
                    child: Center(
                      child: setButtonIndicator(2, appColor),
                    ))
                : (orderCount == null)
                    ? Container(
                        height: MediaQuery.of(context).size.height * .50,
                        child: Center(
                          child: setCustomFont(
                            "No data found",
                            15,
                            Colors.grey,
                            FontWeight.w400,
                            1.5,
                          ),
                        ),
                      )
                    : (orderCount.deliveredOrders == 0)
                        ? Container(
                            height: MediaQuery.of(context).size.height * .50,
                            child: Center(
                              child: setCustomFont(
                                "No data found",
                                15,
                                Colors.grey,
                                FontWeight.w400,
                                1.5,
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              // physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: false,
                              itemCount: arrDeliveredOrderList.length,
                              itemBuilder: (context, position) {
                                isFromNotification = false;
                                return DeliveredOrderCell(
                                  objOrder: arrDeliveredOrderList[position],
                                  isFromNotification: isFromNotification,
                                );
                              },
                            ),
                          ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: orderId != null
            //       ? Container(
            //           child: _newTaskModalBottomSheet(context),
            //         )
            //       : Container(),
            // ),
          ],
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

  changetabnotifier() {
    Map sytListMap = Map();
    sytListMap["ViewOrderTab"] = true;
    Observable().notifyObservers(
      [
        "_TabbarVCState",
      ],
      map: sytListMap,
    );
  }

// void _newTaskModalBottomSheet(context) {
//   getCalculated(double value) {
//     double height = MediaQuery.of(context).size.height;
//     if (height >= 800.0 && height <= 895.0) {
//       // For devices Iphone 10 range. For android hd.
//       return 667.0 * (value / 568.0);
//     } else if (height >= 896.0) {
//       // For XR and XS max.
//       return 736.0 * (value / 568.0);
//     } else {
//       // For other.
//       return height * (value / 568.0);
//     }
//   }
//
//   showModalBottomSheet(
//       backgroundColor: Colors.transparent,
//       context: context,
//       builder: (BuildContext context) {
//         isFromNotification = true;
//         return StatefulBuilder(builder: (context, StateSetter state) {
//           return Container(
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(15),
//                     topLeft: Radius.circular(15)),
//                 color: Colors.white),
//             height: WidgetsBinding.instance.window.viewInsets.bottom > 0.0
//                 ? getCalculated(450)
//                 : getCalculated(300),
//             child: Center(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 20,
//                   ),
//                   DeliveredOrderCell(
//                     objOrder: orderDetail,
//                     isFromNotification: isFromNotification,
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: appColor,
//                                 width: 1.5,
//                               ),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(5))),
//                           height: 50,
//                           width: 150,
//                           child: isRejectLoading
//                               ? setbuttonWithChild(
//                                   setCustomFont("Reject", 16, appColor,
//                                       FontWeight.w400, 1),
//                                   () {},
//                                   Colors.transparent,
//                                   5)
//                               : setbuttonWithChild(
//                                   setCustomFont("Reject", 16, appColor,
//                                       FontWeight.w400, 1), () async {
//                                   FormData formData;
//                                   state(() {
//                                     isRejectLoading = true;
//                                   });
//                                   formData = FormData.fromMap({
//                                     "package_id": orderDetail
//                                         .packageDetail[0].packageId,
//                                   });
//                                   postDataRequestWithToken(
//                                           rejectOrderAPI, formData, context)
//                                       .then((value) {
//                                     if (value is Map) {
//                                       AlertMessage(
//                                         "You have rejected this order.",
//                                         context,
//                                         () {
//                                           Navigator.of(context).pop(true);
//                                           Navigator.of(context).pop(true);
//                                           changetabnotifier();
//                                           Map sytListMap = Map();
//                                           sytListMap["ViewROrder"] = true;
//                                           Observable().notifyObservers([
//                                             "_TabbarVCState",
//                                           ], map: sytListMap);
//                                         },
//                                       );
//                                     } else {
//                                       showCustomToast(
//                                           value.toString(), context);
//                                     }
//                                   });
//                                 }, Colors.transparent, 5),
//                         ),
//                         SizedBox(
//                           width: 25,
//                         ),
//                         Container(
//                           height: 50,
//                           width: 150,
//                           child: isAcceptLoading
//                               ? setbuttonWithChild(
//                                   setCustomFont("Accept", 16, Colors.white,
//                                       FontWeight.w400, 1),
//                                   () {},
//                                   appColor,
//                                   5)
//                               : setbuttonWithChild(
//                                   setCustomFont("Accept", 16, Colors.white,
//                                       FontWeight.w400, 1), () async {
//                                   FormData formData;
//                                   state(() {
//                                     isAcceptLoading = true;
//                                   });
//                                   formData = FormData.fromMap({
//                                     "package_id": orderDetail
//                                         .packageDetail[0].packageId,
//                                     "pickup_address":
//                                         orderDetail.pickupLocation,
//                                     "pickup_latitude":
//                                         orderDetail.pickupLatitude,
//                                     "pickup_longitude":
//                                         orderDetail.pickupLongitude,
//                                     "drop_address": orderDetail.dropLocation,
//                                     "drop_latitude": orderDetail.dropLatitude,
//                                     "drop_longitude":
//                                         orderDetail.dropLongitude,
//                                     "images": orderDetail.packageImages,
//                                   });
//                                   postDataRequestWithToken(
//                                           acceptOrderAPI, formData, context)
//                                       .then((value) {
//                                     if (value is Map) {
//                                       AlertMessage(
//                                         "You have accepted this order.",
//                                         context,
//                                         () {
//                                           Navigator.of(context).pop(true);
//                                           Navigator.of(context).pop(true);
//                                           changetabnotifier();
//
//                                           Map sytListMap = Map();
//                                           sytListMap["ViewPOrder"] = true;
//                                           Observable().notifyObservers([
//                                             "_TabbarVCState",
//                                           ], map: sytListMap);
//                                         },
//                                       );
//                                     } else {
//                                       showCustomToast(
//                                           value.toString(), context);
//                                     }
//                                   });
//                                 }, appColor, 5),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//       });
// }
}
