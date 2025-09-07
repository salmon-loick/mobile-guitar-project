import 'package:flutter/material.dart';



const kMainBackgroundColor = Colors.purple;
const kCardPopupBackgroundColor = Color(0xFFF5F8FF);
const kMainTextColor = Color(0xFF254D60);
const kMainTextColorLighter = Color(0xFF448CAD);
const kSecondColor = Color(0xFF3F8EFC);
const kPrimaryLabelColor = kMainTextColor;
const kSecondaryLabelColor = Color(0xFF797F8A);
const kThirdColor = Color(0xFFFF6978);
const double kHorizontalSpacer = 16;
const double kBorderWith = 5;
const double kVerticalSpacer = 26;
const double kDefaultWidth = 36;
const double kDefaultSpacer = 17;
const BorderRadius kBorderRadiusItem = BorderRadius.all(Radius.circular(10));
const kGradientColors = [kMainTextColor, kMainTextColorLighter];

List<BoxShadow> kBoxShadowItem = [
  BoxShadow(
    color: Colors.black.withOpacity(0.16),
    blurRadius: 4,
    offset: const Offset(3, 3),
  )
];
const kFontStyleMenuItem =
TextStyle(fontFamily: "main", fontWeight: FontWeight.w700, fontSize: 18);
const fontStyleLegend =
TextStyle(fontFamily: "main", fontSize: 14, color: Colors.grey);
const kHomeGradientButton = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Color(0xFFad5389),
    Color(0xFF3c1053),
  ],
);
const kPaymentGradientButton = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Color(0xFF89216B),
    Color(0xFFDA4453),
  ],
);
const kSettingsGradientButton = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Color(0xFFFF416C),
    Color(0xFFFF4B2B),
  ],
);

const kVoteStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: kMainTextColor,
  fontSize: 15.0,
  decoration: TextDecoration.none,
);
const kVoteStyleSmall = TextStyle(
  fontWeight: FontWeight.bold,
  color: kMainTextColor,
  fontSize: 11.0,
  decoration: TextDecoration.none,
);
// Text Styles
const kLargeTitleStyle = TextStyle(
  fontSize: 34.0,
  fontWeight: FontWeight.normal,
  color: kPrimaryLabelColor,
  decoration: TextDecoration.none,
);
const kTitle1Style = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  color: kPrimaryLabelColor,
  decoration: TextDecoration.none,
);

const kTitleSection = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w800,
  color: kMainTextColor,
  decoration: TextDecoration.none,
);

const kCardTitleStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: kMainTextColor,
  fontSize: 15.0,
  decoration: TextDecoration.none,
);

const kTagLineStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontStyle: FontStyle.italic,
  color: kSecondColor,
  fontSize: 15.0,
  decoration: TextDecoration.none,
);

const kGenreStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontStyle: FontStyle.normal,
  color: kThirdColor,
  fontSize: 15.0,
  decoration: TextDecoration.none,
);
const kSubtitleStyle = TextStyle(
  fontSize: 16.0,
  color: kSecondaryLabelColor,
  fontStyle: FontStyle.italic,
  decoration: TextDecoration.none,
);
const kCardSubtitleStyle = TextStyle(
  color: Color(0xE6FFFFFF),
  fontSize: 13.0,
  decoration: TextDecoration.none,
);

const kBodyLabelStyle = TextStyle(
  fontSize: 14.0,
  color: Colors.black,
  decoration: TextDecoration.none,
);
const kCaptionLabelStyle = TextStyle(
  fontSize: 14.0,
  color: kSecondaryLabelColor,
  decoration: TextDecoration.none,
);

const kLoginInputTextStyle = TextStyle(
  fontSize: 17.0,
  color: kMainTextColor,
  fontWeight: FontWeight.w400,
  decoration: TextDecoration.none,
);

const kCalloutLabelStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w700,
  color: kPrimaryLabelColor,
  decoration: TextDecoration.none,
);
const double kCircularPercentIndicatorRadius = 30;

final kBoxDecoration = BoxDecoration(
    color: kCardPopupBackgroundColor,
    boxShadow: kBoxShadowItem,
    borderRadius: kBorderRadiusItem);
