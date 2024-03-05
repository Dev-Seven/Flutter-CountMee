import 'package:countmee/Model/PandingDataModel.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/DeliveredOrderDetailVC.dart';
import 'package:countmee/Screens/DeliveryBoy/TabBar/TabBarVC.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:flutter/material.dart';

/*
Title : UploadImages
Purpose: UploadImages
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class OrderdeliveredVC extends StatefulWidget {
  final PandingDataModel objOrder;

  const OrderdeliveredVC({Key key, this.objOrder}) : super(key: key);
  @override
  _OrderdeliveredVCState createState() => _OrderdeliveredVCState();
}

class _OrderdeliveredVCState extends State<OrderdeliveredVC> {
  bool shouldPop = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => TabbarVC()),
            (Route<dynamic> route) => false);
        return shouldPop;
      },
      child: Scaffold(
        body: Container(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: setImageName("diliverySuccessbanner.png", 197, 134),
                ),
                SizedBox(
                  height: 10,
                ),
                setCustomFont(
                    "Order Delivered Successfully",
                    14,
                    Color.fromRGBO(
                      2,
                      167,
                      7,
                      1,
                    ),
                    FontWeight.w500,
                    1),
                SizedBox(
                  height: 10,
                ),
                setbuttonWithChild(
                    setCustomFont(
                        "View Order Details", 14, appColor, FontWeight.w500, 1),
                    () {
                  pushToViewController(
                      context,
                      DeliveredOrderDetailVC(
                        objOrder: widget.objOrder,
                      ),
                      () {});
                }, Colors.transparent, Colors.transparent, 0),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  width: double.infinity,
                  height: 57,
                  child: setbuttonWithChild(
                      setCustomFont(
                          "Go to Home", 16, Colors.white, FontWeight.w500, 1),
                      () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => TabbarVC()),
                        (Route<dynamic> route) => false);
                  }, appColor, Colors.purple[900], 7),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
