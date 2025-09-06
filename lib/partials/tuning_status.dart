import 'package:flutter/material.dart';

class TuningStatus extends StatelessWidget {
  final double centsOff;

  const TuningStatus({Key? key, required this.centsOff}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    if (centsOff.abs() < 2) {
      color = Colors.green;
      label = "✓";
    } else if (centsOff.abs() < 20) {
      color = Colors.orange;
      label = "${centsOff.toStringAsFixed(0)}";
    } else {
      color = Colors.red;
      label = "${centsOff.toStringAsFixed(0)}";
    }

    return CircleAvatar(
      radius: 25,
      backgroundColor: color,
      child: Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}