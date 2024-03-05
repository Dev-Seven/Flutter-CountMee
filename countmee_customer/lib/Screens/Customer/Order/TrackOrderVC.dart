import 'package:countmee/Model/TrackOrderModel.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Model/MyOrderModel.dart';

/*
Title : TrackOrderVC Screen
Purpose: TrackOrderVC Screen
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class TrackOrderVC extends StatefulWidget {
  final MyOrderModel orderDetail;
  dynamic orderid;
  TrackOrderVC(
    this.orderDetail,
  );

  @override
  _TrackOrderVCState createState() => _TrackOrderVCState();
}

class _TrackOrderVCState extends State<TrackOrderVC> {
  List<TrackDetail> _trackDetailList = [];
  bool isLoading = false;
  TrackOrderModel trackOrderModel;

  initState() {
    super.initState();
    trackOrder();
  }

  trackOrder() {
    setState(() {
      isLoading = true;
    });
    FormData formData = FormData.fromMap({
      "order_id": widget.orderDetail.id.toString(),
    });
    _trackDetailList.clear();
    postDataRequestWithToken(orderTrack, formData, context).then((value) {
      if (value is Map) {
        trackOrderModel = TrackOrderModel.fromJson(value);
        _trackDetailList.addAll(trackOrderModel.data.trackDetails);
        print(_trackDetailList);

        /*if (value[kData] is List) {
          var cardList = value[kData]
              .map<CardDetailModel>((json) => CardDetailModel.fromJson(json))
              .toList();
          setState(() {
            arrCardList = cardList;
          });
        } else {
          showCustomToast(value[kMessage].toString(), context);
        }*/
      } else {
        showCustomToast(value.toString(), context);
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: setCustomFont(
          "Track Order",
          20,
          textBlackColor,
          FontWeight.w700,
          1,
        ),
        leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
          Navigator.pop(context);
        }, Colors.transparent, Colors.transparent, 0),
      ),
      body: isLoading
          ? Center(
              child: setButtonIndicator(2, appColor),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Container(
                    child: Row(
                      children: [
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              "Order ID : ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textBlackColor,
                              ),
                            ),
                            setCustomFont(
                              "#" + "${widget.orderDetail.orderNumber}" ?? "",
                              14,
                              textBlackColor,
                              FontWeight.w400,
                              1,
                            ),
                          ],
                        ),
                        // setCustomFont(
                        //   // trackOrderModel.data.orderDetails.orderNumber
                        //   "Order ID : #${widget.orderId}" ?? "",
                        //   14,
                        //   textBlackColor,
                        //   FontWeight.w400,
                        //   1,
                        // ),
                        Spacer(),
                        Container(
                          width: 1,
                          height: 30,
                          color: Color.fromRGBO(178, 178, 178, 1),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              "Date : ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textBlackColor,
                              ),
                            ),
                            setCustomFont(
                              DateFormat("dd-MM-yyyy").format(
                                DateTime.parse(trackOrderModel
                                    .data.orderDetails.createdAt
                                    .split("T")[0]),
                              ),
                              14,
                              textBlackColor,
                              FontWeight.w400,
                              1,
                            ),
                          ],
                        ),
                        // setCustomFont(
                        //     "Date : " +
                        //             DateFormat("dd-MM-yyyy").format(
                        //               DateTime.parse(trackOrderModel
                        //                   .data.orderDetails.createdAt
                        //                   .split("T")[0]),
                        //             ) ??
                        //         "",
                        //     14,
                        //     textBlackColor,
                        //     FontWeight.w400,
                        //     1),
                        Spacer(),
                      ],
                    ),
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      boxShadow: [getShadow(0, 0, 15)],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Container(
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        shrinkWrap: false,
                        itemCount: _trackDetailList.length,
                        itemBuilder: (context, position) {
                          TrackDetail trackDetail = _trackDetailList[position];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color.fromRGBO(178, 178, 178, 1),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        color: appColor,
                                      ),
                                    ),
                                  ),
                                  (position == (_trackDetailList.length - 1))
                                      ? Container()
                                      : Container(
                                          height: 60,
                                          width: 2,
                                          color: appColor,
                                        ),
                                ],
                              ),
                              SizedBox(
                                width: 18,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 3,
                                  ),
                                  setCustomFont(
                                    trackDetail.status[0].toUpperCase() +
                                        trackDetail.status
                                            .substring(1)
                                            .replaceAll("_", " "),
                                    16,
                                    textBlackColor,
                                    FontWeight.w500,
                                    1,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  trackDetail.status == 'order_delivered'
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .70,
                                          child: setCustomFontWithAlignment(
                                            trackDetail.dropAddress,
                                            14,
                                            textBlackColor,
                                            FontWeight.w400,
                                            1,
                                            TextAlign.left,
                                          ),
                                        )
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .70,
                                          child: setCustomFontWithAlignment(
                                            trackDetail.pickupAddress,
                                            14,
                                            textBlackColor,
                                            FontWeight.w400,
                                            1,
                                            TextAlign.left,
                                          ),
                                        ),
                                ],
                              )
                            ],
                          );
                        },
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [getShadow(0, 0, 15)],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
    );
  }
}
