import 'package:countmee/Model/notificationListModel.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:countmee/Utility/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'NotificationCell.dart';

/*
Title : Notification Screen
Purpose: Notification Screen
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class NotificationVC extends StatefulWidget {
  @override
  _NotificationVCState createState() => _NotificationVCState();
}

class _NotificationVCState extends State<NotificationVC> {
  bool _isLoading = false;
  List<NotificationData> _notifications;
  bool isclearVisible = true;

  @override
  void initState() {
    super.initState();

    getNotifications();
  }

  getNotifications() {
    setState(() {
      _isLoading = true;
    });

    postDataRequestWithToken(getNotificationList, null, context).then((value) {
      if (value[kData] is List) {
        setState(() {
          _isLoading = false;
        });
        _handeleNotificationListResponse(value[kData]);
      } else {
        showCustomToast(value as String, context);
      }
    });
  }

  _handeleNotificationListResponse(value) {
    print("NOTIFICATION RESPONSE : LINE 52 : $value");

    var arrData = value
        .map<NotificationData>((json) => NotificationData.fromJson(json))
        .toList();
    setState(() {
      _notifications = arrData;
    });

    print("NOTIFICATION Length : ${_notifications.length}");
    // NotificatioListModel notificatioListModel =
    //     NotificatioListModel.fromJson(value);
    // if (notificatioListModel != null) {
    //   _notifications = notificatioListModel.data;

    //   print("${_notifications.length}");
    // } else {
    //   print("object");
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (isConnected == true) {
      setState(() {
        getNotifications();
        isConnected = false;
      });
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: setCustomFont(
          "Notifications",
          20,
          textBlackColor,
          FontWeight.w700,
          1,
        ),
        leading: setbuttonWithChild(
          Icon(
            Icons.arrow_back_ios,
          ),
          () {
            Navigator.pop(context);
          },
          Colors.transparent,
          Colors.transparent,
          0,
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Shimmer_List_Style(1),
              )
            : Container(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  shrinkWrap: false,
                  itemCount: _notifications.length,
                  itemBuilder: (context, position) {
                    return NotificationCell(
                      _notifications[position],
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: Visibility(
        visible: isclearVisible,
        child: new FloatingActionButton.extended(
          backgroundColor: appColor,
          onPressed: () {
            onClearAllTap();
          },
          label: Text(
            "Clear All",
            style: Theme.of(context).textTheme.caption.copyWith(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  onClearAllTap() {
    setState(() {
      _notifications.clear();
      isclearVisible = false;
    });
  }
}
