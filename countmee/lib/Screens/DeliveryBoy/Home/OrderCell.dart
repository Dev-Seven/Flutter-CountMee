import 'package:countmee/Model/PandingDataModel.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/AcceptedOrder.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:flutter/material.dart';

/*
Title : OrderCell
Purpose: OrderCell
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class OrderCell extends StatefulWidget {
  final PandingDataModel objOrder;

  const OrderCell({Key key, this.objOrder}) : super(key: key);
  @override
  _OrderCellState createState() => _OrderCellState();
}

class _OrderCellState extends State<OrderCell> {
  @override
  Widget build(BuildContext context) {
    return widget.objOrder != null
        ? Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Container(
              height: 195,
              child: Stack(
                children: [
                  Container(
                    height: 195,
                    child: Column(
                      children: [
                        Spacer(),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          height: 40,
                          child: InkWell(
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AcceptedOrderVC(
                                    objOrder: widget.objOrder,
                                  ),
                                  fullscreenDialog: false,
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  setCustomFont(
                                    "View Order Details",
                                    14,
                                    Colors.white,
                                    FontWeight.w400,
                                    1,
                                  ),
                                  Spacer(),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                  color: appColor,
                                  shape: BoxShape.rectangle,
                                  boxShadow: [
                                    getShadowWithColor(appColor.withAlpha(50))
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [getdefaultShadow()]),
                    alignment: Alignment.centerLeft,
                    height: 155,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 15,
                        ),
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
                              height: 9,
                            ),
                            ClipOval(
                              child: Container(
                                width: 3,
                                height: 3,
                                color: Color.fromRGBO(239, 239, 239, 1),
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            ClipOval(
                              child: Container(
                                width: 3,
                                height: 3,
                                color: Color.fromRGBO(239, 239, 239, 1),
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            ClipOval(
                              child: Container(
                                width: 3,
                                height: 3,
                                color: Color.fromRGBO(239, 239, 239, 1),
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            ClipOval(
                              child: Container(
                                width: 3,
                                height: 3,
                                color: Color.fromRGBO(239, 239, 239, 1),
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            ClipOval(
                              child: Container(
                                width: 3,
                                height: 3,
                                color: Color.fromRGBO(239, 239, 239, 1),
                              ),
                            ),
                            SizedBox(
                              height: 9,
                            ),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Spacer(),
                              SizedBox(
                                height: 8,
                              ),
                              setCustomFont(
                                  "Pickup Location",
                                  11,
                                  Color.fromRGBO(287, 287, 287, 1),
                                  FontWeight.w300,
                                  1),
                              SizedBox(
                                height: 9,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.70,
                                child: setCustomFontWithAlignment(
                                    widget.objOrder.updatedPickupLocation !=
                                            null
                                        ? widget.objOrder.updatedPickupLocation
                                        : "",
                                    16,
                                    Color.fromRGBO(287, 287, 287, 1),
                                    FontWeight.w500,
                                    1,
                                    TextAlign.left),
                              ),
                              Spacer(),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width * 0.70,
                                child: Divider(
                                  height: 1,
                                  color: Color.fromRGBO(246, 246, 246, 1),
                                ),
                              ),
                              Spacer(),
                              setCustomFont(
                                  "Drop off Location",
                                  11,
                                  Color.fromRGBO(287, 287, 287, 1),
                                  FontWeight.w300,
                                  1),
                              SizedBox(
                                height: 9,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.70,
                                child: setCustomFontWithAlignment(
                                    widget.objOrder.updatedDropLocation != null
                                        ? widget.objOrder.updatedDropLocation
                                        : "",
                                    16,
                                    Color.fromRGBO(287, 287, 287, 1),
                                    FontWeight.w500,
                                    1,
                                    TextAlign.left),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
