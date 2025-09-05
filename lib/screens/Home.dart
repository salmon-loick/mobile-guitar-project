import 'package:flutter/material.dart';
import 'package:mobile_guitar_project/routes/routes.dart';

import 'BottomMenu.dart';

class Home extends StatefulWidget {
  Widget child;
  Home({super.key, required this.child});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Widget child = widget.child;
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
