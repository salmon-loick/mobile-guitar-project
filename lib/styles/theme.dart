import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: kLightTextColor,
  scaffoldBackgroundColor: kLightBackground2Color,
  sliderTheme: ThemeData.light().sliderTheme.copyWith(
    activeTrackColor: kLightAccentColor,
    inactiveTrackColor: kLightBackgroundColor,
    thumbColor: kLightAccentColor,
    overlayColor: kLightAccentColor,
    valueIndicatorColor: kLightAccentColor,
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: kLightBackgroundColor,
    iconTheme: IconThemeData(color: kLightTextColor),
    titleTextStyle: TextStyle(
      color: kLightTextColor,
      fontSize: 26,
      fontWeight: FontWeight.bold,
    ),
  ),
  dividerColor: kLightAccent2Color,
  highlightColor: kLightAccent2Color,
  unselectedWidgetColor: kLightBackgroundColor,
  textTheme: TextTheme(
    headlineMedium: TextStyle(color: kLightTextColor, fontSize: 28, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: kLightTextColor, fontSize: 18),
    bodyMedium: TextStyle(color: kLightTextColor, fontSize: 16),
    bodySmall: TextStyle(color: kLightTextColor, fontSize: 14),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kLightAccentColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  iconTheme: IconThemeData(color: kLightTextColor),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: kDarkTextColor,
  scaffoldBackgroundColor: kDarkBackgroundColor,
  sliderTheme: ThemeData.dark().sliderTheme.copyWith(
    activeTrackColor: kDarkAccentColor,
    inactiveTrackColor: kDarkBackground2Color,
    thumbColor: kDarkAccentColor,
    overlayColor: kDarkAccentColor,
    valueIndicatorColor: kDarkAccentColor,
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: kDarkBackground2Color,
    iconTheme: IconThemeData(color: kDarkTextColor),
    titleTextStyle: TextStyle(
      color: kDarkTextColor,
      fontSize: 26,
      fontWeight: FontWeight.bold,
    ),
  ),
  dividerColor: kDarkAccent2Color,
  highlightColor: kDarkAccent2Color,
  unselectedWidgetColor: kDarkBackground2Color,
  textTheme: TextTheme(
    headlineMedium: TextStyle(color: kDarkTextColor, fontSize: 28, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: kDarkTextColor , fontSize: 18),
    bodyMedium: TextStyle(color: kDarkTextColor, fontSize: 16),
    bodySmall: TextStyle(color: kDarkTextColor , fontSize: 14),
    ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kDarkAccentColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  iconTheme: IconThemeData(color: kDarkTextColor),
);