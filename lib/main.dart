import 'package:flutter/material.dart';
import 'package:mobile_guitar_project/model/tuning_handler.dart';
import 'package:mobile_guitar_project/model/freq_handler.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_guitar_project/screens/tuning_tester.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:record/record.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TuningTester(title: 'Tuning Tester'),
    );
  }
}
