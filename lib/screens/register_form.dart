import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_guitar_project/partials/button.dart';
import 'package:mobile_guitar_project/partials/form/email_input.dart';
import 'package:mobile_guitar_project/partials/form/password_input.dart';
import 'package:mobile_guitar_project/partials/form/username_input.dart';
import '../model/error_firebase_auth.dart';
import '../partials/form_header.dart';
import '../partials/link.dart';
import '../routes/routes.dart';
import '../styles/constants.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _registerFormKey = GlobalKey<FormState>();
  String _userName = "";
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _registerFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: FormHeader(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kHorizontalSpacer),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top: kVerticalSpacer,
                                bottom: kVerticalSpacer / 2),
                            padding: const EdgeInsets.symmetric(
                              vertical: kVerticalSpacer / 2,
                              horizontal: kHorizontalSpacer,
                            ),
                            decoration: BoxDecoration(
                                color: kCardPopupBackgroundColor,
                                boxShadow: kBoxShadowItem,
                                borderRadius: kBorderRadiusItem),
                            child: Column(
                              children: [
                                UserNameInput(
                                  onChanged: (value) {
                                    _userName = value;
                                  },
                                ),
                                const Divider(
                                  color: kMainTextColor,
                                  height: kVerticalSpacer * 2,
                                ),
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
                                  text: 'Se connecter',
                                  onTap: () {
                                    Navigator.pushNamed(context, kLoginRoute);
                                  }),
                              Link(
                                text: 'Mot de passe oublié',
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, kResetPasswordRoute);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: kVerticalSpacer * 2,
                          ),
                          Button(
                              label: 'Créer un compte',
                              onPressed: () async {
                                if (_registerFormKey.currentState != null &&
                                    _registerFormKey.currentState!.validate()) {
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: _email, password: _password)
                                        .then((value) {
                                      // add a document identified by user email and add an empty collection 'caves' inside
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(_email)
                                          .set({
                                        'email': _email,
                                      });
                                      FirebaseAuth.instance.currentUser!
                                          .updateDisplayName(_userName);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Bonjour ${_userName}'),
                                      ));
                                      Navigator.pop(context, _userName);
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
        ),
      ),
    );
  }
}
