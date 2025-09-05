import 'package:flutter/material.dart';
import 'package:mobile_guitar_project/routes/routes.dart';
class Tuner extends StatelessWidget {
  const Tuner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Affichage de l'image
            SizedBox(
              height: 200,
            ),
            Center(
              child: SizedBox(
                height: 300,
                child: Image.asset(
                  "assets/img/guitare.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}