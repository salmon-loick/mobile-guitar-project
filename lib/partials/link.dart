import 'package:flutter/material.dart';

import '../../styles/constants.dart';

@immutable
class Link extends StatelessWidget {
  const Link({required this.text, required this.onTap, Key? key})
      : super(key: key);
  final GestureTapCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: kTagLineStyle,
      ),
    );
  }
}
