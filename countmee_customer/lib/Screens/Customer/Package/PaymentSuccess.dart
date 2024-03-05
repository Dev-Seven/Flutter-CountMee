import 'dart:convert';

import 'package:countmee/Screens/Customer/Home/HomeVC.dart';
import 'package:countmee/Screens/Customer/Order/TrackOrderVC.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../Model/MyOrderModel.dart';

/*
Title : PaymentSuccess Screen
Purpose: PaymentSuccess Screen
Created By : Kalpesh Khandla
Last Edited By : 3 Feb 2022
*/

class PaymentSuccessVC extends StatefulWidget {
  var orderId;
  var orderNumber;
  var orderDate;
  var orderAmount;
  var paymentId;
  dynamic packageDetail;

  PaymentSuccessVC({
    Key key,
    this.orderId,
    this.orderNumber,
    this.orderDate,
    this.orderAmount,
    this.paymentId,
    this.packageDetail,
  }) : super(key: key);

  @override
  _PaymentSuccessVCState createState() => _PaymentSuccessVCState();
}

class _PaymentSuccessVCState extends State<PaymentSuccessVC> {
  dynamic package;
  MyOrderModel orderDetail;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    package = jsonDecode(widget.packageDetail);
    String url = "payment-capture/" + widget.paymentId;
    print(url);
    postDataRequestWithToken(url, null, context).then((value) {
      print(value);

      showGreenToast("Order placed successfully", context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: setImageName(
                  "orderPlacedBanner.png",
                  200,
                  230,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              setCustomFont(
                "Your order placed successful",
                14,
                textBlackColor,
                FontWeight.w400,
                1,
              ),
              SizedBox(
                height: 18,
              ),
              Container(
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
                          "#${widget.orderNumber}" ?? "",
                          14,
                          textBlackColor,
                          FontWeight.w400,
                          1,
                        ),
                      ],
                    ),
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
                          "${widget.orderDate}" ?? "",
                          14,
                          textBlackColor,
                          FontWeight.w400,
                          1,
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    boxShadow: [getShadow(0, 0, 15)]),
              ),
              SizedBox(height: 20),
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
                      "Package Details",
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
                    SizedBox(
                      height: 14,
                    ),
                    setCustomFont(
                      package[0]['description'] == 'Others'
                          ? package[0]['other_description']
                          : package[0]['description'] ?? "",
                      16,
                      textBlackColor,
                      FontWeight.w500,
                      1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    setCustomFont(
                      package[0]['weight'] ?? "",
                      14,
                      textBlackColor,
                      FontWeight.w400,
                      1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    setCustomFont(
                      package[0]['handle_product'] ?? "",
                      14,
                      textBlackColor,
                      FontWeight.w400,
                      1,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  boxShadow: [getShadow(0, 0, 15)],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: setCustomFont(
                        "Payment Details",
                        16,
                        textBlackColor,
                        FontWeight.w600,
                        1,
                      ),
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
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                      child: Row(
                        children: [
                          setCustomFont("Amount Payable", 14, textBlackColor,
                              FontWeight.w600, 1),
                          Spacer(),
                          setCustomFont(
                            "₹" + widget.orderAmount ?? "",
                            14,
                            textBlackColor,
                            FontWeight.w600,
                            1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    boxShadow: [getShadow(0, 0, 15)]),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: appColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        height: 50,
                        child: setbuttonWithChild(
                          setCustomFont(
                            "Track Order",
                            16,
                            appColor,
                            FontWeight.w400,
                            1,
                          ),
                          () {
                            FormData formData =
                                FormData.fromMap({"order_id": widget.orderId});
                            postDataRequestWithToken(
                                    getOrderDetailAPI, formData, context)
                                .then((value) {
                              if (value[kStatusCode] == 200) {
                                if (value[kData] is Map) {
                                  orderDetail =
                                      MyOrderModel.fromJson(value[kData]);
                                  print(orderDetail.orderNumber);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TrackOrderVC(orderDetail),
                                    ),
                                  );
                                }
                              }
                            });

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => TrackOrderVC(orderDetail),
                            //   ),
                            // );
                          },
                          Colors.transparent,
                          Colors.transparent,
                          5,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Expanded(
                        child: Container(
                      height: 50,
                      child: setbuttonWithChild(
                          setCustomFont(
                            "Go to Home",
                            16,
                            Colors.white,
                            FontWeight.w400,
                            1,
                          ), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeVC(),
                                fullscreenDialog: false));

                        // Navigator.popUntil(context, (route) => route.isFirst);
                      }, appColor, Colors.purple[900], 5),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
