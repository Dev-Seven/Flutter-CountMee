import 'package:countmee/Model/PandingDataModel.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/DeliveredOrderDetailVC.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/OrderDetailVC.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:flutter/material.dart';


/*
Title : DeliveredOrderCell
Purpose: DeliveredOrderCell
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class DeliveredOrderCell extends StatefulWidget {
  final PandingDataModel objOrder;
  final bool isFromNotification;
  final collectionId;
  final address;
  final addressLat;
  final addressLng;

  const DeliveredOrderCell({
    Key key,
    this.objOrder,
    this.isFromNotification,
    this.collectionId,
    this.address,
    this.addressLng,
    this.addressLat,
  }) : super(key: key);

  @override
  _DeliveredOrderCellState createState() => _DeliveredOrderCellState();
}

class _DeliveredOrderCellState extends State<DeliveredOrderCell> {
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
                              if (widget.isFromNotification == false) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DeliveredOrderDetailVC(
                                              objOrder: widget.objOrder,
                                            ),
                                        fullscreenDialog: false));
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderDetailVC(
                                      orderId: widget.objOrder.id,
                                      collectionId: widget.collectionId,
                                      address: widget.address,
                                      addressLat: widget.addressLat,
                                      addressLng: widget.addressLng,
                                    ),
                                    fullscreenDialog: false,
                                  ),
                                );
                              }
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
                                    widget.address != null
                                        ? widget.address
                                        : widget.objOrder
                                                    .updatedPickupLocation !=
                                                "-"
                                            ? widget
                                                .objOrder.updatedPickupLocation
                                            : widget.objOrder.pickupLocation !=
                                                    null
                                                ? widget.objOrder.pickupLocation
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
                                        : widget.objOrder.dropLocation != null
                                            ? widget.objOrder.dropLocation
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
