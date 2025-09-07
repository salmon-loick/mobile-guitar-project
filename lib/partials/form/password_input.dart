import 'package:flutter/material.dart';
import 'package:mobile_guitar_project/partials/form/text_input.dart';

@immutable
class PasswordInput extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const PasswordInput({this.onChanged, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextInput(
      value: "",
      icon: Icons.password,
      labelText: 'Votre mot de passe',
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Le mot de passe doit être renseigné.';
        } else if (value.length < 9) {
          return 'Le mot de passe doit contenir au moins 9 caractères.';
        }
      },
      obscureText: true,
      onChanged: onChanged,
    );
  }
}
