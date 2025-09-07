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

class GuitarApp extends StatelessWidget {
  const GuitarApp({super.key});

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
          themeMode: ThemeMode.system,
          initialRoute: kHomeRoute,
          routes: router,
        );
      },
    );

  }
}


