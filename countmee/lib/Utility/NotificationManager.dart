import 'package:countmee/Model/PandingDataModel.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/DeliveredOrderCell.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'Constant.dart';
import 'Global.dart';

/*
Title : NotificationManger 
Purpose: NotificationManger
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class NotificationManger {
  static BuildContext _context;

  static init({@required BuildContext context}) {
    _context = context;
  }

  //this method used when notification come and app is closed or in background and
  // user click on it, i will left it empty for you
  // static handleDataMsg(Map<String, dynamic> data) {

  // }

  //this our method called when notification come and app is foreground
  static handleNotificationMsg(var message) {
    debugPrint("from mangger  $message");

    // final dynamic data = message['data'];

    //as ex we have some data json for every notification to know how to handle that
    //let say showDialog here so fire some action
    _showDialog(data: message);
  }

  static _showDialog({@required var data}) {
    var isLoading = false;
    PandingDataModel orderDetail;
    bool isFromNotification = true;
    bool isAcceptLoading = false;
    bool isRejectLoading = false;
    //you can use data map also to know what must show in MyDialog

    // getOrderDetail() {
    // setState(() {
    //   isLoading = true;
    // });
    FormData formData = FormData.fromMap({
      // "order_id": 160,
      "order_id": data,
    });
    postDataRequestWithToken(getOrderDetailAPI, formData, _context)
        .then((value) {
      if (value[kStatusCode] == 200) {
        if (value[kData] is Map) {
          // setState(() {

          orderDetail = PandingDataModel.fromJson(value[kData]);
          (_context as Element).markNeedsBuild();
          // });
          // setState(() {
          //   isLoading = false;
          // });
        } else {
          showCustomToast(value[kMessage], _context);
        }
      } else {
        // setState(() {
        //   isLoading = false;
        // });
        showCustomToast(value[kMessage], _context);
      }
    });
    // }

    showDialog(
        barrierDismissible: false,
        context: _context,
        builder: (_) => Scaffold(
              backgroundColor: Colors.black38,
              body: Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(12.0),
                        topRight: const Radius.circular(12.0),
                      )),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        DeliveredOrderCell(
                          objOrder: orderDetail,
                          isFromNotification: isFromNotification,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: appColor,
                                      width: 1.5,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                height: 50,
                                width: 150,
                                child: isRejectLoading
                                    ? setbuttonWithChild(
                                        setCustomFont("Reject", 16, appColor,
                                            FontWeight.w400, 1),
                                        () {},
                                        Colors.transparent,
                                        Colors.transparent,
                                        5)
                                    : setbuttonWithChild(
                                        setCustomFont("Reject", 16, appColor,
                                            FontWeight.w400, 1), () async {
                                        FormData formData;

                                        formData = FormData.fromMap({
                                          "package_id": orderDetail
                                              .packageDetail[0].packageId,
                                        });
                                        postDataRequestWithToken(rejectOrderAPI,
                                                formData, _context)
                                            .then((value) {
                                          if (value is Map) {
                                            AlertMessage(
                                              "You have rejected this order.",
                                              _context,
                                              () {
                                                Navigator.of(_context)
                                                    .pop(true);
                                                Navigator.of(_context)
                                                    .pop(true);
                                                Map sytListMap = Map();
                                                sytListMap["ViewOrderTab"] =
                                                    true;
                                                Observable().notifyObservers([
                                                  "_TabbarVCState",
                                                ], map: sytListMap);
                                                Map sytListMaps = Map();
                                                sytListMaps["ViewROrder"] =
                                                    true;
                                                Observable().notifyObservers([
                                                  "_TabbarVCState",
                                                ], map: sytListMaps);
                                              },
                                            );
                                          } else {
                                            showCustomToast(
                                                value.toString(), _context);
                                          }
                                        });
                                      }, Colors.transparent, Colors.transparent,
                                        5),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Container(
                                height: 50,
                                width: 150,
                                child: isAcceptLoading
                                    ? setbuttonWithChild(
                                        setCustomFont("Accept", 16,
                                            Colors.white, FontWeight.w400, 1),
                                        () {},
                                        appColor,
                                        Colors.purple[900],
                                        5)
                                    : setbuttonWithChild(
                                        setCustomFont(
                                            "Accept",
                                            16,
                                            Colors.white,
                                            FontWeight.w400,
                                            1), () async {
                                        FormData formData;

                                        formData = FormData.fromMap({
                                          "package_id": orderDetail
                                              .packageDetail[0].packageId,
                                          "pickup_address":
                                              orderDetail.pickupLocation,
                                          "pickup_latitude":
                                              orderDetail.pickupLatitude,
                                          "pickup_longitude":
                                              orderDetail.pickupLongitude,
                                          "drop_address":
                                              orderDetail.dropLocation,
                                          "drop_latitude":
                                              orderDetail.dropLatitude,
                                          "drop_longitude":
                                              orderDetail.dropLongitude,
                                          "images": orderDetail.packageImages,
                                        });
                                        postDataRequestWithToken(acceptOrderAPI,
                                                formData, _context)
                                            .then((value) {
                                          if (value is Map) {
                                            AlertMessage(
                                              "You have accepted this order.",
                                              _context,
                                              () {
                                                Navigator.of(_context)
                                                    .pop(true);
                                                Navigator.of(_context)
                                                    .pop(true);
                                                Map sytListMap = Map();
                                                sytListMap["ViewOrderTab"] =
                                                    true;
                                                Observable().notifyObservers([
                                                  "_TabbarVCState",
                                                ], map: sytListMap);

                                                Map sytListMaps = Map();
                                                sytListMaps["ViewPOrder"] =
                                                    true;
                                                Observable().notifyObservers([
                                                  "_TabbarVCState",
                                                ], map: sytListMaps);
                                              },
                                            );
                                          } else {
                                            showCustomToast(
                                                value.toString(), _context);
                                          }
                                        });
                                      }, appColor, Colors.purple[900], 5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  static displayBottomSheet() {
    showBottomSheet(
        context: _context,
        builder: (context) => Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
            ));
  }
}
