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
