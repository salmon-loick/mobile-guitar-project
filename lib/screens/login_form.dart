import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_guitar_project/partials/button.dart';
import 'package:mobile_guitar_project/partials/form_header.dart';
import 'package:mobile_guitar_project/partials/link.dart';
import 'package:mobile_guitar_project/routes/routes.dart';
import 'package:mobile_guitar_project/styles/colors.dart';
import '../model/error_firebase_auth.dart';
import '../partials/form/email_input.dart';
import '../partials/form/password_input.dart';
import '../styles/constants.dart';

class LoginForm extends StatelessWidget {
  LoginForm({Key? key}) : super(key: key);
  final _loginFormKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Form(
          key: _loginFormKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: FormHeader(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kHorizontalSpacer),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            top: kVerticalSpacer, bottom: kVerticalSpacer / 2),
                        padding: const EdgeInsets.symmetric(
                          vertical: kVerticalSpacer / 2,
                          horizontal: kHorizontalSpacer,
                        ),
                        decoration: kBoxDecoration,
                        child: Column(
                          children: [
                            EmailInput(
                              onChanged: (value) {
                                _email = value;
                              },
                            ),
                            const Divider(
                              color: kMainTextColor,
                              height: kVerticalSpacer * 2,
                            ),
                            PasswordInput(onChanged: (value) {
                              _password = value;
                            }),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Link(
                              text: 'Créer un compte',
                              onTap: () {
                                Navigator.pushNamed(context, kRegisterRoute);
                              }),
                          Link(
                            text: 'Mot de passe oublié',
                            onTap: () {
                              Navigator.pushNamed(context, kResetPasswordRoute);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: kVerticalSpacer * 2,
                      ),
                      Button(
                          label: 'Se connecter',
                          onPressed: () async {
                            if (_loginFormKey.currentState != null &&
                                _loginFormKey.currentState!.validate()) {
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: _email, password: _password)
                                    .then((value) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Bonjour ${FirebaseAuth.instance.currentUser!.displayName}'),
                                  ));
                                  Navigator.pushNamed(context, kHomeRoute);
                                });
                              } on FirebaseAuthException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                        errors[e.code]!,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      backgroundColor: Colors.redAccent),
                                );
                              }
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
