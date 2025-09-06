import 'package:flutter/material.dart';

class TuningBubble extends StatelessWidget {
  final String note;
  final double frequency;
  final bool isSelected;
  final VoidCallback onTap;

  const TuningBubble({
    Key? key,
    required this.note,
    required this.isSelected,
    required this.onTap, required this.frequency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: isSelected ? Colors.orange : Colors.grey.shade300,
        child: Text(note, style: TextStyle(color: Colors.black)),
      ),
    );
  }
}

