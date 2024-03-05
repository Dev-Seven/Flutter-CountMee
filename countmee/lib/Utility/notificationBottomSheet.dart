// import 'package:countmee/Model/PandingDataModel.dart';
// import 'package:countmee/Screens/DeliveryBoy/Order/DeliveredOrderCell.dart';
// import 'package:countmee/Utility/Constant.dart';
// import 'package:countmee/Utility/Global.dart';
// import 'package:data_connection_checker/data_connection_checker.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_observer/Observable.dart';
// import 'APIManager.dart';

// /*
// Title : NotificationBottomSheet 
// Purpose: NotificationBottomSheet
// Created By : Kalpesh Khandla
// Created On : N/A
// Last Edited By : 3 Feb 2022
// */

// class NotificationBottomSheet extends StatefulWidget {
//   final orderId;
//   final collectionId;

//   const NotificationBottomSheet({
//     Key key,
//     this.orderId,
//     this.collectionId,
//   }) : super(key: key);

//   @override
//   _NotificationBottomSheetState createState() =>
//       _NotificationBottomSheetState();
// }

// class _NotificationBottomSheetState extends State<NotificationBottomSheet> {
//   var isLoading = false;
//   PandingDataModel orderDetail;
//   bool isFromNotification = true;
//   bool isAcceptLoading = false;
//   bool isRejectLoading = false;
//   String address;
//   var addressLat;
//   var addressLng;

//   @override
//   void initState() {
//     super.initState();
//     getOrderDetail();
//     if (widget.collectionId != null) {
//       getCollectionDetail();
//     }
//   }

//   getCollectionDetail() {
//     setState(() {
//       isLoading = true;
//     });

//     FormData formData = FormData.fromMap({
//       "collection_center_id": widget.collectionId,
//     });

//     afterDelay(1, () {
//       postDataRequestWithToken(collectionCenterDetailsAPI, formData, context)
//           .then((value) {
//         if (value[kData] is Map) {
//           setState(() {
//             address = value[kData]['address'];
//             addressLat = value[kData]['latitude'];
//             addressLng = value[kData]['longitude'];
//           });
//           setState(() {
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//           showCustomToast(value[kMessage], context);
//         }
//       });
//     });
//   }

//   getOrderDetail() {
//     setState(() {
//       isLoading = true;
//     });
//     FormData formData = FormData.fromMap({
//       "order_id": widget.orderId,
//     });
//     postDataRequestWithToken(getOrderDetailAPI, formData, context)
//         .then((value) {
//       setState(() {
//         isLoading = false;
//       });
//       if (value[kStatusCode] == 200) {
//         if (value[kData] is Map) {
//           setState(() {
//             orderDetail = PandingDataModel.fromJson(value[kData]);
//           });

//           print("ORDER DETAIL API : $orderDetail");
//         } else {
//           showCustomToast(value[kMessage], context);
//         }
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         showCustomToast(value[kMessage], context);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.45,
//       child: Scaffold(
//           body: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(
//               topRight: Radius.circular(15),
//               topLeft: Radius.circular(15),
//             ),
//             color: Colors.white),
//         height: WidgetsBinding.instance.window.viewInsets.bottom > 0.0
//             ? getCalculated(450)
//             : getCalculated(300),
//         child: Center(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 20,
//               ),
//               DeliveredOrderCell(
//                 objOrder: orderDetail,
//                 isFromNotification: isFromNotification,
//                 address: address,
//                 addressLat: addressLat,
//                 addressLng: addressLng,
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Container(
//                 padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                       height: 50,
//                       width: 150,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: appColor,
//                           width: 1.5,
//                         ),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(5),
//                         ),
//                       ),
//                       child: setbuttonWithChild(
//                         isRejectLoading
//                             ? Container(
//                                 width: 30,
//                                 height: 30,
//                                 child: setButtonIndicator(3, appColor),
//                               )
//                             : setCustomFont(
//                                 "Reject",
//                                 16,
//                                 appColor,
//                                 FontWeight.w400,
//                                 1,
//                               ),
//                         () async {
//                           onOrderRejectTap();
//                         },
//                         Colors.transparent,
//                         5,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 25,
//                     ),
//                     Container(
//                       height: 50,
//                       width: 150,
//                       child: setbuttonWithChild(
//                           isAcceptLoading
//                               ? Container(
//                                   width: 30,
//                                   height: 30,
//                                   child: setButtonIndicator(3, Colors.white),
//                                 )
//                               : setCustomFont(
//                                   "Accept",
//                                   16,
//                                   Colors.white,
//                                   FontWeight.w400,
//                                   1,
//                                 ), () async {
//                         onOrderAcceptTap();
//                       }, appColor, 5),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       )),
//     );
//   }

//   onOrderAcceptTap() {
//     setState(() {
//       isLoading = true;
//     });
//     FormData formData;

//     formData = FormData.fromMap({
//       "package_id": orderDetail.packageDetail[0].packageId,
//       "pickup_address": orderDetail.pickupLocation,
//       "pickup_latitude": orderDetail.pickupLatitude,
//       "pickup_longitude": orderDetail.pickupLongitude,
//       "drop_address": orderDetail.dropLocation,
//       "drop_latitude": orderDetail.dropLatitude,
//       "drop_longitude": orderDetail.dropLongitude,
//       "images": orderDetail.packageImages,
//     });

//     if (connectionStatus == DataConnectionStatus.connected) {
//       postDataRequestWithToken(acceptOrderAPI, formData, context).then((value) {
//         print("ON ORDER ACCEPT : $value");
//         setState(() {
//           isLoading = false;
//         });
//         if (value is Map) {
//           AlertMessage(
//             "You have accepted this order.",
//             context,
//             () {
//               Navigator.of(context).pop(true);
//               // Navigator.pop(context);
//               onAcceptAlertTap();
//             },
//           );
//         } else {
//           print("Notification BOttomSheet");
//           Navigator.of(context).pop(true);
//           changetabnotifier();

//           Map sytListMap = Map();
//           sytListMap["ViewPOrder"] = true;
//           Observable().notifyObservers([
//             "_TabbarVCState",
//           ], map: sytListMap);
//           showCustomToast(value.toString(), context);
//         }
//       });
//     } else {
//       showCustomToast("Please check your internet connection", context);
//     }
//   }

//   onOrderRejectTap() async {
//     setState(() {
//       isLoading = true;
//     });

//     FormData formData;

//     formData = FormData.fromMap({
//       "package_id": orderDetail.packageDetail[0].packageId,
//     });

//     if (connectionStatus == DataConnectionStatus.connected) {
//       postDataRequestWithToken(rejectOrderAPI, formData, context).then((value) {
//         setState(() {
//           isLoading = false;
//         });
//         if (value is Map) {
//           AlertMessage(
//             "You have rejected this order.",
//             context,
//             () {
//               Navigator.pop(context);
//               onRejectedOrderAlertTap();
//             },
//           );
//         } else {
//           // setState(() {
//           //   state(() {
//           //     isRejectLoading = false;
//           //   });
//           // });

//           Navigator.of(context).pop(true);
//           changetabnotifier();
//           Map sytListMap = Map();
//           sytListMap["ViewROrder"] = true;
//           Observable().notifyObservers([
//             "_TabbarVCState",
//           ], map: sytListMap);
//           showCustomToast(value.toString(), context);
//         }
//       });
//     } else {
//       // setState(() {
//       //   isRejectLoading = false;
//       // });
//       showCustomToast("Please check your internet connection", context);
//     }
//   }

//   onRejectedOrderAlertTap() {
//     Navigator.pop(context);

//     // Navigator.of(context).pop(true);
//     // Navigator.of(context).pop(true);
//     changetabnotifier();
//     Map sytListMap = Map();
//     sytListMap["ViewROrder"] = true;
//     Observable().notifyObservers([
//       "_TabbarVCState",
//     ], map: sytListMap);
//   }

//   onAcceptAlertTap() {
//     Navigator.pop(context);

//     changetabnotifier();

//     Map sytListMap = Map();

//     sytListMap["ViewPOrder"] = true;

//     Observable().notifyObservers(
//       [
//         "_TabbarVCState",
//       ],
//       map: sytListMap,
//     );
//   }

//   changetabnotifier() {
//     Map sytListMap = Map();
//     sytListMap["ViewOrderTab"] = true;
//     Observable().notifyObservers(
//       [
//         "_TabbarVCState",
//       ],
//       map: sytListMap,
//     );
//   }
// }
