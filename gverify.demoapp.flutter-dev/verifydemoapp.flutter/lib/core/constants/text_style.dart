
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../generated/fonts.gen.dart';

TextStyle boldTextStyle(double fontSize, Color textColor) {
  return TextStyle(
    color: textColor,
    fontSize: fontSize,
    fontFamily: FontFamily.googleSansBold,
  );
}

TextStyle regularTextStyle(double fontSize, Color textColor) {
  return TextStyle(
    color: textColor,
    fontSize: fontSize,
    fontFamily: FontFamily.googleSansRegular,
  );
}

TextStyle mediumTextStyle(double fontSize, Color textColor) {
  return TextStyle(
    color: textColor,
    fontSize: fontSize,
    fontFamily: FontFamily.googleSansMedium,
  );
}


