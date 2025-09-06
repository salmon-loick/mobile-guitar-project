import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_guitar_project/model/freq_handler.dart';
import 'package:mobile_guitar_project/model/tuning_handler.dart';
import 'package:mobile_guitar_project/partials/guitar_head.dart';
import 'package:mobile_guitar_project/partials/tuner_top_bar.dart';
import 'package:mobile_guitar_project/partials/tuning_gauge.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:record/record.dart';

class Tuner extends StatefulWidget {
  const Tuner({Key? key}) : super(key: key);

  @override
  State<Tuner> createState() => _TunerState();
}

class _TunerState extends State<Tuner> {
  // 🔹 Valeurs par défaut (seront mises à jour via la logique Cubit)

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AudioRecorder>(
          create: (context) => AudioRecorder(),
        ),
        RepositoryProvider<PitchDetector>(
          create: (context) => PitchDetector(),
        ),
        RepositoryProvider<FreqHandler>(
          create: (context) => FreqHandler(),
        ),
      ],
      child: MultiBlocProvider(providers: [
        BlocProvider<TuningHandler>(
          create: (context) => TuningHandler(
            context.read<AudioRecorder>(),
            context.read<PitchDetector>(),
            context.read<FreqHandler>(),
          ),
        ),
      ], child: TunerDisplay()),
    );
  }
}

class TunerDisplay extends StatefulWidget {


  TunerDisplay({super.key}){
    // initialisation du FreqHandler avec l'accordage standard
  }

  @override
  State<TunerDisplay> createState() => _TunerDisplayState();

}

class _TunerDisplayState extends State<TunerDisplay> {
  @override
  void initState() {
    super.initState();
    // initialisation du FreqHandler avec l'accordage standard
    context.read<FreqHandler>().setCustom(standardTuning);
  }

  void _openSettings() {
    // TODO: navigation vers la page paramètres
    debugPrint("Naviguer vers paramètres");
  }

  void _onStringSelected(int index) {
    setState(() {
      if (selectedString == index) {
        selectedString = null;
        // passage en mode automatique
        context.read<FreqHandler>().setCustom(standardTuning);
        return;
      }
      else {
        selectedString = index;
        // passage en mode manuel
        selectedNote = standardTuning.keys.elementAt(index);
        double freq = standardTuning[selectedNote]!;
        context.read<FreqHandler>().setCustom({selectedNote: freq}, toleranceRatio: 0.5);
      }
    });
  }
  String tuningName = "Guitare Standard";
  Map<String, double> standardTuning = LinkedHashMap.from(
  {
    "E2": 82.41,
    "A2": 110.0,
    "D3": 146.83,
    "G3": 196.0,
    "B3": 246.94,
    "E4": 329.63,
  });

  int? selectedString;
  String selectedNote = "";

  @override
  Widget build(BuildContext context) {
    int detectedIndex = -1;

    final result = context.watch<TuningHandler>().state;
    if (selectedString == null) {
      detectedIndex = standardTuning.values.toList().indexOf(result.expectedFrequency);
    }
    return Column(children: [
      TunerTopBar(
        tuningName: tuningName,
        onSettingsPressed: _openSettings,
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TuningGauge(
              note: selectedString!=null ? selectedNote: result.note,
              centsOff: result.centsOff,
              pitchDetected: result.note.isNotEmpty,
            ),
            GuitarHead(
              tuningNotes: standardTuning,
              selectedIndex: selectedString,
              onBubblePressed: _onStringSelected,
              detectedIndex: detectedIndex,
            ),
          ],
        ),
      ),
    ]);
  }
}
