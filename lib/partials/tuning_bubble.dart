import 'package:flutter/material.dart';

class TuningBubble extends StatelessWidget {
  final String note;
  final double frequency;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDetected;

  const TuningBubble({
    super.key,
    required this.note,
    required this.isSelected,
    required this.onTap, required this.frequency,
    required this.isDetected,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (isSelected) {
      backgroundColor = Theme.of(context).highlightColor;
    } else if (isDetected) {
      backgroundColor = Theme.of(context).indicatorColor;
    } else {
      backgroundColor = Theme.of(context).unselectedWidgetColor;
    }
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 21,
        backgroundColor: Theme.of(context).primaryColor,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: backgroundColor,
          child: Text(note, style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ),
    );
  }
}

