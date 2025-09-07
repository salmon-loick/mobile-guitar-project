import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../partials/button.dart';
import '../partials/form/email_input.dart';
import '../partials/form_header.dart';
import '../partials/link.dart';
import '../routes/routes.dart';
import '../styles/constants.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({Key? key}) : super(key: key);

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _resetPasswordFormKey = GlobalKey<FormState>();
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _resetPasswordFormKey,
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
                              top: kVerticalSpacer * 3,
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
                              EmailInput(
                                onChanged: (value) {
                                  _email = value;
                                },
                              ),
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
                              text: 'Se connecter',
                              onTap: () {
                                Navigator.pushNamed(context, kLoginRoute);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: kVerticalSpacer * 2,
                        ),
                        Button(
                            label: 'Envoyer email de réinitialisation',
                            onPressed: () {
                              if (_resetPasswordFormKey.currentState != null &&
                                  _resetPasswordFormKey.currentState!
                                      .validate()) {
                                FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: _email);
                                Navigator.pushNamed(context, kLoginRoute)
                                    .then((value) {
                                  return ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                              'Un email de réinitialisation a été envoyé à $_email')));
                                });
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
    );
  }
}
