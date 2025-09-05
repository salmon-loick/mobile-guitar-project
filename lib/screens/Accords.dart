import 'package:flutter/material.dart';

/// Page des accords
class Accords extends StatelessWidget {
  const Accords({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accords"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: const Center(
        child: Text("🎶 Liste des accords de guitare"),
      ),
    );
  }
}