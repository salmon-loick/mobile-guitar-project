import 'package:flutter/material.dart';
import 'package:mobile_guitar_project/styles/colors.dart';

class TuningStatus extends StatelessWidget {
  final double centsOff;
  final bool isTuning;

  const TuningStatus({Key? key, required this.centsOff, this.isTuning = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    if (!isTuning) {
      color = Theme.of(context).unselectedWidgetColor;
      label = "0";
    } else {
      if (centsOff.abs() < 2) {
        color = kGreenColor;
        label = "✓";
      } else if (centsOff.abs() < 20) {
        color = Colors.orange;
        label = "${centsOff.toStringAsFixed(0)}";
      } else {
        color = kRedColor;
        label = "${centsOff.toStringAsFixed(0)}";
      }
    }

    return CircleAvatar(
      radius: 26,
      backgroundColor: Theme.of(context).primaryColor,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: color,
        child: Text(label, style: TextStyle(color: kDarkTextColor, fontSize: 16)),
      ),
    );
  }
}
