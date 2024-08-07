import 'dart:ui';
import 'package:flutter/material.dart';

const kTitleStyle = TextStyle(
    fontSize: 55,
    fontFamily: 'SFRounded',
    color: Colors.white,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.3,
    wordSpacing: 2);

const kColorTheme = Color(0xFFCC400E);
const kBackgroundColor = Color(0xFFF2F2F2);

const kButtonText = TextStyle(
  color: kColorTheme,
  fontFamily: 'SFRounded',
  fontWeight: FontWeight.normal,
  fontSize: 16,
  letterSpacing: 1.3,
  wordSpacing: 2,
);

ButtonStyle kButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
    ),
  ),
);

const double kButtonSize = 300;

const kAppBarStyle = TextStyle(
    color: Colors.white, fontFamily: 'SFRounded', fontWeight: FontWeight.bold);

const kLargeText = TextStyle(
  color: Colors.black,
  fontFamily: 'SFRounded',
  fontWeight: FontWeight.w700,
  fontSize: 32,
  letterSpacing: 1.3,
  wordSpacing: 2,
);

var kProfileContainer = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18.0),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.1),
      spreadRadius: 3,
      blurRadius: 5,
    ),
  ],
);
