import 'package:flutter/material.dart';

// Page du métronome
class Metronome extends StatelessWidget {
  const Metronome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
              children: [
                SizedBox(
                  height: 200,
                ),
                Center(
                  child: SizedBox(
                    height: 300,
                    child: Image.asset(
                      "assets/img/metronome.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
      )
    );
  }
}
