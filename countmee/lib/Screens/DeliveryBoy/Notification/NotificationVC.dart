import 'package:countmee/Model/notificationListModel.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:flutter/material.dart';

import 'NotificationCell.dart';

/*
Title : NotificationVC
Purpose: NotificationVC
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
  List<NotificationData> _notifications = [];
  bool isclearVisible = true;

  @override
  void initState() {
    super.initState();
    getNotifications();
    checkConnection(context);
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  getNotifications() {
    setState(() {
      _isLoading = true;
    });
    postDataRequestWithToken(notificationAPI, null, context).then((value) {
      print(value);
      setState(() {
        _isLoading = false;
      });

      if (value == "No notification Found") {
        setState(() {
          isclearVisible = false;
        });
      } else {
        if (value != null) {
          _handeleNotificationListResponse(value);
        } else {
          showCustomToast(value as String, context);
        }
      }
    });
  }

  _handeleNotificationListResponse(value) {
    print(value);
    NotificatioListModel notificatioListModel =
        NotificatioListModel.fromJson(value);
    if (notificatioListModel != null) {
      _notifications = notificatioListModel.data;
    }

    print("NOTIFIcTION: $_notifications");
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
          Icon(Icons.arrow_back_ios),
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
            ? Center(
                child: CircularProgressIndicator(
                color: appColor,
                strokeWidth: 2,
              ))
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
    if (_notifications.length != 0) {
      setState(() {
        _notifications.clear();
        isclearVisible = false;
      });
    }
  }
}
