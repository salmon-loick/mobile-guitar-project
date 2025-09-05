import 'package:flutter/material.dart';
import 'package:mobile_guitar_project/screens/Home.dart';
import 'package:mobile_guitar_project/screens/Tuner.dart';
import 'package:mobile_guitar_project/screens/Metronome.dart';
import 'package:mobile_guitar_project/screens/Accords.dart';
import 'package:mobile_guitar_project/screens/Settings.dart';
import '../routes/routes.dart';

Map<String, WidgetBuilder> router = {
  // kTunerRoute: (context) => const Tuner(),
  kHomeRoute: (context) => Home(child: Tuner()),
  //kMetronomeRoute: (context) => const Metronome(),
  kAccordRoute: (context) => const Accords(),
  //kSettingsRoute: (context) => const Settings(),
};
