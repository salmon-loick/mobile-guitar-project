import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../styles/constants.dart';

@immutable
class TextInput extends StatelessWidget {
  const TextInput(
      {required this.icon,
      required this.labelText,
      this.hintText = "",
      this.keyboardType = TextInputType.text,
      required this.validator,
      this.obscureText = false,
      this.autofocus = false,
      this.onChanged,
      this.value,
      Key? key})
      : super(key: key);
  final IconData icon;
  final String hintText;
  final String labelText;
  final bool obscureText;
  final bool autofocus;
  final TextInputType keyboardType;
  final FormFieldValidator<String> validator;
  final ValueChanged<String>? onChanged;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      validator: validator,
      keyboardType: keyboardType,
      onChanged: onChanged,
      obscureText: obscureText,
      autofocus: autofocus,
      cursorColor: kMainTextColor,
      style: kLoginInputTextStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: hintText,
        hintStyle: kLoginInputTextStyle,
        isDense: true,
        labelText: labelText,
        labelStyle: kLoginInputTextStyle,
        iconColor: kMainTextColor,
        border: InputBorder.none,
        icon: Icon(
          icon,
          color: kMainTextColor,
        ),
      ),
    );
  }
}
