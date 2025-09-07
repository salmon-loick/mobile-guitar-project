import 'package:flutter/material.dart';

import 'BottomMenu.dart';

class Home extends StatefulWidget {
  final Widget initialChild;
  Home({super.key, required this.initialChild});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Widget child = widget.initialChild;
  void changeChild(Widget newChild) {
    child = newChild;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: child),
            BottomMenu( changeChild: changeChild,)
          ],
        ),
      ),
    );
  }
}
