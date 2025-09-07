import 'package:flutter/material.dart';
import 'package:mobile_guitar_project/screens/Home.dart';
import 'package:mobile_guitar_project/screens/Tuner.dart';
import '../routes/routes.dart';
import '../screens/login_form.dart';
import '../screens/register_form.dart';
import '../screens/reset_password_form.dart';

Map<String, WidgetBuilder> router = {
  // kTunerRoute: (context) => const Tuner(),
  kHomeRoute: (context) => Home(initialChild: Tuner()),
  //kMetronomeRoute: (context) => const Metronome(),
  //kAccordRoute: (context) => const Accords(),
  //kSettingsRoute: (context) => const Settings(),
  kRegisterRoute: (context) => const RegisterForm(),
  kLoginRoute: (context) => LoginForm(),
  kResetPasswordRoute: (context) => const ResetPasswordForm(),
};
