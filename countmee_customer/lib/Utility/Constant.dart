library constans;

import 'package:flutter/material.dart';

/*
Title : Constants File  
Purpose: Frequntly used constants are defined here
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

const String authToken =
    "eyJpdiI6IkcwRlgvS1pyYjZXZjJ0b212NkxNd0E9PSIsInZhbHVlIjoicDJjSW0zTFM3ZWk2bFp6VExMUUY2SU0zVXJVSU5wUmNGZHdQRy9lQkNuOS8vL1QvQU5tbzVrR3FBN1k4aTZ1MSIsIm1hYyI6ImEwMjViNjYzOGIwZTRiMTAxN2U5ZjM3OWJkZTk1OTY2MDg5YmExZWY5YzdlY2RjM2FmZWYxNTJjMGI3YzRmOGQifQ==";
const String SUCCESS_MESSAGE = " You will be contacted by us very soon.";
const Color appColorBlack = Colors.black;
const String googleAPIKey = "AIzaSyCd4SRV5noJI-6zFi97geKc1nN167nfaDU";

String getTime() {
  return 'temp';
}

enum audioFormat { m4a, mp3, caf, wav }

//colors
const Color backgroundColor = Color.fromRGBO(241, 243, 246, 1);
const Color appColor = Color.fromRGBO(137, 74, 229, 1);
const Color textBlackColor = Color.fromRGBO(38, 46, 58, 1);
const Color appGreenColor = Color.fromRGBO(66, 199, 35, 1);

const String popinsRegFont = 'Poppins Regular';
const String popinsBoldFont = 'Poppins Bold';

//iconsName
const String splashBackground = 'splash_screen.png';
const String introImage = 'introImage.png';
const String clientAuthImage = 'ClientAuth.png';
const String iconBack = 'IconBack.png';
const String stylistAuthImage = 'StylistAuth.png';
const String iconTabHome = "iconTabHome.png";
const String iconTabStylist = "iconTabStylist.png";
const String iconTabHistory = "iconTabHistory.png";
const String iconTabSettings = "iconTabSettings.png";
const String iconTabMyApp = "iconTabMyApp.png";
const String iconTabAdd = "iconTabAdd.png";

const String iconTrim = 'icon_trim.png';
const String iconRecordNew = 'icon_recordNew.png';
const String iconRecordingFile = 'iconrecording_file.png';
const String iconSettingButton = 'settings_button.png';
const String iconNextAudio = 'audio_next_icon.png';
const String iconPrevAudio = 'audio_prev_icon.png';
const String iconPlayAudio = 'icon_playbutton.png';
const String iconPauseAudio = 'icon_pauseAudio.png';
const String iconSkip5Sec = 'next5sec_icon.png';
const String iconPrev5Sec = 'prev5sec_icon.png';
const String iconClose = 'icon_close.png';
const String iconTrimSlider = 'icon_trimSlider.png';
const String musicPlaceholder = 'music_placeholder.png';
const String iconTrimAudio = 'icon_trim.png';
const String iconSaveTrimed = 'icon_save.png';
const String iconResetTrim = 'icon_resetTrim.png';
const String iconAppLogo = 'app_Logo.png';
const String iconUnselectAudio = 'icon_unselect_audio.png';
const String iconSelectAudio = 'icon_select_audio.png';
const String iconMenu = 'icon_menu_btn.png';
const String iconCloseMenu = 'icon_menuclose.png';
const String iconConvert = 'icon_convert.png';
const String iconSpeed = 'icon_speed.png';
const String iconMerge = 'icon_merge.png';
const String iconShare = 'icon_share.png';
const String iconDown = 'icon_down.png';
const String iconContactUs = 'icon_contactus.png';
const String iconNavLogo = 'navbar_logo.png';
const String iconCrown = "icon_crown.png";
const String iconNavNew = "iconNavNew.png";
const String iconAppbarNew = "app_bar_logo_new.png";
const String iconAudioFormat = 'audioformat_settings.png';
const String iconCloudSettings = 'cloud_settings.png';
const String iconRateUs = 'rateus_settings.png';
const String iconRecordingQuality = 'recordingquiality_Setings.png';
const String iconRestorePurchase = 'restorepurchase_Settings.png';
const String iconShareApp = 'shareapp_settings.png';
const String iconSort = 'sort_icon.png';
const String iconIntro1 = 'intro_1.png';
const String iconIntro2 = 'intro_2.png';
const String iconIntro3 = 'intro_3.png';
const String salesBackground = "background_sales.png";
const String iconCloseSales = "icon_close_sales.png";
const String iconCheckSales = "icon_check_sales.png";
const String iconRocketSales = "icon_rocket_sales.png";
const String iconSecuredSales = "icon_secured_sales.png";
const String iconRatingHeart = "icon_heart_rating.png";
const String iconRatingStar = "icon_start_rating.png";
//Text
const String savePattern = " ";

const String appName = "Waitlist Hero";
const String pleaseWait = "Please wait..";
const String msgEmptyEmail = "Email id is required";
const String msgInvalidEmail = "Please enter valid email id";
const String msgEmptyFirstName = "First name is required";
const String msgEmptyLastName = "Last name is required";
const String msgEmptyMobileNumber = "Mobile number is required";
const String msgInvalidPhoneNumber = "Please enter valid mobile number";
const String msgEmptyPassword = "Password is required";

const String msgEmptyName = "Name is required";
const String msgEmptyAddress = "Address is required";
const String msgEmptyAddresstype = "House/Office name is required";
const String msgEmptySaveAddress = "Address type is required";

const String msgEmptyOldPassword = "Old password is required";
const String msgInvalidPassword =
    "Password should minimum 6 characters & contain combination of uppercase, lowercase, numbers and special characters";
const String msgEmptyConfirmPassword = "Confirm password is required";
const String msgEmptyConfirmNewPassword = "Confirm new password is required";
const String msgPasswordNotMatch =
    "Password and confirm password should be same";
const String msgNewPasswordNotMatch =
    "New password and confirm new password should be same";
const String msgEmptyCompanyName = "Company name is required";
const String msgEmptyNewPassword = "New password is required";
const String msgEmptyCardNUmber = "Please enter a card number";
const String msgEmptyCardHolder = "Please enter cardholder name";
const String msgEmptyExpDate = "Please enter valid card expiry";
const String msgEmptyCVV = "Please enter CVV";
const String msgEmptyZip = "Please enter Zipcode";

const String msgEmptyProductName = "Please enter product name";
const String msgEmptyGoods = "Please enter nature of goods";
const String msgEmptyDescription = "Please select the product description";
const String msgEmptyOtherDescription = "Please enter product description";
const String msgEmptyPackages = "Please select types of packages";
const String msgEmptyProduct = "Please select the type of handling product";
const String msgEmptyDelivery = "Please select delivery priority";
const String msgEmptyCategories = "Please select categories";
const String msgEmptyShipment = "Please add shipment charges";
const String msgEmptyBoxes = "Please add no. of boxes";
const String msgEmptyWeight = "Please select the package weight";
const String msgEmptyLength = "Please add product length";
const String msgEmptyWidth = "Please add product width";
const String msgEmptyHeight = "Please add product height";

const String msgAppointmentDate = "Please select appointment date";
const String msgEmptyDate = "Date is required";
const String msgEmptyDateOfBirth = "Date Of Birth is required";
const String msgEmptyFromTime = "Please select start time";
const String msgEmptyToTime = "Please select end time";
const String msgEmptySSNNumber = "SSN Number is required";

const String msgEmptyRoutinNumber = "Routing number is required";
const String msgEmptyAccountNumber = "Account number is required";
const String msgEmptyAccountHolder = "Account holder name is required";
const String msgEmptyCompanyAddress = "Company address is required";
const String msgEmptyCity = "City is required";
const String msgEmptyState = "State is required";
const String msgEmptyAbout = "About yourself is required";
const String msgEmptyRemarks = "Remarks is required";

const String msgEmptyMsg = "Message is required";
