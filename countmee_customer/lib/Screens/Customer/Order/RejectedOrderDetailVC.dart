import 'package:cached_network_image/cached_network_image.dart';
import 'package:countmee/Model/ItemDetailModel.dart';
import 'package:countmee/Model/MyOrderModel.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/*
Title : RejectedOrderDetailsVC Screen
Purpose: RejectedOrderDetailsVC Screen
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class RejectedOrderDetailsVC extends StatefulWidget {
  final MyOrderModel objOrder;

  const RejectedOrderDetailsVC({Key key, this.objOrder}) : super(key: key);
  @override
  _RejectedOrderDetailsVCState createState() => _RejectedOrderDetailsVCState();
}

class _RejectedOrderDetailsVCState extends State<RejectedOrderDetailsVC> {
  ItemDetailModel orderDetail;
  Users deliveryBoyDetail;
  var isLoading = false;
  String name = "";
  String mobileNo = "";
  String image = "";
  String orderDate = "";
  String dateFormat = "";
  @override
  void initState() {
    super.initState();
    getOrderDetail();
  }

  getOrderDetail() {
    setState(() {
      isLoading = true;
    });
    FormData formData = FormData.fromMap({
      "order_id": widget.objOrder.id,
    });
    postDataRequestWithToken(getOrderDetailAPI, formData, context)
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (value[kStatusCode] == 200) {
        if (value[kData] is Map) {
          orderDetail = ItemDetailModel.fromJson(value[kData]);
          print(orderDetail);
          dateFormat = orderDetail.createdAt.split("T")[0];
          orderDate =
              DateFormat("dd-MM-yyyy").format(DateTime.parse(dateFormat));
          name = value['data']['delivery_boy_details']['name'];
          mobileNo = value['data']['delivery_boy_details']['phone_number'];
          image = value['data']['delivery_boy_details']['image'];
        } else {
          showCustomToast(value[kMessage], context);
        }
      } else if (value[kStatusCode] == 500) {
          showCustomToast(
              'Something went wrong.\nplease check after sometime.', context);
        }else {
        showCustomToast(value[kMessage], context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: setCustomFont(
            "Order Details", 20, textBlackColor, FontWeight.w700, 1),
        leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
          Navigator.pop(context);
        }, Colors.transparent, Colors.transparent, 0),
      ),
      body: SafeArea(
        child: isLoading || orderDetail == null
            ? Center(
                child: setButtonIndicator(2, appColor),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: setImageName("orderRejectedBanner.png", 140, 95),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      setCustomFont(
                          "Order Cancelled",
                          14,
                          Color.fromRGBO(
                            255,
                            29,
                            26,
                            1,
                          ),
                          FontWeight.w500,
                          1),
                      SizedBox(
                        height: 20,
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
                                  " #${orderDetail.orderNumber}" ?? "",
                                  14,
                                  textBlackColor,
                                  FontWeight.w400,
                                  1,
                                ),
                              ],
                            ),
                            // setCustomFont("Order ID : #${orderDetail.orderNumber}" ?? "", 14,
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
                                  "$orderDate" ?? "",
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
                      name != ""
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(18, 10, 15, 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: setCustomFont(
                                            "Delivery Boy Details",
                                            16,
                                            textBlackColor,
                                            FontWeight.w600,
                                            1),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Divider(
                                        height: 1,
                                        color: Color.fromRGBO(226, 226, 226, 1)
                                            .withAlpha(500),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          image != null
                                              ? CachedNetworkImage(
                                                  imageUrl:
                                                      "https://countmee-courier.s3.us-east-2.amazonaws.com/users/" +
                                                          image,
                                                  httpHeaders: {'Referer': ''},
                                                  height: 45,
                                                  width: 45,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Image(
                                                    image: AssetImage(
                                                      'assets/images/userPlaceholder.png',
                                                    ),
                                                    width: 45,
                                                    height: 45,
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image(
                                                    image: AssetImage(
                                                      'assets/images/userPlaceholder.png',
                                                    ),
                                                    width: 45,
                                                    height: 45,
                                                  ),
                                                )
                                              : setImageName(
                                                  'userPlaceholder.png',
                                                  50,
                                                  50),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              name != null
                                                  ? setCustomFont(
                                                      name,
                                                      14,
                                                      textBlackColor,
                                                      FontWeight.w700,
                                                      1)
                                                  : "",
                                              SizedBox(
                                                height: 10,
                                              ),
                                              mobileNo != null
                                                  ? setCustomFont(
                                                      mobileNo,
                                                      12,
                                                      textBlackColor,
                                                      FontWeight.w400,
                                                      1)
                                                  : "",
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.0,
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
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(18, 10, 15, 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: setCustomFont("Address Details", 16,
                                  textBlackColor, FontWeight.w600, 1),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Divider(
                              height: 1,
                              color: Color.fromRGBO(226, 226, 226, 1)
                                  .withAlpha(500),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 130,
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                          color:
                                              Color.fromRGBO(239, 239, 239, 1),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      ClipOval(
                                        child: Container(
                                          width: 3,
                                          height: 3,
                                          color:
                                              Color.fromRGBO(239, 239, 239, 1),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      ClipOval(
                                        child: Container(
                                          width: 3,
                                          height: 3,
                                          color:
                                              Color.fromRGBO(239, 239, 239, 1),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      ClipOval(
                                        child: Container(
                                          width: 3,
                                          height: 3,
                                          color:
                                              Color.fromRGBO(239, 239, 239, 1),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      ClipOval(
                                        child: Container(
                                          width: 3,
                                          height: 3,
                                          color:
                                              Color.fromRGBO(239, 239, 239, 1),
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
                                            Color.fromRGBO(287, 287, 287, 1),
                                            FontWeight.w300,
                                            1),
                                        SizedBox(
                                          height: 9,
                                        ),
                                        setCustomFontWithAlignment(
                                            orderDetail.pickupLocation ?? "",
                                            15,
                                            Color.fromRGBO(287, 287, 287, 1),
                                            FontWeight.w500,
                                            1,
                                            TextAlign.left),
                                        SizedBox(
                                          height: 8,
                                        ),
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
                                        SizedBox(
                                          height: 8,
                                        ),
                                        setCustomFont(
                                            "Drop off Location",
                                            11,
                                            Color.fromRGBO(287, 287, 287, 1),
                                            FontWeight.w300,
                                            1),
                                        SizedBox(
                                          height: 9,
                                        ),
                                        setCustomFontWithAlignment(
                                            orderDetail.dropLocation ?? "",
                                            15,
                                            Color.fromRGBO(287, 287, 287, 1),
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
                              height: 12.0,
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(37, 0, 0, 0),
                                child: orderDetail.totalDistance == null
                                    ? SizedBox()
                                    : setCustomFont(
                                        'Approx. distance is ${orderDetail.totalDistance} km',
                                        16,
                                        textBlackColor,
                                        FontWeight.w500,
                                        1)),
                            SizedBox(
                              height: 8.0,
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
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            setCustomFont("Package Details", 16, textBlackColor,
                                FontWeight.w600, 1),
                            SizedBox(
                              height: 14,
                            ),
                            Divider(
                              height: 1,
                              color: Color.fromRGBO(226, 226, 226, 1),
                            ),
                            Container(
                              height: (orderDetail.packageDetail.length * 75)
                                  .toDouble(),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                shrinkWrap: false,
                                itemCount: orderDetail.packageDetail.length,
                                itemBuilder: (context, position) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 8,
                                      ),
                                      setCustomFont(
                                          orderDetail.packageDetail[position]
                                                      .productDesc ==
                                                  'Others'
                                              ? orderDetail
                                                  .packageDetail[position]
                                                  .otherProductDesc
                                              : orderDetail
                                                      .packageDetail[position]
                                                      .productDesc ??
                                                  "",
                                          16,
                                          textBlackColor,
                                          FontWeight.w500,
                                          1),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      setCustomFont(
                                          orderDetail.packageDetail[position]
                                                  .weight ??
                                              "",
                                          14,
                                          textBlackColor,
                                          FontWeight.w400,
                                          1),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      setCustomFont(
                                          orderDetail.packageDetail[position]
                                                  .handleProduct ??
                                              "",
                                          14,
                                          textBlackColor,
                                          FontWeight.w400,
                                          1),
                                      SizedBox(
                                        height: 14,
                                      ),
                                      ((orderDetail.packageDetail.length - 1) ==
                                              position)
                                          ? Container()
                                          : Divider(
                                              height: 1,
                                              color: Color.fromRGBO(
                                                      226, 226, 226, 1)
                                                  .withAlpha(500),
                                            ),
                                    ],
                                  );
                                },
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
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                setTransportImage(orderDetail.transportImage),
                                SizedBox(
                                  width: 14,
                                ),
                                setCustomFont(orderDetail.transportMode ?? "",
                                    14, textBlackColor, FontWeight.w400, 1),
                              ],
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
                              child: setCustomFont("Payment Details", 16,
                                  textBlackColor, FontWeight.w600, 1),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Divider(
                              height: 1,
                              color: Color.fromRGBO(226, 226, 226, 1)
                                  .withAlpha(500),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Row(
                                children: [
                                  setCustomFont("Amount Payable", 14,
                                      textBlackColor, FontWeight.w600, 1),
                                  Spacer(),
                                  setCustomFont(
                                      "₹${orderDetail.totalPayable}" ?? "",
                                      14,
                                      textBlackColor,
                                      FontWeight.w600,
                                      1),
                                ],
                              ),
                            ),
                          ],
                        ),
                        height: 110,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            boxShadow: [getShadow(0, 0, 15)]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
