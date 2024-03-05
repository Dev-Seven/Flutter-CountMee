import 'package:countmee/Screens/Customer/Home/HomeVC.dart';
import 'package:countmee/Utility/APIManager.dart';
import 'package:countmee/Utility/Constant.dart';
import 'package:countmee/Utility/Global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_place/google_place.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geocoding/geocoding.dart' as geoCode;

/*
Title : Location Screen
Purpose: Location Screen
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class LocationVC extends StatefulWidget {
  @override
  _LocationVCState createState() => _LocationVCState();
}

class _LocationVCState extends State<LocationVC> {
  var controller = TextEditingController();
  bool hasError = false;
  var isButtonEnable = false;
  var isLoading = false;
  var isResendOTP = false;
  var strOTP = "";
  var maskedNewEmail = "";
  var selectedLoccation = Location();
  var selectedAddress = "";
  var kInitialPosition = LatLng(-33.8567844, 151.213108);
  var isLocationSelected = false;
  double currentLong;
  double currentLat;
  Position _currentPosition;
  List<geoCode.Placemark> placemarks;
  String _currentAddress;
  geoCode.Placemark place;
  bool isDefaultlocation = false;

  @override
  void initState() {
    super.initState();
    // checkLocationStatus();
    _getCurrentLocation();
    // getLocationPermission();
  }

  _getCurrentLocation() {
    BuildContext context;
    Geolocator.getCurrentPosition(
            desiredAccuracy: geo.LocationAccuracy.best,
            forceAndroidLocationManager: false)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng(context);
    }).catchError((e) async {
      LocationPermission permission = await Geolocator.requestPermission();
    });
  }

  _getAddressFromLatLng(BuildContext context) async {
    placemarks = await geoCode.placemarkFromCoordinates(
      _currentPosition.latitude,
      _currentPosition.longitude,
    );

    print("PLACE MARK : $placemarks");

    place = placemarks[0];

    if (place != null) {
      setState(() {
        selectedAddress =
            "${place.name},  ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea},  ${place.country}";
      });
    }
  }

  void getLocationPermission() async {
    var status = await Permission.location.request();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Center(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: setCustomFont(
                "Location",
                20,
                textBlackColor,
                FontWeight.w700,
                1,
              ),
            ),
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        setImageName("LocationBanner.png", 200, 170),
                        SizedBox(
                          height: 60,
                        ),
                        GestureDetector(
                          onTap: () {
                            _locationUpdateEvent();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            width: MediaQuery.of(context).size.width,
                            height: 57,
                            child: Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 17,
                                  ),
                                  setImageName("iconLocation.png", 20, 20),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Flexible(
                                    child: setCustomFontWithWarp(
                                      selectedAddress == null
                                          ? "Your Current Location"
                                          : selectedAddress,
                                      14,
                                      Colors.black,
                                      // Color.fromRGBO(187, 187, 187, 1),
                                      FontWeight.w400,
                                      1,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),

                                  //  color: Colors.orange,
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  boxShadow: [getdefaultShadow()]),
                              height: 57,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
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
                                        child:
                                            setButtonIndicator(4, Colors.white),
                                      )
                                    : setCustomFont("Done", 16, Colors.white,
                                        FontWeight.w400, 1),
                                _onSubmitTap,
                                appColor,
                                Colors.purple[900],
                                5)),
                      ],
                    ),
                  ),
                ),
                setLoadingState(isLoading, context)
              ],
            ),
          ),
        ));
  }

  _onSubmitTap() {
    FocusScope.of(context).unfocus();
    FormData formData = FormData.fromMap({
      "location": selectedAddress,
      "latitude": isDefaultlocation == false
          ? _currentPosition.latitude
          : selectedLoccation.lat,
      "longitude": isDefaultlocation == false
          ? _currentPosition.longitude
          : selectedLoccation.lng
    });

    postDataRequestWithToken(updateLocation, formData, context)
        .then((value) => {
              setState(() {
                isLoading = false;
              }),
              if (value is Map)
                {
                  AlertMessage(
                    "Sign In Successfully",
                    context,
                    () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeVC(),
                            fullscreenDialog: false),
                        (route) => false,
                      );
                    },
                  ),
                }
              else
                {
                  showCustomToast(value.toString(), context),
                },
            });
  }

  _locationUpdateEvent() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) {
              return Theme(
                data: ThemeData(
                  primaryColor: appColor,
                  buttonTheme: ButtonThemeData(
                    buttonColor: appColor,
                    textTheme: ButtonTextTheme.primary,
                  ),
                ),
                child: PlacePicker(
                  apiKey: googleAPIKey,
                  initialPosition: kInitialPosition,
                  selectInitialPosition: true,
                  useCurrentLocation: true,
                  onPlacePicked: (results) {
                    setState(() {
                      isDefaultlocation == true;
                      selectedAddress = results.formattedAddress;
                      selectedLoccation = Location(
                        lat: results.geometry.location.lat,
                        lng: results.geometry.location.lng,
                      );
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            },
            fullscreenDialog: false));
    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      await Geolocator.getCurrentPosition().then((value) => {});
    }
  }
}
