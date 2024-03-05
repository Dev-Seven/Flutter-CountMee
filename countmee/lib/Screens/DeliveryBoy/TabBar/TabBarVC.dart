import 'package:countmee/Screens/ContactUS/ContactUS.dart';
import 'package:countmee/Screens/DeliveryBoy/Commision/CommisionVC.dart';
import 'package:countmee/Screens/DeliveryBoy/Document/DocumentVC.dart';
import 'package:countmee/Screens/DeliveryBoy/Home/HomeVC.dart';
import 'package:countmee/Screens/DeliveryBoy/Notification/NotificationVC.dart';
// ignore: unused_import
import 'package:countmee/Screens/DeliveryBoy/Order/OrderDeliveredVC.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/OrdersVC.dart';
import 'package:countmee/Screens/DeliveryBoy/Profile/MyProfileVC.dart';
import 'package:countmee/Screens/DeliveryBoy/Settings/SettingsVC.dart';
import 'package:countmee/Screens/DeliveryBoy/TabBar/SidemenuVC.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:cron/cron.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart' as geo;

/*
Title : TabbarVC
Purpose: TabbarVC
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class TabbarVC extends StatefulWidget {
  final orderId;
  const TabbarVC({
    Key key,
    this.orderId,
  }) : super(key: key);
  @override
  _TabbarVCState createState() => _TabbarVCState();
}

class _TabbarVCState extends State<TabbarVC> with Observer {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _index = 0;
  double height, width;
  var selectedOrder = "";
  bool isAllowInSplash = false;
  Position _currentPosition;
  String _currentAddress;

  @override
  void initState() {
    Observable.instance.addObserver(this);
    super.initState();
    _getCurrentLocation();
    checkHome();
  }

  checkHome() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isAllowInSplash = prefs.getBool("IsAllow");

    if (isAllowInSplash == true) {
      print(isAllowInSplash);
      final cron = Cron();
      cron.schedule(Schedule.parse('*/2 * * * *'), () async {
        _getCurrentLocation();
      });
    } else {
      print("ELSE PART CHECK HOOME");
    }
  }

  _getCurrentLocation() {
    BuildContext context;
    Geolocator.getCurrentPosition(
            desiredAccuracy: geo.LocationAccuracy.best,
            forceAndroidLocationManager: false)
        .then((Position position) {
      _currentPosition = position;

      _getAddressFromLatLng(context);
    }).catchError((e) async {
      LocationPermission permission = await Geolocator.requestPermission();
    });
  }

  _getAddressFromLatLng(BuildContext context) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentPosition.latitude,
      _currentPosition.longitude,
    );
    Placemark place = placemarks[0];

    _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
    updateLatLong(context);
  }

  updateLatLong(BuildContext context) {
    FormData formData;

    formData = FormData.fromMap({
      "location": _currentAddress,
      "latitude": _currentPosition.latitude,
      "longitude": _currentPosition.longitude,
    });

    postDataRequestWithToken(getDeliveryLocation, formData, context)
        .then((value) {
      if (value is Map) {
        print(value);
      } else {
        print(
          value.toString(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => TabbarVC()),
            (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
        drawer: Drawer(
          child: SideMenuVC(),
        ),
        key: _scaffoldKey,
        bottomNavigationBar: _buildBottomNavigationBar(),
        body: _getIndex(_index),
      ),
    );
  }

  void openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  pushToProfileView() {
    pushToViewController(context, MyProfileVC(), () {
      setState(() {
        userObj.image;
      });
    });
  }

  pushToHome() {
    setState(() {
      _index = 0;
    });
  }

  pushToDocument() {
    pushToViewController(context, DocumentVC(), () {});
  }

  pushToNotification() {
    pushToViewController(context, NotificationVC(), () {});
  }

  pushToSettings() {
    pushToViewController(context, SettingsVC(), () {});
  }

  pushToContactUs() {
    pushToViewController(context, ContactUsVC(), () {});
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  Widget _getIndex(index) {
    switch (index) {
      case 0:
        {
          return HomeVC(
            orderId: widget.orderId,
          );
        }
        break;
      case 1:
        {
          return OrdersVC(
            strInfo: selectedOrder,
          );
        }
        break;
      case 2:
        {
          return CommisionVC(
            isFromNotification: false,
          );
        }
        break;
    }
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 10,
          ),
        ],
      ),
      child: BottomNavigationBar(
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(
              ExactAssetImage(
                "assets/images/iconTabHome.png",
              ),
              size: 28,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              ExactAssetImage(
                "assets/images/iconTabOrder.png",
              ),
              size: 28,
            ),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              ExactAssetImage(
                "assets/images/iconTabCommision.png",
              ),
              size: 28,
            ),
            label: "Commission",
          ),
        ],
        currentIndex: _index,
        selectedItemColor: appColor,
        unselectedItemColor: Color.fromRGBO(178, 178, 178, 1),
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  update(Observable observable, String notifyName, Map map) {
    if (map != null && map.containsKey("OpenSideMenu")) {
      openDrawer();
    } else if (map != null && map.containsKey("PushToHome")) {
      pushToHome();
    } else if (map != null && map.containsKey("PushToProfile")) {
      pushToProfileView();
    } else if (map != null && map.containsKey("PushToDocument")) {
      pushToDocument();
    } else if (map != null && map.containsKey("PushToNotification")) {
      pushToNotification();
    } else if (map != null && map.containsKey("PushToSettings")) {
      pushToSettings();
    } else if (map != null && map.containsKey("PushToContactUs")) {
      pushToContactUs();
    } else if (map != null && map.containsKey("ViewOrderTab")) {
      setState(() {
        _index = 1;
      });
    } else if (map != null && map.containsKey("ViewDOrder")) {
      setState(() {
        selectedOrder = "ViewDOrder";
        _index = 1;
      });
    } else if (map != null && map.containsKey("ViewPOrder")) {
      setState(() {
        selectedOrder = "ViewPOrder";
        _index = 1;
      });
    } else if (map != null && map.containsKey("ViewROrder")) {
      setState(() {
        selectedOrder = "ViewROrder";
        _index = 1;
      });
    }
  }
}
