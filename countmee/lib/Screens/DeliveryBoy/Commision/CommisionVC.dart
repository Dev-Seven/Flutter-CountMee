import 'dart:convert';

import 'package:countmee/Model/CommissionModel.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/DeliveredOrderDetailVC.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/*
Title : CommisionVC
Purpose: CommisionVC
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class CommisionVC extends StatefulWidget {
  final orderId;
  final isFromNotification;

  const CommisionVC({Key key, this.orderId, this.isFromNotification})
      : super(key: key);

  @override
  _CommisionVCState createState() => _CommisionVCState();
}

class _CommisionVCState extends State<CommisionVC> {
  bool isLoading = false;
  List<CommissionModel> commissionDetail = List.from([CommissionModel()]);
  double totalCommission;
  var orderId;
  var collectionId;

  @override
  void initState() {
    super.initState();
    checkConnection(context);
    getCommissionDetail();

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
    listener.cancel();
    super.dispose();
  }

  getCommissionDetail() {
    setState(() {
      isLoading = true;
    });

    commissionDetail.clear();
    postDataRequestWithToken(commissionListApi, null, context).then((value) {
      if (value[kStatusCode] as int == 200) {
        if (value[kData] is List) {
          setState(() {
            totalCommission =
                double.parse((value['total_commission']).toString());
            _handleCommissionListResponse(value[kData]);
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
      } else {
        setState(() {
          isLoading = false;
        });
        showCustomToast(value[kMessage], context);
      }
    });
  }

  _handleCommissionListResponse(value) {
    var arrData = value
        .map<CommissionModel>((json) => CommissionModel.fromJson(json))
        .toList();
    commissionDetail = arrData;
  }

  @override
  Widget build(BuildContext context) {
    if (isConnected == true) {
      setState(() {
        getCommissionDetail();
        isConnected = false;
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
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
                          "Total Commission Earn",
                          13,
                          Colors.white,
                          FontWeight.w400,
                          1,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        setCustomFont(
                            totalCommission != null
                                ? "₹${totalCommission.toStringAsFixed(2)}"
                                : "",
                            28,
                            Colors.white,
                            FontWeight.w600,
                            1),
                      ],
                    ),
                  ),
                  height: 82,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: appColor,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              isLoading
                  ? Container(
                      height: MediaQuery.of(context).size.height * .60,
                      child: Center(child: setButtonIndicator(2, appColor)))
                  : Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          shrinkWrap: true,
                          itemCount: commissionDetail.length,
                          itemBuilder: (context, position) {
                            return Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(18, 20, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: commissionDetail[position].date != null
                                      ? setCustomFont(
                                          DateFormat('dd-MM-yyyy').format(
                                            DateTime.parse(
                                              commissionDetail[position].date,
                                            ),
                                          ),
                                          14,
                                          textBlackColor,
                                          FontWeight.w500,
                                          1,
                                        )
                                      : "",
                                ),
                                ListView.builder(
                                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  shrinkWrap: true,
                                  itemCount: commissionDetail[position]
                                      .commission
                                      .length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 7, 15, 7),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DeliveredOrderDetailVC(
                                                  objOrder:
                                                      commissionDetail[position]
                                                          .commission[index]
                                                          .packageDetail,
                                                ),
                                                fullscreenDialog: false,
                                              ));
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Order No. : ",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  textBlackColor,
                                                            ),
                                                          ),
                                                          Text(
                                                            commissionDetail[
                                                                            position]
                                                                        .commission[
                                                                            index]
                                                                        .packageDetail
                                                                        .id !=
                                                                    null
                                                                ? "#${commissionDetail[position].commission[index].packageDetail.orderNumber}"
                                                                : "",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  textBlackColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // setCustomFont(
                                                      //   commissionDetail[
                                                      //                   position]
                                                      //               .commission[
                                                      //                   index]
                                                      //               .packageDetail
                                                      //               .id !=
                                                      //           null
                                                      //       ? "Order No. : #${commissionDetail[position].commission[index].packageDetail.id}"
                                                      //       : "Order No. : ",
                                                      //   14,
                                                      //   textBlackColor,
                                                      //   FontWeight.w400,
                                                      //   1,
                                                      // ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      setCustomFont(
                                                          "View Details",
                                                          10,
                                                          appColor,
                                                          FontWeight.w400,
                                                          1),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  setCustomFont(
                                                      commissionDetail[position]
                                                                  .commission[
                                                                      index]
                                                                  .commission !=
                                                              null
                                                          ? "₹${commissionDetail[position].commission[index].commission}"
                                                          : "",
                                                      16,
                                                      textBlackColor,
                                                      FontWeight.w600,
                                                      1),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.white,
                                                  shape: BoxShape.rectangle,
                                                  boxShadow: [
                                                    getShadow(0, 0, 15)
                                                  ]),
                                              height: 50,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          }),
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
