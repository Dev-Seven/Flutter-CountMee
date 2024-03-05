import 'package:countmee/Model/notificationListModel.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:google_fonts/google_fonts.dart';

/*
Title : NotificationCell
Purpose: NotificationCell
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class NotificationCell extends StatefulWidget {
  NotificationData notificationData;
  NotificationCell(this.notificationData);

  @override
  _NotificationCellState createState() => _NotificationCellState();
}

class _NotificationCellState extends State<NotificationCell> {
  double height, width;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
          shape: BoxShape.rectangle,
          boxShadow: [
            getdefaultShadow(),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      //width: MediaQuery.of(context).size.width / 1.4,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              widget.notificationData.title != null
                                  ? widget.notificationData.title
                                  : "",
                              style: TextStyle(
                                fontSize: 16,
                                color: textBlackColor,
                                fontWeight: FontWeight.w700,
                                height: 1,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              timeago.format(widget.notificationData.createdAt,
                                  allowFromNow: true),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  color: Color.fromRGBO(178, 178, 178, 1),
                                  height: 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 100,
                        alignment: Alignment.centerLeft,
                        child: setCustomFontLeftAlignment(
                          widget.notificationData.message != null
                              ? widget.notificationData.message
                              : "",
                          14,
                          textBlackColor,
                          FontWeight.w400,
                          1,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
