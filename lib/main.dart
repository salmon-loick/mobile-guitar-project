import 'package:flutter/material.dart';
import 'package:mobile_guitar_project/routes/router.dart';
import 'package:mobile_guitar_project/routes/routes.dart';
import 'package:mobile_guitar_project/screens/Home.dart';
import 'package:mobile_guitar_project/screens/Tuner.dart';


void main() {
  runApp(const GuitarApp());
}

class GuitarApp extends StatelessWidget {
  const GuitarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GuitarWatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C2A39),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: kHomeRoute,
      routes: router,
    );

  }
}


