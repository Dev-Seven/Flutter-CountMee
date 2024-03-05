import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

/*
Title : Feedback Screen
Purpose:  Feedback Screen
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class FeedbackVC extends StatefulWidget {
  final int package_id;
  final int delivery_boy_id;

  const FeedbackVC({Key key, this.package_id, this.delivery_boy_id})
      : super(key: key);
  @override
  _FeedbackVCState createState() => _FeedbackVCState();
}

class _FeedbackVCState extends State<FeedbackVC> {
  final txtMessageController = TextEditingController();
  var isLoading = false;
  var nature, packaging, onTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title:
              setCustomFont("Feedback", 20, textBlackColor, FontWeight.w700, 1),
          leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
            Navigator.pop(context);
          }, Colors.transparent, Colors.transparent, 0),
        ),
        body: Container(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          boxShadow: [getdefaultShadow()]),
                      height: 95,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: setCustomFont(
                              "Delivery partner nature",
                              14,
                              textBlackColor,
                              FontWeight.w600,
                              1,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                            alignment: Alignment.centerLeft,
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width - 30,
                            child: RatingBar.builder(
                              initialRating: 1,
                              minRating: 1,
                              itemSize: 27,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Color.fromRGBO(255, 193, 7, 1),
                              ),
                              onRatingUpdate: (rating) {
                                nature = rating;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          boxShadow: [getdefaultShadow()]),
                      height: 95,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: setCustomFont(
                              "Product packaging",
                              14,
                              textBlackColor,
                              FontWeight.w600,
                              1,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                            alignment: Alignment.centerLeft,
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width - 30,
                            child: RatingBar.builder(
                              initialRating: 1,
                              minRating: 1,
                              itemSize: 27,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Color.fromRGBO(255, 193, 7, 1),
                              ),
                              onRatingUpdate: (rating) {
                                packaging = rating;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          boxShadow: [getdefaultShadow()]),
                      height: 95,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: setCustomFont(
                              "On time delivery",
                              14,
                              textBlackColor,
                              FontWeight.w600,
                              1,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                            alignment: Alignment.centerLeft,
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width - 30,
                            child: RatingBar.builder(
                              initialRating: 1,
                              minRating: 1,
                              itemSize: 27,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Color.fromRGBO(255, 193, 7, 1),
                              ),
                              onRatingUpdate: (rating) {
                                onTime = rating;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: setTextFieldDynamic(
                          txtMessageController,
                          "Message",
                          false,
                          TextInputType.emailAddress,
                          14,
                          false,
                          null,
                          (value) => {setState(() {})},
                          null)),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 57,
                      child: setbuttonWithChild(
                          setCustomFont(
                              "Submit", 16, Colors.white, FontWeight.w400, 1.2),
                          () {
                        addFeedbackServiceCall();
                      }, appColor, Colors.purple[900], 5)),
                ],
              ),
            ),
          ),
        ));
  }

  addFeedbackServiceCall() {
    if (nature == null) {
      nature = 1.0;
    }

    if (packaging == null) {
      packaging = 1.0;
    }

    if (onTime == null) {
      onTime = 1.0;
    }

    FormData formData = FormData.fromMap({
      "delivery_boy_nature": nature,
      "packaging": packaging,
      "on_time_delivery": onTime,
      "package_id": widget.package_id,
      "message": txtMessageController.text,
      "deliveryboy_id": widget.delivery_boy_id,
    });

    postDataRequestWithToken(addFeedbackAPI, formData, context).then((value) {
      if (value is Map) {
        if (value[kStatusCode] == 200) {
          showGreenToast(
              "Your feedback has been submitted successfully", context);
          Navigator.pop(context);
        } else if (value[kStatusCode] == 500) {
          showCustomToast(
              'Something went wrong.\nplease check after sometime.', context);
        } else {
          showCustomToast(value[kMessage] as String, context);
        }
      } else {
        showCustomToast(value as String, context);
      }
    });
  }
}
