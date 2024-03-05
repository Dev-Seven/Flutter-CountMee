import 'package:countmee/Model/notificationListModel.dart';
import 'package:countmee/Screens/DeliveryBoy/Home/HomeVC.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/DeliveredOrderDetailVC.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/OrderDetailVC.dart';
import 'package:countmee/Screens/DeliveryBoy/TabBar/TabBarVC.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../Model/PandingDataModel.dart';
import '../Order/AcceptedOrder.dart';

/*
Title : NotificationCell
Purpose: NotificationCell
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class NotificationCell extends StatefulWidget {
  NotificationData notificationData;

  NotificationCell(this.notificationData);

  @override
  _NotificationCellState createState() => _NotificationCellState();
}

class _NotificationCellState extends State<NotificationCell> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.notificationData.collectionId != null) {
      getCollectionDetail();
    }
  }

  var isLoading = false;
  String address;
  var addressLat;
  var addressLng;
  PandingDataModel orderDetail;

  getCollectionDetail() {
    setState(() {
      isLoading = true;
    });

    FormData formData = FormData.fromMap({
      "collection_center_id": widget.notificationData.collectionId,
    });

    afterDelay(1, () {
      postDataRequestWithToken(collectionCenterDetailsAPI, formData, context)
          .then((value) {
        if (value[kData] is Map) {
          setState(() {
            address = value[kData]['address'];
            addressLat = value[kData]['latitude'];
            addressLng = value[kData]['longitude'];
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        FormData formData = FormData.fromMap({
          "order_id": widget.notificationData.packageId,
        });
        await postDataRequestWithToken(getOrderDetailAPI, formData, context)
            .then((value) {
          print(value);
          setState(() {
            isLoading = false;
          });
          print(value);
          print("hii");
          if (value[kStatusCode] == 200) {
            if (value[kData] is Map) {
              setState(() {
                orderDetail = PandingDataModel.fromJson(value[kData]);
              });
            }
          } else {
            setState(() {
              isLoading = false;
            });
            showCustomToast(value[kMessage], context);
          }
        });
        if (widget.notificationData.title.contains("Cancellation")) {
        } else if (widget.notificationData.title.contains("delivered")) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveredOrderDetailVC(
                objOrder: orderDetail,
              ),
              fullscreenDialog: false,
            ),
          );
        } else if (widget.notificationData.title.contains("accepted")) {
        } else if (orderDetail.first_deliveryboy == 0 &&
            orderDetail.deliveryboy_id == orderDetail.userId) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AcceptedOrderVC(
                objOrder: orderDetail,
              ),
              fullscreenDialog: false,
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailVC(
                orderId: widget.notificationData.packageId,
                address: address,
                addressLat: addressLat,
                addressLng: addressLng,
              ),
              fullscreenDialog: false,
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
              shape: BoxShape.rectangle,
              boxShadow: [getdefaultShadow()]),
          child: Row(
            children: [
              SizedBox(
                width: 8,
              ),
              // Container(
              //   padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              //   height: 50,
              //   width: 50,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.all(Radius.circular(25)),
              //     color: Color.fromRGBO(241, 241, 241, 1),
              //   ),
              // ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        //width: MediaQuery.of(context).size.width / 1.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            setCustomFont(
                              widget.notificationData.title,
                              16,
                              textBlackColor,
                              FontWeight.w700,
                              1,
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Flexible(
                              child: Text(
                                timeago.format(
                                    widget.notificationData.createdAt,
                                    allowFromNow: true),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    color: Color.fromRGBO(178, 178, 178, 1),
                                    height: 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        alignment: Alignment.centerLeft,
                        child: setCustomFontLeftAlignment(
                            widget.notificationData.message,
                            14,
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
        ),
      ),
    );
  }
}
