import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mobile_guitar_project/partials/form/text_input.dart';

@immutable
class EmailInput extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const EmailInput({this.onChanged, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextInput(
      value: "",
      icon: Icons.mail,
      labelText: 'Votre email',
      hintText: 'exemple@mail.com',
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'L’adresse mail doit être renseignée.';
        } else if (!EmailValidator.validate(value)) {
          return 'L’adresse mail doit être une adresse mail valide.';
        }
      },
      onChanged: onChanged,
    );
  }
}
