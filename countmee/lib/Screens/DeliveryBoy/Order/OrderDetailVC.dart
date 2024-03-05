import 'package:countmee/Model/PandingDataModel.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/AcceptedOrder.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/MapVC.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/UploadImages.dart';
import 'package:countmee/Screens/DeliveryBoy/TabBar/TabBarVC.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:countmee/Utility/order_status.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';

/*
Title : OrderDetailVC
Purpose: OrderDetailVC
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class OrderDetailVC extends StatefulWidget {
  final orderId;
  final collectionId;
  final address;
  final addressLat;
  final addressLng;

  const OrderDetailVC(
      {Key key,
      this.orderId,
      this.collectionId,
      this.address,
      this.addressLat,
      this.addressLng})
      : super(key: key);

  @override
  _OrderDetailVCState createState() => _OrderDetailVCState();
}

class _OrderDetailVCState extends State<OrderDetailVC> {
  bool _isChecked = false;
  var txtStorageController = TextEditingController();
  List storageName = [];
  List storageAddress = [];
  List storageId = [];
  List storage = [];
  var selectedStorage = "";
  var isLoading = false;
  int id;
  var isAcceptLoading = false;
  var isRejectLoading = false;
  PandingDataModel orderDetail;
  String dateFormat = "";
  String orderDate = "";
  bool isStorage = true;
  String address = "";
  var addressLat;
  var addressLng;

  @override
  void initState() {
    super.initState();
    getOrderDetail();
    getStorageDetail();
    address = widget.address;
    addressLat = widget.addressLat;
    addressLng = widget.addressLng;
    txtStorageController.text = "Select Storage";
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
            orderDetail = PandingDataModel.fromJson(value[kData]);
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
    if (txtStorageController.text == "") {
      txtStorageController.text = "Select Storage";
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: setCustomFont(
          "Order Details",
          20,
          textBlackColor,
          FontWeight.w600,
          1,
        ),
        leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
          Navigator.pop(context);
        }, Colors.transparent, Colors.transparent, 0),
      ),
      body: isLoading && orderDetail == null
          ? Center(child: setButtonIndicator(2, appColor))
          : orderDetail.packageDetail == null &&
                  orderDetail.packageDetail[0] == null
              ? Center(child: setButtonIndicator(2, appColor))
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: [
                                Spacer(),
                                setCustomFont("Order No. : ", 16,
                                    textBlackColor, FontWeight.w600, 1),
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
                              boxShadow: [getShadow(0, 0, 15)],
                            ),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    setCustomFont("Address Details", 16,
                                        textBlackColor, FontWeight.w600, 1),
                                    InkWell(
                                        onTap: () {
                                          MapUtils.openMap(
                                            double.parse(
                                                widget.addressLat == null
                                                    ? orderDetail.pickupLatitude
                                                    : addressLat),
                                            double.parse(widget.addressLng ==
                                                    null
                                                ? orderDetail.pickupLongitude
                                                : addressLng),
                                            double.parse(
                                                orderDetail.dropLatitude != null
                                                    ? orderDetail.dropLatitude
                                                    : ""),
                                            double.parse(
                                                orderDetail.dropLongitude !=
                                                        null
                                                    ? orderDetail.dropLongitude
                                                    : ""),
                                          );

                                          // pushToViewController(
                                          //     context,
                                          //     MapVC(
                                          //       pickupLocation: widget
                                          //                   .address ==
                                          //               null
                                          //           ? orderDetail.pickupLocation
                                          //           : address != ""
                                          //               ? address
                                          //               : "",
                                          //       dropLocation: orderDetail
                                          //                   .dropLocation !=
                                          //               null
                                          //           ? orderDetail.dropLocation
                                          //           : "",
                                          //       pickupLat: widget.addressLat ==
                                          //               null
                                          //           ? orderDetail.pickupLatitude
                                          //           : addressLat,
                                          //       pickupLng:
                                          //           widget.addressLng == null
                                          //               ? orderDetail
                                          //                   .pickupLongitude
                                          //               : addressLng,
                                          //       dropLat: orderDetail
                                          //                   .dropLatitude !=
                                          //               null
                                          //           ? orderDetail.dropLatitude
                                          //           : "",
                                          //       dropLng: orderDetail
                                          //                   .dropLongitude !=
                                          //               null
                                          //           ? orderDetail.dropLongitude
                                          //           : "",
                                          //       // mobileNo: widget.objOrder.users[1]
                                          //       //     .mobileNumber1,
                                          //     ),
                                          //     () {});
                                        },
                                        child: Image.asset(
                                            "assets/images/map.png",
                                            height: 30,
                                            width: 30))
                                  ],
                                ),
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
                                      SizedBox(
                                        width: 15,
                                      ),
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
                                                widget.address == null
                                                    ? orderDetail.pickupLocation
                                                    : address != ""
                                                        ? address
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
                                              1,
                                            ),
                                            SizedBox(
                                              height: 9,
                                            ),
                                            selectedStorage == ""
                                                ? setCustomFontWithAlignment(
                                                    orderDetail.dropLocation !=
                                                            null
                                                        ? orderDetail
                                                            .dropLocation
                                                        : "",
                                                    15,
                                                    Color.fromRGBO(
                                                        287, 287, 287, 1),
                                                    FontWeight.w500,
                                                    1,
                                                    TextAlign.left,
                                                  )
                                                : setCustomFontWithAlignment(
                                                    selectedStorage,
                                                    15,
                                                    Color.fromRGBO(
                                                        287, 287, 287, 1),
                                                    FontWeight.w500,
                                                    1,
                                                    TextAlign.left,
                                                  ),
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
                                setCustomFont(
                                  "Product Details",
                                  16,
                                  textBlackColor,
                                  FontWeight.w600,
                                  1,
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                                Divider(
                                  height: 1,
                                  color: Color.fromRGBO(226, 226, 226, 1),
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 14,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            child: setCustomFont(
                                                orderDetail.packageDetail[0]
                                                            .productDesc ==
                                                        'Others'
                                                    ? orderDetail
                                                        .packageDetail[0]
                                                        .otherProductDesc
                                                    : orderDetail
                                                            .packageDetail[0]
                                                            .productDesc ??
                                                        "",
                                                14,
                                                textBlackColor,
                                                FontWeight.w400,
                                                1),
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
                                                    packageDetails: orderDetail
                                                        .packageDetail,
                                                    packageImages: orderDetail
                                                        .packageImages,
                                                  ),
                                                  fullscreenDialog: false,
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 10, 0),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      235, 235, 235, 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8))),
                                              height: 20,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.remove_red_eye,
                                                      size: 15),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: 8,
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
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                        child: setCustomFont(
                                            orderDetail
                                                    .packageDetail[0].weight ??
                                                "",
                                            14,
                                            textBlackColor,
                                            FontWeight.w400,
                                            1),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                        child: setCustomFontWithAlignment(
                                          orderDetail.packageDetail[0]
                                                  .handleProduct ??
                                              "",
                                          14,
                                          textBlackColor,
                                          FontWeight.w400,
                                          1,
                                          TextAlign.left,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
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
                              boxShadow: [getShadow(0, 0, 15)],
                            ),
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
                                setCustomFont(
                                  "Mode of Transport",
                                  16,
                                  textBlackColor,
                                  FontWeight.w600,
                                  1,
                                ),
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
                              padding: EdgeInsets.fromLTRB(8, 0, 10, 20),
                              child: orderDetail.isRequestDrop.toString() != '0'
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: appColor,
                                                width: 1.5,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          height: 50,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              230,
                                          child: setbuttonWithChild(
                                              isRejectLoading
                                                  ? Container(
                                                      width: 30,
                                                      height: 30,
                                                      child: setButtonIndicator(
                                                          3, appColor),
                                                    )
                                                  : setCustomFont(
                                                      "Reject",
                                                      16,
                                                      appColor,
                                                      FontWeight.w400,
                                                      1,
                                                    ), () async {
                                            FormData formData;
                                            setState(() {
                                              isRejectLoading = true;
                                            });
                                            formData = FormData.fromMap({
                                              "package_id": orderDetail
                                                  .packageDetail[0].packageId,
                                            });

                                            if (connectionStatus ==
                                                DataConnectionStatus
                                                    .connected) {
                                              postDataRequestWithToken(
                                                      rejectOrderAPI,
                                                      formData,
                                                      context)
                                                  .then((value) {
                                                if (value is Map) {
                                                  setState(() {
                                                    isRejectLoading = false;
                                                  });
                                                  AlertMessage(
                                                    "You have rejected this order.",
                                                    context,
                                                    () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                      Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      TabbarVC(),
                                                              fullscreenDialog:
                                                                  false),
                                                          (route) => false);
                                                    },
                                                  );
                                                } else {
                                                  showCustomToast(
                                                      value.toString(),
                                                      context);

                                                  setState(() {
                                                    isRejectLoading = false;
                                                  });
                                                }
                                              });
                                            } else {
                                              setState(() {
                                                isRejectLoading = false;
                                              });
                                              showCustomToast(
                                                  "Please check your internet connection",
                                                  context);
                                            }
                                          }, Colors.transparent,
                                              Colors.transparent, 5),
                                        ),
                                        Spacer(),
                                        Container(
                                          height: 50,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              230,
                                          child: setbuttonWithChild(
                                            isAcceptLoading
                                                ? Container(
                                                    width: 30,
                                                    height: 30,
                                                    child: setButtonIndicator(
                                                        3, Colors.white),
                                                  )
                                                : setCustomFont(
                                                    "Accept",
                                                    16,
                                                    Colors.white,
                                                    FontWeight.w400,
                                                    1,
                                                  ),
                                            () async {
                                              FormData formData;
                                              setState(() {
                                                isAcceptLoading = true;
                                              });
                                              print(id);
                                              String dropOffLocation;
                                              var selectedLat;
                                              var selectedLng;
                                              String pickUpLocation;
                                              String pickUpLat;
                                              String pickUpLng;
                                              if (_isChecked == true &&
                                                  selectedStorage.isEmpty) {
                                                print(selectedStorage);
                                                showCustomToast(
                                                    "Please select storage!",
                                                    context);
                                                setState(() {
                                                  isAcceptLoading = false;
                                                });
                                              } else {
                                                if (address != null) {
                                                  pickUpLocation = address;
                                                  pickUpLat = addressLat;
                                                  pickUpLng = addressLng;
                                                } else {
                                                  pickUpLocation = orderDetail
                                                      .pickupLocation;
                                                  pickUpLat = orderDetail
                                                      .pickupLatitude;
                                                  pickUpLng = orderDetail
                                                      .pickupLongitude;
                                                }

                                                if (selectedStorage != "") {
                                                  dropOffLocation =
                                                      selectedStorage;

                                                  List<Location> add =
                                                      await locationFromAddress(
                                                          selectedStorage);
                                                  selectedLat =
                                                      add.first.latitude;
                                                  selectedLng =
                                                      add.first.longitude;
                                                } else {
                                                  dropOffLocation =
                                                      orderDetail.dropLocation;
                                                  selectedLat =
                                                      orderDetail.dropLatitude;
                                                  selectedLng =
                                                      orderDetail.dropLongitude;
                                                }

                                                formData = FormData.fromMap({
                                                  "package_id": orderDetail
                                                      .packageDetail[0]
                                                      .packageId,
                                                  "pickup_address":
                                                      pickUpLocation,
                                                  "pickup_latitude": pickUpLat,
                                                  "pickup_longitude": pickUpLng,
                                                  "drop_address":
                                                      dropOffLocation,
                                                  "drop_latitude": selectedLat,
                                                  "drop_longitude": selectedLng,
                                                  "images":
                                                      orderDetail.packageImages,
                                                  "collection_center_id": id
                                                });
                                                print(formData.fields);

                                                if (connectionStatus ==
                                                    DataConnectionStatus
                                                        .connected) {
                                                  await postDataRequestWithToken(
                                                          acceptOrderAPI,
                                                          formData,
                                                          context)
                                                      .then((value) {
                                                    if (value is Map) {
                                                      setState(() {
                                                        isAcceptLoading = false;
                                                      });
                                                      print(value[kStatus]);
                                                      if (value[kStatusCode] ==
                                                          101) {
                                                        showCustomToast(
                                                          value[kMessage],
                                                          context,
                                                        );
                                                      } else if (value[
                                                              kStatusCode] ==
                                                          200) {
                                                        AlertMessage(
                                                          "You have accepted this order.",
                                                          context,
                                                          () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false);
                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          TabbarVC(),
                                                                  fullscreenDialog:
                                                                      false),
                                                              (route) => false,
                                                            );
                                                          },
                                                        );
                                                      }
                                                    } else {
                                                      setState(() {
                                                        isAcceptLoading = false;
                                                      });
                                                      showCustomToast(
                                                        value.toString(),
                                                        context,
                                                      );
                                                    }
                                                  });
                                                } else {
                                                  setState(() {
                                                    isAcceptLoading = false;
                                                  });
                                                  showCustomToast(
                                                      "Please check your internet connection",
                                                      context);
                                                }
                                              }
                                            },
                                            appColor,
                                            Colors.purple[900],
                                            5,
                                          ),
                                        )
                                      ],
                                    )),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  changetabnotifier() {
    Map sytListMap = Map();
    sytListMap["ViewOrderTab"] = true;
    Observable().notifyObservers([
      "_TabbarVCState",
    ], map: sytListMap);
  }

  showStoragePopup() {
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
                      child: Container(
                        child: setCustomFont("Storage Centers", 16,
                            textBlackColor, FontWeight.w600, 1),
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
                                txtStorageController.text =
                                    (storageAddress[position]);
                                id = storageId[position];
                                selectedStorage = storageAddress[position];

                                Navigator.pop(context);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 12),
                                  Container(
                                    child: setCustomFont(storageName[position],
                                        16, textBlackColor, FontWeight.w600, 1),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          .80,
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
                ),
              )),
        );
      },
    );
  }
}
