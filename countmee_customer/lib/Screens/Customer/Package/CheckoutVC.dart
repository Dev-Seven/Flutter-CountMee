import 'dart:convert';

import 'package:countmee/Model/OrderResponseModel.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'PaymentSuccess.dart';
import 'package:google_fonts/google_fonts.dart';

/*
Title : CheckoutVC Screen
Purpose: CheckoutVC Screen
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class CheckoutVC extends StatefulWidget {
  dynamic package_detail;
  var pickup_address;
  var drop_address;
  var mode_of_transport;
  var receiver_name;
  var receiver_mobile;
  final dynamic data;
  final km;
  String transportImage;

  CheckoutVC({
    Key key,
    this.package_detail,
    this.pickup_address,
    this.drop_address,
    this.mode_of_transport,
    this.receiver_name,
    this.receiver_mobile,
    this.data,
    this.km,
    this.transportImage,
  }) : super(key: key);

  @override
  _CheckoutVCState createState() => _CheckoutVCState();
}

class _CheckoutVCState extends State<CheckoutVC> {
  Razorpay _razorpay;
  bool isLoading;
  bool isOrderPlaceLoading = false;
  OrderResponseModel orderResponseModel;
  var order_id;
  String orderDate = "";
  String dateFormat = "";

  initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    orderResponseModel = widget.data;
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _placedOrder(
        response.paymentId, response.orderId, response.signature, "success");
  }

  _placedOrder(
    String paymentId,
    String paymentOrderId,
    String paymentSingnature,
    String paymentStatus,
  ) {
    setState(() {
      isOrderPlaceLoading = true;
    });

    try {
      FormData formData = FormData.fromMap({
        "payment_id": paymentId,
        "payment_order_id": paymentOrderId == null ? "123" : paymentOrderId,
        "payment_signature":
            paymentSingnature == null ? "dsdasdsa" : paymentSingnature,
        "payment_status": paymentStatus,
        "order_id": orderResponseModel.data.id
      });
      print("E");
      print(formData);
      postDataRequestWithToken(placedOrderAPI, formData, context).then((value) {
        if (value["status_code"] as int == 200) {
          order_id = value['data']['package_id'];
          dateFormat = value['data']['created_at'].split("T")[0];
          orderDate =
              DateFormat("dd-MM-yyyy").format(DateTime.parse(dateFormat));
          Navigator.pop(context);
          Navigator.pop(context);
          pushToViewController(
              context,
              PaymentSuccessVC(
                orderId: order_id,
                orderNumber: orderResponseModel.data.orderNumber,
                orderDate: orderDate,
                orderAmount: orderResponseModel.data.totalPayable,
                paymentId: paymentId,
                packageDetail: widget.package_detail,
              ),
              () {});
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) =>PaymentSuccessVC(
          //     orderId: order_id,
          //     orderNumber: orderResponseModel.data.orderNumber,
          //     orderDate: orderDate,
          //     orderAmount: orderResponseModel.data.totalPayable,
          //     packageDetail: widget.package_detail,
          // ),
          //     fullscreenDialog: false,
          //   ),
          //   (route) => false,
          // );

          //Navigator.popUntil(context, (route) => route.isFirst);

        } else {
          showCustomToast(value[kMessage], context);
        }
      });
    } catch (e) {
      showCustomToast(e, context);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("ERROR: " + response.code.toString() + " - " + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL_WALLET: " + response.walletName);
  }

  onBookAppointment() async {
    double actualAmount = double.parse(orderResponseModel.data.totalPayable);

    //int amount = actualAmount * 100;

    //print("AMOUNT MULTIPLIED $amount");

    // (double.parse(orderResponseModel.data.totalPayable) * 100).round();

    var options = {
      //'key': 'rzp_live_iNfsiXUOfnHfps',
      // 'key': 'rzp_live_iNfsiXUOfnHfps', //(info@countmee.com)', live
      'key': 'rzp_test_JlxxHDt22qeKTC', //test api key.

      'amount': actualAmount * 100.round(),
      'name': 'Countmee',
      'description': 'Countmee Payment',
      'external': {
        'wallets': ['paytm']
      },
      "theme": {"color": "#894AE5"}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Widget build(BuildContext context) {
    dynamic package = jsonDecode(widget.package_detail);
    return WillPopScope(
      onWillPop: () async {
        if (isOrderPlaceLoading) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: setCustomFont(
            "Order Details",
            20,
            textBlackColor,
            FontWeight.w700,
            1,
          ),
          leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
            Navigator.pop(context);
          }, Colors.transparent, Colors.transparent, 0),
        ),
        body: SafeArea(
          child: isLoading == true
              ? Center(
                  child: Text("Order Preparing..."),
                )
              : isOrderPlaceLoading
                  ? Center(child: setButtonIndicator(2, appColor))
                  : SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Stack(
                          children: [
                            Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: setCustomFont(
                                            "Receiver Details",
                                            16,
                                            textBlackColor,
                                            FontWeight.w600,
                                            1),
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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          setCustomFont(
                                            widget.receiver_name,
                                            16,
                                            textBlackColor,
                                            FontWeight.w500,
                                            1,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          setCustomFont(
                                              widget.receiver_mobile,
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
                                  padding: EdgeInsets.fromLTRB(18, 10, 15, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 10, 0, 0),
                                        child: setCustomFont(
                                            "Address Details",
                                            16,
                                            textBlackColor,
                                            FontWeight.w600,
                                            1),
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
                                        height: 160,
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
                                                  height: 3,
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
                                                  height: 3,
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
                                                  height: 3,
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
                                                  height: 3,
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
                                                  height: 3,
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
                                                  height: 3,
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
                                                  height: 3,
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
                                                  height: 3,
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
                                                  height: 3,
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
                                                  height: 3,
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
                                                  height: 3,
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
                                                  height: 3,
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
                                                  height: 3,
                                                ),
                                                ClipOval(
                                                  child: Container(
                                                    width: 8,
                                                    height: 8,
                                                    color: appColor,
                                                  ),
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
                                                      orderResponseModel
                                                          .data.pickupLocation,
                                                      16,
                                                      Color.fromRGBO(
                                                          287, 287, 287, 1),
                                                      FontWeight.w500,
                                                      1,
                                                      TextAlign.left),
                                                  Spacer(),
                                                  Container(
                                                    height: 1,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.60,
                                                    child: Divider(
                                                      height: 1,
                                                      color: Color.fromRGBO(
                                                          246, 246, 246, 1),
                                                    ),
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
                                                      orderResponseModel
                                                          .data.dropLocation,
                                                      16,
                                                      Color.fromRGBO(
                                                          287, 287, 287, 1),
                                                      FontWeight.w500,
                                                      1,
                                                      TextAlign.left),
                                                  Spacer(),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(37, 0, 0, 0),
                                        child: orderResponseModel
                                                    .data.totalDistance ==
                                                null
                                            ? SizedBox()
                                            : Row(
                                                children: [
                                                  Text(
                                                    "Approx. distance is",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: textBlackColor,
                                                        height: 1),
                                                  ),
                                                  Text(
                                                    " ${orderResponseModel.data.totalDistance} km",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: appColor,
                                                        height: 1),
                                                  )
                                                ],
                                              ),

                                        //  setCustomFont(
                                        //     'Approx. distance is ${orderResponseModel.data.totalDistance} km',
                                        //     16,
                                        //     textBlackColor,
                                        //     FontWeight.w500,
                                        //     1)
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      setCustomFont("Mode of transport", 16,
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
                                              widget.transportImage),
                                          SizedBox(
                                            width: 14,
                                          ),
                                          setCustomFont(
                                              widget.mode_of_transport ?? "",
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
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      setCustomFont("Package Details", 16,
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
                                          package[0]['description'] == 'Others'
                                              ? package[0]['other_description']
                                              : package[0]['description'] ?? "",
                                          16,
                                          textBlackColor,
                                          FontWeight.w500,
                                          1),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      setCustomFont(
                                          package[0]['weight'] ?? "",
                                          14,
                                          textBlackColor,
                                          FontWeight.w400,
                                          1),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      setCustomFont(
                                          package[0]['handle_product'] ?? "",
                                          14,
                                          textBlackColor,
                                          FontWeight.w400,
                                          1),
                                      SizedBox(
                                        height: 14,
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
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        child: setCustomFont(
                                            "Payment Details",
                                            16,
                                            textBlackColor,
                                            FontWeight.w600,
                                            1),
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
                                      /*Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Row(
                                children: [
                                  setCustomFont("Delivery Charges", 16,
                                      textBlackColor, FontWeight.w500, 1),
                                  Spacer(),
                                  setCustomFont(
                                      "₹${widget.courier_charge}", 16, textBlackColor, FontWeight.w500, 1),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Row(
                                children: [
                                  setCustomFont("Refundable Deposit", 16,
                                      textBlackColor, FontWeight.w500, 1),
                                  Spacer(),
                                  setCustomFont(
                                      "₹500", 16, textBlackColor, FontWeight.w500, 1),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Row(
                                children: [
                                  setCustomFont("Discount", 16, textBlackColor,
                                      FontWeight.w500, 1),
                                  Spacer(),
                                  setCustomFont(
                                      "-₹20", 16, appGreenColor, FontWeight.w500, 1),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Divider(
                              height: 1,
                              color: Color.fromRGBO(226, 226, 226, 1).withAlpha(500),
                            ),
                            SizedBox(
                              height: 14,
                            ),*/
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Amount Payable",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.normal,
                                                  color: textBlackColor,
                                                  height: 1),
                                            ),
                                            // setCustomFont(
                                            //     "Amount Payable",
                                            //     14,
                                            //     textBlackColor,
                                            //     FontWeight.w600,
                                            //     1),
                                            Spacer(),

                                            Text(
                                              "₹${orderResponseModel.data.totalPayable ?? ""}",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.normal,
                                                  color: appColor,
                                                  height: 1),
                                            ),
                                          ],
                                        ),
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
                                isOrderPlaceLoading
                                    ? Container(
                                        width: 30,
                                        height: 30,
                                        child:
                                            setButtonIndicator(3, Colors.white),
                                      )
                                    : Container(
                                        height: 57,
                                        width: double.infinity,
                                        child: setbuttonWithChild(
                                            setCustomFont(
                                                "Pay Now",
                                                16,
                                                Colors.white,
                                                FontWeight.w400,
                                                1.5), () {
                                          onBookAppointment();
                                        }, appColor, Colors.purple[900], 5)),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                            setLoadingState(isOrderPlaceLoading, context)
                          ],
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
