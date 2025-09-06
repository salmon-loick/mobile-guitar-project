import 'package:flutter/material.dart';

class DetectedNoteDisplay extends StatelessWidget {
  final String note;

  const DetectedNoteDisplay({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 21,
      backgroundColor: Theme.of(context).primaryColor,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Theme.of(context).indicatorColor,
        child: Text(note, style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }
}