import 'dart:collection';

import 'package:flutter/material.dart';
import 'tuning_bubble.dart';

class GuitarHead extends StatelessWidget {

  final Map<String, double> tuningNotes;
  final int? selectedIndex;
  final Function(int) onBubblePressed;
  final int detectedIndex;

  const GuitarHead({
    Key? key,
    required this.tuningNotes,
    required this.onBubblePressed,
    this.selectedIndex,
    required this.detectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Découper la liste en 2 moitiés
    final mid = (tuningNotes.length / 2).ceil();
    final Map<String, double> leftNotes = LinkedHashMap.fromEntries(tuningNotes.entries.toList().sublist(0, mid));
    final Map<String, double> rightNotes = LinkedHashMap.fromEntries(tuningNotes.entries.toList().sublist(mid));


    return SizedBox(
      height: 280, // fixe ou ajustable selon l’image
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Colonne gauche
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: ListView.separated(
                reverse: true,
                itemCount: leftNotes.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  final index = i;
                  String key = leftNotes.keys.elementAt(index);
                  return TuningBubble(
                    note: key,
                    frequency: leftNotes[key]!,
                    isSelected: selectedIndex == index,
                    onTap: () => onBubblePressed(index),
                    isDetected: index == detectedIndex,
                  );
                },
                separatorBuilder: (context, i) => const SizedBox(height: 24), // espace vertical fixe
              ),
            ),
          ),

          //const SizedBox(width: 16),

          // Image centrale
          Center(
            child: Image.asset(
              "assets/img/guitare_head.png",
              //height: 250,
              fit: BoxFit.contain,
            ),
          ),

          //const SizedBox(width: 16),

          // Colonne droite
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: ListView.separated(
                itemCount: rightNotes.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // empêche le scroll
                itemBuilder: (context, i) {
                  final index = mid + i;
                  String key = rightNotes.keys.elementAt(i);
                  return TuningBubble(
                    note: key,
                    frequency: rightNotes[key]!,
                    isSelected: selectedIndex == index,
                    onTap: () => onBubblePressed(index),
                    isDetected: index == detectedIndex,
                  );
                },
                separatorBuilder: (context, i) => const SizedBox(height: 24), // espacement vertical
              ),
            ),
          ),
        ],
      ),
    );
  }
}