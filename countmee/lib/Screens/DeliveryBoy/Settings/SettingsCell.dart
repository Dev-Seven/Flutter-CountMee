import 'package:countmee/Screens/DeliveryBoy/Settings/Permissions.dart';
import 'package:countmee/Screens/DeliveryBoy/Settings/support.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/*
Title : SettingsCell
Purpose: SettingsCell
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class SettingsCell extends StatefulWidget {
  final title;

  SettingsCell({Key key, @required this.title}) : super(key: key);
  @override
  _SettingsCellState createState() => _SettingsCellState();
}

class _SettingsCellState extends State<SettingsCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
            shape: BoxShape.rectangle,
            boxShadow: [getdefaultShadow()]),
        child: InkWell(
          onTap: () async {
            if (widget.title == 'Permissions') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Permissions(),
                      fullscreenDialog: false));
            }
            if (widget.title == "About Us") {
              const url = 'http://countmee.com/#aboutus';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }
            if (widget.title == 'Support') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SupportUsVc(),
                      fullscreenDialog: false));
            }
          },
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                height: 50,
                child: setCustomFont(
                    widget.title, 16, textBlackColor, FontWeight.w400, 1),
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios_rounded),
              SizedBox(
                width: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
