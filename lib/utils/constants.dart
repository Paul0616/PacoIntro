import 'package:flutter/material.dart';

/*----------------------
  TOP BAR
 -----------------------*/
const double topBarMiddleGap = 230.0;

/*----------------------
  COLORS
 -----------------------*/
const Color pacoAppBarColor = Color(0xFFEE3131);
const Color pacoRedDisabledColor = Color(0xFFEAABAB);
const Color textGray = Color(0xFF8a8a8a);
const Color pacoLightGray = Color(0xFFF0F0F0);
Map<int, Color> colorPacoRed = {
  50: Color.fromRGBO(238, 49, 49, 0.1),
  100: Color.fromRGBO(238, 49, 49, 0.2),
  200: Color.fromRGBO(238, 49, 49, 0.3),
  300: Color.fromRGBO(238, 49, 49, 0.4),
  400: Color.fromRGBO(238, 49, 49, 0.5),
  500: Color.fromRGBO(238, 49, 49, 0.6),
  600: Color.fromRGBO(238, 49, 49, 0.7),
  700: Color.fromRGBO(238, 49, 49, 0.8),
  800: Color.fromRGBO(238, 49, 49, 0.9),
  900: Color.fromRGBO(238, 49, 49, 1),
};

MaterialColor pacoRedMaterialColor =
MaterialColor(pacoAppBarColor.value, colorPacoRed);

/*----------------------
  TEXT STYLES
 -----------------------*/
TextStyle textStyle =
TextStyle(color: textGray, fontWeight: FontWeight.w300);

TextStyle textStyleBold =
TextStyle(color: textGray, fontWeight: FontWeight.w600);

TextStyle textStyleWhite =
TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 19);

/*----------------------
  PREFERENCES KEYS
 -----------------------*/
const String userKey = 'user';
const String currentLocationKey = 'currentLocation';
const String orderCountKey = 'orderCount';

/*----------------------
  ENUMS
 -----------------------*/
enum SearchType {BY_CODE, BY_NAME}