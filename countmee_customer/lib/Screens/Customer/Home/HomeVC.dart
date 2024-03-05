import 'package:countmee/Model/MyOrderModel.dart';
import 'package:countmee/Model/UserAPIDetails.dart';
import 'package:countmee/Model/cityListModel.dart';
import 'package:countmee/Screens/ContactUS/ContactUS.dart';
import 'package:countmee/Screens/Customer/Notification/NotificationVC.dart';
import 'package:countmee/Screens/Customer/Order/MyOrderVC.dart';
import 'package:countmee/Screens/Customer/Order/OngoingOrderCell.dart';
import 'package:countmee/Screens/Customer/Package/SendPackege.dart';
import 'package:countmee/Screens/Customer/Profile/MyProfileVC.dart';
import 'package:countmee/Screens/Customer/Settings/SettingsVC.dart';
import 'package:countmee/Screens/Customer/TabBar/SidemenuVC.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';

/*
Title : HomePage Screen
Purpose: HomePage Screen
Created By : Kalpesh Khandla
Last Edited By : 3 Feb 2022
*/

class HomeVC extends StatefulWidget {
  @override
  _HomeVCState createState() => _HomeVCState();
}

class _HomeVCState extends State<HomeVC> with Observer {
  FocusNode _node;
  TextEditingController controller;
  Function onTextChange;
  Function onFilterTap;
  bool isFromStylist;
  var selectedCity = "";
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _index = 0;
  List<MyOrderModel> arrPastOrderList = List.from([MyOrderModel()]);
  List<MyOrderModel> allOrderList = List.from([MyOrderModel()]);
  var isListLoading = false;
  String userProfileImgName;
  bool isLoading = false;
  UserAPIDetails senderData;
  UserAPIDetails reciverData;
  List<CityListModel> cityList = [];
  bool isCityPopupOpen = false;

  @override
  void initState() {
    super.initState();
    checkConnection(context);
    getCitiesList();
    Observable.instance.addObserver(this);
    arrPastOrderList.clear();
    getMyOrderList();
    getProfileImage();
  }

  @override
  void dispose() {
    // listener.cancel();
    super.dispose();
  }

  displayBottomSheet() {
    showBottomSheet(
        context: context,
        builder: (context) => Container(
              color: Colors.red,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
            ));
  }

  getCitiesList() {
    postDataRequestWithToken(cityListAPI, null, context).then((value) {
      if (value is Map) {
        if (value[kStatusCode] == 200) {
          _handleDataResponse(value[kData]);
        } else if (value[kStatusCode] == 500) {
          showCustomToast(
              'Something went wrong.\nplease check after sometime.', context);
        } else {
          showCustomToast(value[kMessage].toString(), context);
        }
      } else {
        showCustomToast(value.toString(), context);
      }
    });
  }

  _handleDataResponse(value) {
    var arrData = value
        .map<CityListModel>((json) => CityListModel.fromJson(json))
        .toList();

    cityList.clear();
    setState(() {
      cityList = arrData;
      isLoading = false;
      selectedCity = cityList[0].name ?? "";
    });
  }

  getProfileImage() {
    isLoading = false;
    if (userObj.image == null) {
      setState(() {
        isLoading = true;
      });
    } else {
      isLoading = false;
      setState(() {
        userProfileImgName = userObj.image;
      });
    }
  }

  getpastOrder() {
    setState(() {
      isListLoading = true;
    });
    postDataRequestWithToken(getPastOrderAPI, null, context).then((value) {
      setState(() {
        isListLoading = false;
      });
      if (value[kStatusCode] == 200) {
        if (value[kData] is List) {
          _handleListResponse(value[kData]);
        } else {
          showCustomToast(value[kMessage], context);
        }
      } else if (value[kStatusCode] == 500) {
          showCustomToast(
              'Something went wrong.\nplease check after sometime.', context);
        }  else {
        showCustomToast(value.toString(), context);
      }
    });
  }

  _handleListResponse(value) {
    var arrData =
        value.map<MyOrderModel>((json) => MyOrderModel.fromJson(json)).toList();
    arrPastOrderList = arrData;
  }

  getMyOrderList() {
    setState(() {
      isListLoading = true;
    });
    arrPastOrderList.clear();
    allOrderList.clear();

    postDataRequestWithToken(getOrderList, null, context).then((value) {
      if (mounted) {
        setState(() {
          isListLoading = false;
        });
      }

      if (value is Map) {
        if (value[kStatusCode] == 200) {
          _handleAllDataResponse(value[kData]);
        } else if (value[kStatusCode] == 500) {
          showCustomToast(
              'Something went wrong.\nplease check after sometime.', context);
        } else {
          showCustomToast(value[kMessage].toString(), context);
        }
      } else {
        showCustomToast(value.toString(), context);
      }
    });
  }

  _handleAllDataResponse(value) {
    var arrData =
        value.map<MyOrderModel>((json) => MyOrderModel.fromJson(json)).toList();
    setState(() {
      allOrderList = arrData;
    });

    if (allOrderList.length >= 5) {
      setState(() {
        arrPastOrderList = allOrderList.take(5).toList();
      });
    } else {
      setState(() {
        isListLoading = false;
        arrPastOrderList = allOrderList;
      });
    }

    // for (int i = 0; i <= 4; i++) {
    //   arrPastOrderList.add(allOrderList[i]);
    // }
    // setState(() {
    //   isListLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (isConnected == true) {
      setState(() {
        getCitiesList();
        getMyOrderList();
        getProfileImage();
        isConnected = false;
      });
    }
    return Scaffold(
      drawer: Drawer(
        child: userObj != null ? SideMenuVC() : Container(),
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        isCityPopupOpen != isCityPopupOpen;
                        // getCitiesList();
                      });
                      afterDelay(1, () {
                        showCityListPopup();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        setCustomFont(
                            "Select City",
                            14,
                            Color.fromRGBO(178, 178, 178, 1),
                            FontWeight.w400,
                            1),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            setCustomFont(
                              selectedCity,
                              16,
                              textBlackColor,
                              FontWeight.w400,
                              1,
                            ),
                            Icon(Icons.keyboard_arrow_down)
                          ],
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                    child: ClipOval(
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.transparent,
                        child: setProfileImage(userProfileImgName),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              arrPastOrderList == null
                  ? InkWell(
                      onTap: () {
                        pushToViewController(
                          context,
                          SendPackage(),
                          () {},
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: setImageWithName("dashboardBanner.png"),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  setCustomFont(
                    "My Orders",
                    16,
                    textBlackColor,
                    FontWeight.w600,
                    1,
                  ),
                  Spacer(),
                  InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      pushToViewController(
                        context,
                        MyOrderVC(),
                        () {},
                      );
                    },
                    child: Container(
                      child: setCustomFont(
                        "View All",
                        12,
                        appColor,
                        FontWeight.w500,
                        1,
                      ),
                      height: 25,
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              isListLoading
                  ? Expanded(
                      child: Center(
                        child: setButtonIndicator(2, appColor),
                      ),
                    )
                  : (!isListLoading && arrPastOrderList.length < 1)
                      ? Expanded(
                          child: Center(
                            child: setCustomFont(
                              "Orders not available",
                              15,
                              Colors.grey,
                              FontWeight.w400,
                              1.5,
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            shrinkWrap: false,
                            itemCount: arrPastOrderList.length,
                            itemBuilder: (context, position) {
                              return OngoingOrderCell(
                                objOrder: arrPastOrderList[position],
                                status: arrPastOrderList[position].status,
                              );
                            },
                          ),
                        ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: 57,
                child: ClipRRect(
                  child: setbuttonWithChild(
                    setCustomFont("Start Sending Package", 16, Colors.white,
                        FontWeight.w400, 1.2),
                    () {
                      pushToViewController(
                        context,
                        SendPackage(),
                        () {
                          setState(() {
                            getMyOrderList();
                          });
                        },
                      );
                    },
                    appColor,
                    Colors.purple[900],
                    0,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showCityListPopup() {
    showGeneralDialog(
      pageBuilder: (c, a, a2) {},
      barrierDismissible: false,
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
                  height: MediaQuery.of(context).size.height / 2.7,
                  width: MediaQuery.of(context).size.width - 50,
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                    shrinkWrap: false,
                    itemCount: cityList.length,
                    itemBuilder: (context, position) {
                      return InkWell(
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            selectedCity = cityList[position].name;
                          });
                          print("SELECTED CITY : $selectedCity");
                          Navigator.pop(context);
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
                                          // selectedCity,
                                          (cityList[position].name),
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

  @override
  update(Observable observable, String notifyName, Map map) {
    if (map != null && map.containsKey("OpenSideMenu")) {
      _scaffoldKey.currentState.openDrawer();
    } else if (map != null && map.containsKey("PushToHome")) {
      pushToHome();
    } else if (map != null && map.containsKey("PushToProfile")) {
      pushToProfileView();
    } else if (map != null && map.containsKey("PushToOrderSummary")) {
      pushToOrderSummary();
    } else if (map != null && map.containsKey("PushToNotification")) {
      pushToNotification();
    } else if (map != null && map.containsKey("PushToSettings")) {
      pushToSettings();
    } else if (map != null && map.containsKey("PushToContactUs")) {
      pushToContactUs();
    }
  }

  pushToHome() {
    pushToViewController(context, HomeVC(), () {
      setState(() {
        getMyOrderList();
      });
    });
  }

  pushToProfileView() {
    pushToViewController(context, MyProfileVC(), () {
      setState(() {
        getProfileImage();
      });
    });
  }

  pushToOrderSummary() {
    pushToViewController(context, MyOrderVC(), () {});
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
}
