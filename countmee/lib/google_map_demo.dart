import 'dart:async';

import 'package:countmee/Model/UserModel.dart';
import 'package:countmee/Screens/DeliveryBoy/Order/OrderDeliveredVC.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

const double CAMERA_ZOOM = 14;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;

class MapPage extends StatefulWidget {
  final String pickupLocation;
  final String dropLocation;
  final String pickupLat;
  final String pickupLng;
  final String dropLat;
  final String dropLng;
  final String mobileNo;

  const MapPage(
      {Key key,
      this.pickupLocation,
      this.dropLocation,
      this.pickupLat,
      this.pickupLng,
      this.dropLat,
      this.dropLng,
      this.mobileNo})
      : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  // Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  bool hasError = false;
  var controller = TextEditingController();
  LatLng SOURCE_LOCATION;
  LatLng DEST_LOCATION;
  var isLoading = false;
  var isResendOTP = false;
  var isButtonEnable = false;
  var strOTP = "";
  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;
  String _comingSms = 'Unknown';

  @override
  void initState() {
    super.initState();
    // polylinePoints = PolylinePoints();
    location = new Location();

    location.onLocationChanged().listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
      updatePinOnMap();
    });

    setSourceAndDestinationIcons();

    setInitialLocation();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void setSourceAndDestinationIcons() {
    sourceIcon = BitmapDescriptor.defaultMarker;
    destinationIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();

    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var currentPin =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == 'currentPin');
      _markers.add(Marker(
        markerId: MarkerId('currentPin'),
        position: currentPin, // updated position
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    SOURCE_LOCATION =
        LatLng(double.parse(widget.pickupLat), double.parse(widget.pickupLng));
    DEST_LOCATION =
        LatLng(double.parse(widget.dropLat), double.parse(widget.dropLng));

    CameraPosition initialLocation = CameraPosition(
      target: SOURCE_LOCATION,
      zoom: CAMERA_ZOOM,
      bearing: CAMERA_BEARING,
      tilt: CAMERA_TILT,
    );

    if (currentLocation != null) {
      initialLocation = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }

    void setMapPins() {
      setState(() {
        _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: SOURCE_LOCATION,
          icon: sourceIcon,
        ));

        _markers.add(Marker(
          markerId: MarkerId('destinationPin'),
          position: DEST_LOCATION,
          icon: destinationIcon,
        ));
      });
    }

    void setPolyPins() async {
      List<PolylineWayPoint> _waypoints = [
        PolylineWayPoint(
            location:
                "${SOURCE_LOCATION.latitude},${SOURCE_LOCATION.longitude}",
            stopOver: false),
        PolylineWayPoint(
            location: "${DEST_LOCATION.latitude},${DEST_LOCATION.longitude}",
            stopOver: false),
      ];

      PolylineResult result = await polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude),
        PointLatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude),
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print(result.errorMessage);
      }

      setState(() {
        Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: appColor,
          points: polylineCoordinates,
          width: 3,
        );
        _polylines.add(polyline);
      });
      // polylines[id] = polyline;
    }

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              markers: _markers,
              polylines: _polylines,
              mapType: MapType.normal,
              initialCameraPosition: initialLocation,
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(Utils.mapStyles);
                _controller.complete(controller);
                setMapPins();
                setPolyPins();
              },
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  setbuttonWithChild(Icon(Icons.arrow_back_ios), () {
                    Navigator.pop(context);
                  }, Colors.transparent, Colors.transparent, 0),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(18, 10, 15, 10),
                      child: Column(
                        children: [
                          // Row(
                          //   children: [
                          //     setImageName("secondUserImage.png", 45, 45),
                          //     SizedBox(
                          //       width: 15,
                          //     ),
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         setCustomFont("Bobby P. Kennedy", 14,
                          //             textBlackColor, FontWeight.w700, 1),
                          //         SizedBox(
                          //           height: 5,
                          //         ),
                          //         setCustomFont("Credit Card", 12, appColor,
                          //             FontWeight.w400, 1),
                          //       ],
                          //     ),
                          //     Spacer(),
                          //     Container(
                          //       height: 30,
                          //       alignment: Alignment.topCenter,
                          //       child: setCustomFont(
                          //           "₹20", 16, appColor, FontWeight.w700, 1),
                          //     )
                          //   ],
                          // ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 140,
                            // color: Colors.red,
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
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
                                      height: 8,
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 3,
                                        height: 3,
                                        color: Color.fromRGBO(239, 239, 239, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 3,
                                        height: 3,
                                        color: Color.fromRGBO(239, 239, 239, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 3,
                                        height: 3,
                                        color: Color.fromRGBO(239, 239, 239, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 3,
                                        height: 3,
                                        color: Color.fromRGBO(239, 239, 239, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 3,
                                        height: 3,
                                        color: Color.fromRGBO(239, 239, 239, 1),
                                      ),
                                    ),
                                    SizedBox(height: 8),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Spacer(),
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
                                        width:
                                            MediaQuery.of(context).size.width -
                                                120,
                                        child: setCustomFontWithAlignment(
                                            widget.pickupLocation,
                                            //   "Interno LLC",
                                            15,
                                            Color.fromRGBO(287, 287, 287, 1),
                                            FontWeight.w500,
                                            1,
                                            TextAlign.left),
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          Container(
                                            height: 1,
                                            width: Device.screenWidth - 150,
                                            child: Divider(
                                              height: 1,
                                              color: Color.fromRGBO(
                                                  246, 246, 246, 1),
                                            ),
                                          ),
                                          // setImageName("iconDivider.png", 30, 30)
                                        ],
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
                                        width:
                                            MediaQuery.of(context).size.width -
                                                120,
                                        child: setCustomFontWithAlignment(
                                            widget.dropLocation,
                                            //   "Interno LLC",
                                            15,
                                            Color.fromRGBO(287, 287, 287, 1),
                                            FontWeight.w500,
                                            1,
                                            TextAlign.left),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      // height: 189,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          boxShadow: [getShadow(0, 0, 15)]),
                    ),
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Container(
                  //     padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  //     height: 57,
                  //     width: double.infinity,
                  //     child: setbuttonWithChild(
                  //             setCustomFont("Delivered", 16, Colors.white,
                  //                 FontWeight.w400, 1.5), () {
                  //           _newTaskModalBottomSheet(context);
                  //         }, appColor, 5),
                  //       ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _newTaskModalBottomSheet(context) {
    getCalculated(double value) {
      double height = MediaQuery.of(context).size.height;
      if (height >= 800.0 && height <= 895.0) {
        // For devices Iphone 10 range. For android hd.
        return 667.0 * (value / 568.0);
      } else if (height >= 896.0) {
        // For XR and XS max.
        return 736.0 * (value / 568.0);
      } else {
        // For other.
        return height * (value / 568.0);
      }
    }

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15)),
                  color: Colors.white),
              height: WidgetsBinding.instance.window.viewInsets.bottom > 0.0
                  ? getCalculated(450)
                  : getCalculated(300),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 23,
                    ),
                    setCustomFont("Enter OTP for delivered order", 14,
                        textBlackColor, FontWeight.w400, 1.5),
                    SizedBox(
                      height: 27,
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      width: MediaQuery.of(context).size.width,
                      height: 57,
                      child: PinCodeTextField(
                        autofocus: false,
                        controller: controller,
                        hideCharacter: false,
                        highlight: true,
                        pinBoxOuterPadding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 22,
                            0,
                            MediaQuery.of(context).size.width / 22,
                            0),
                        highlightColor: Color.fromRGBO(223, 223, 223, 1),
                        defaultBorderColor: Color.fromRGBO(223, 223, 223, 1),
                        hasTextBorderColor: Color.fromRGBO(223, 223, 223, 1),
                        highlightPinBoxColor: Colors.transparent,
                        pinBoxBorderWidth: 1,
                        pinBoxRadius: 5,
                        maxLength: 4,
                        hasError: hasError,
                        onTextChanged: (text) {
                          setState(() {
                            strOTP = text;
                            hasError = false;
                            // if (strOTP.length == 4) {
                            //   _onSubmitTap();
                            // }
                          });
                        },
                        pinBoxWidth: 57,
                        pinBoxHeight: 57,
                        hasUnderline: false,
                        wrapAlignment: WrapAlignment.center,
                        pinBoxDecoration:
                            ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                        pinTextStyle: TextStyle(fontSize: 22.0),
                        pinTextAnimatedSwitcherTransition:
                            ProvidedPinBoxTextAnimation.scalingTransition,
                        pinTextAnimatedSwitcherDuration:
                            Duration(milliseconds: 300),
                        highlightAnimationBeginColor: Colors.black,
                        highlightAnimationEndColor: Colors.white12,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        width: MediaQuery.of(context).size.width,
                        height: 57,
                        child: setbuttonWithChild(
                            isLoading
                                ? Container(
                                    width: 30,
                                    height: 30,
                                    child: setButtonIndicator(4, Colors.white),
                                  )
                                : setCustomFont("Verify", 16, Colors.white,
                                    FontWeight.w400, 1),
                            _onSubmitTap,
                            appColor,
                            Colors.purple[900],
                            5)),
                    SizedBox(
                      height: 30,
                    ),
                    setCustomFont("Didn't receive the verification OTP?", 16,
                        textBlackColor, FontWeight.w400, 1),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: _onresendOTPTap,
                      child: Container(
                          width: 200,
                          alignment: Alignment.center,
                          child: isResendOTP
                              ? Container(
                                  width: 30,
                                  height: 30,
                                  child: setButtonIndicator(3, appColor),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  child: setCustomFont("Resend OTP", 15,
                                      appColor, FontWeight.w400, 1),
                                )),
                    ),
                  ],
                ),
              ));
        });
  }

  _onSubmitTap() {
    FocusScope.of(context).unfocus();
    if (strOTP.length < 1) {
      showCustomToast("Verification code is required", context);
      return;
    } else if (strOTP.length < 4) {
      showCustomToast("Please enter correct OTP", context);
      return;
    }
    setState(() {
      isLoading = true;
    });

    FormData formData = FormData.fromMap({
      "phone_number": widget.mobileNo,
      "otp": strOTP,
      // "role":"4",
    });

    postDataRequest(checkOTP, formData).then((value) => {
          setState(() {
            isLoading = false;
          }),
          if (value is Map)
            {
              _responseHandling(value[kData]),
            }
          else
            {showCustomToast(value.toString(), context)},
        });
  }

  _responseHandling(userData) async {
    UserModel user = UserModel.fromJson(userData);
    userObj = user;
    setUserData();
    if (user.status == 1) {
      if (user.role == 5) {
        showCustomToast("Successful", context);
        pushToViewController(context, OrderdeliveredVC(), () {});
      } else {
        showCustomToast("Invalid Credential", context);
      }
    } else {}
  }

  _onresendOTPTap() {
    setState(() {
      isResendOTP = true;
    });
    FormData formData = FormData.fromMap({
      "phone_number": widget.mobileNo,
    });
    postDataRequest(resendOTPApi, formData).then((value) => {
          setState(() {
            isResendOTP = false;
          }),
          if (value is Map)
            {
              showGreenToast(value[kMessage].toString(), context),
            }
          else
            {
              showCustomToast(value.toString(), context),
              setState(() {
                isLoading = false;
              })
            },
        });
  }
}

class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}
