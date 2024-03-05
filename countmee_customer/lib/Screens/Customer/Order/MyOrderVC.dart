import 'package:countmee/Model/MyOrderModel.dart';
import 'package:countmee/Screens/Customer/Order/OngoingOrderCell.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/*
Title : MyOrder Screen
Purpose: MyOrder Screen 
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class MyOrderVC extends StatefulWidget {
  @override
  _MyOrderVCState createState() => _MyOrderVCState();
}

class _MyOrderVCState extends State<MyOrderVC> {
  FocusNode _node;
  TextEditingController controller;
  List<MyOrderModel> arrMyOrders = List.from([MyOrderModel()]);
  List<MyOrderModel> arrMyOrdersSearch = List.from([MyOrderModel()]);
  var isLoading = false;
  var isFromSearch = false;
  List filter = [
    'Pending Orders',
    'Delivered Orders',
    'Cancelled Orders',
  ];
  var selectedFilter;

  @override
  void initState() {
    super.initState();
    setState(() {
      checkConnection(context);
      getMyOrderList(selectedFilter);
    });
  }

  getMyOrderList(String filter) {
    setState(() {
      isLoading = true;
    });

    arrMyOrders.clear();
    FormData formData = FormData.fromMap({
      "package_status": filter,
    });
    postDataRequestWithToken(getOrderList, formData, context).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value is Map) {
        if (value[kStatusCode] == 200) {
          _handleDataResponse(value[kData]);
        }else if (value[kStatusCode] == 500) {
          showCustomToast(
              'Something went wrong.\nplease check after sometime.', context);
        }  else {
          showCustomToast(value[kMessage].toString(), context);
        }
      } else {
        showCustomToast(value.toString(), context);
      }
    });
  }

  _handleDataResponse(value) {
    var arrData =
        value.map<MyOrderModel>((json) => MyOrderModel.fromJson(json)).toList();
    setState(() {
      arrMyOrders = arrData;
    });
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isConnected == true) {
      setState(() {
        getMyOrderList(selectedFilter);
        isConnected = false;
      });
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title:
            setCustomFont("My Orders", 20, textBlackColor, FontWeight.w700, 1),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_alt),
            iconSize: 30.0,
            color: Colors.grey,
            onPressed: () {
              showFilterPopup();
            },
          ),
        ],
        leading: setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
          Navigator.pop(context);
        }, Colors.transparent, Colors.transparent, 0),
      ),
      body: Container(
        child: arrMyOrders.length == 0
            ? Center(
                child: setCustomFont("Orders not available", 15, Colors.grey,
                    FontWeight.w400, 1.5),
              )
            : isLoading
                ? Center(
                    child: setButtonIndicator(2, appColor),
                  )
                : SafeArea(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: false,
                            itemCount: arrMyOrders.length,
                            itemBuilder: (context, position) {
                              return OngoingOrderCell(
                                objOrder: arrMyOrders[position],
                                status: arrMyOrders[position].status,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  showFilterPopup() {
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
              child: Scrollbar(
                child: Container(
                  height: MediaQuery.of(context).size.height / 5.3,
                  width: MediaQuery.of(context).size.width - 50,
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                    shrinkWrap: false,
                    itemCount: filter.length,
                    itemBuilder: (context, position) {
                      return InkWell(
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            if (filter[position] == 'Pending Orders') {
                              selectedFilter = 'pending_orders';
                            } else if (filter[position] == 'Delivered Orders') {
                              selectedFilter = 'delivered_orders';
                            } else if (filter[position] == 'Cancelled Orders') {
                              selectedFilter = 'cancelled_orders';
                            }
                          });
                          Navigator.pop(context);
                          getMyOrderList(selectedFilter);
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                alignment: Alignment.centerLeft,
                                height: 50,
                                child: Row(
                                  children: [
                                    Container(
                                      child: setCustomFont(
                                          (filter[position]),
                                          14,
                                          textBlackColor,
                                          FontWeight.w400,
                                          1),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                child: Divider(
                                  height: 1,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )),
        );
      },
    );
  }
}
