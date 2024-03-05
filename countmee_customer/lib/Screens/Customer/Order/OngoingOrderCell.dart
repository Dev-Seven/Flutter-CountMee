import 'package:countmee/Model/MyOrderModel.dart';
import 'package:countmee/Screens/Customer/Order/OngoingOrderDetail.dart';
import 'package:countmee/Screens/Customer/Order/RejectedOrderDetailVC.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:countmee/Utility/order_status.dart';
import 'package:flutter/material.dart';
import 'DeliveredOrderDetailVC.dart';

/*
Title : OngoingOrderCell Screen
Purpose: OngoingOrderCell Screen
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class OngoingOrderCell extends StatefulWidget {
  final MyOrderModel objOrder;
  final int status;

  const OngoingOrderCell({
    Key key,
    this.objOrder,
    this.status,
  }) : super(key: key);

  @override
  _OngoingOrderCellState createState() => _OngoingOrderCellState();
}

class _OngoingOrderCellState extends State<OngoingOrderCell> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.objOrder);
  }

  @override
  Widget build(BuildContext context) {
    return _oldBody1();
  }

  Widget _oldBody1() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Container(
        height: 225,
        child: Stack(
          children: [
            Container(
              height: 205,
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
                            builder: (context) =>
                                widget.status == 5 || widget.status == 7
                                    ? DeliveredOrderDetailVC(
                                        objOrder: widget.objOrder,
                                      )
                                    : widget.status == 4 || widget.status == 6
                                        ? RejectedOrderDetailsVC(
                                            objOrder: widget.objOrder,
                                          )
                                        : OngoingOrderDetailVC(
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
                              appColor,
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
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          boxShadow: [getdefaultShadow()],
                        ),
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
              height: 165,
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
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              setCustomFont(
                                  "Pickup Location",
                                  11,
                                  Color.fromRGBO(287, 287, 287, 1),
                                  FontWeight.w300,
                                  1),
                              widget.status == OrderStatus.ORDER_COMPLETED
                                  ? Text(
                                      "COMPLETED",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  : widget.status == OrderStatus.ORDER_REJECTED
                                      ? Text(
                                          "REJECTED",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      : widget.status ==
                                              OrderStatus.ORDER_DELIVERED
                                          ? Text(
                                              "DELIVERED",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.green,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          : widget.status ==
                                                  OrderStatus.ORDER_CANCELLED
                                              ? Text(
                                                  "CANCELLED",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                )
                                              : widget.status ==
                                                      OrderStatus.ORDER_DISPATCH
                                                  ? Text(
                                                      "DISPATCH",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: textBlackColor,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    )
                                                  : widget.status ==
                                                          OrderStatus
                                                              .ORDER_PROCESSING
                                                      ? Text(
                                                          "PROCESSING",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.orange,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        )
                                                      : widget.status ==
                                                              OrderStatus
                                                                  .ORDER_CREATED
                                                          ? Text(
                                                              "CREATED",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: appColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            )
                                                          : "",
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 9,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: setCustomFontWithAlignment(
                              widget.objOrder.pickupLocation,
                              15,
                              Color.fromRGBO(287, 287, 287, 1),
                              FontWeight.w500,
                              1,
                              TextAlign.left),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Container(
                            height: 2,
                            width: MediaQuery.of(context).size.width - 120,
                            child: Divider(
                              height: 1,
                              color: Color.fromRGBO(246, 246, 246, 1),
                            ),
                          ),
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
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: setCustomFontWithAlignment(
                              widget.objOrder.dropLocation,
                              15,
                              Color.fromRGBO(287, 287, 287, 1),
                              FontWeight.w500,
                              1,
                              TextAlign.left),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
