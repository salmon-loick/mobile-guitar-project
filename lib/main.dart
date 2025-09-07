import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_guitar_project/routes/router.dart';
import 'package:mobile_guitar_project/routes/routes.dart';
import 'package:mobile_guitar_project/styles/theme.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(const GuitarApp());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}
final GlobalKey<_GuitarAppState> appKey = GlobalKey<_GuitarAppState>();

class GuitarApp extends StatefulWidget {
  const GuitarApp({super.key});
  @override
  State<GuitarApp> createState() => _GuitarAppState();
}

class _GuitarAppState extends State<GuitarApp>{
  ThemeMode _themeMode = ThemeMode.system;
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return MaterialApp(
          title: 'GuitarWatch',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: _themeMode,
          initialRoute: kHomeRoute,
          routes: router,
        );
      },
    );

  }
}


