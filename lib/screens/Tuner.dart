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


  TunerDisplay({super.key});

  @override
  State<TunerDisplay> createState() => _TunerDisplayState();

}

class _TunerDisplayState extends State<TunerDisplay> {
  void _openSettings() {
    // TODO: navigation vers la page paramètres
    debugPrint("Naviguer vers paramètres");
  }

  void _onStringSelected(int index) {
    setState(() {
      selectedString = index;
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

  String detectedNote = "E2";

  int? selectedString;

  @override
  Widget build(BuildContext context) {
    context.read<FreqHandler>().setCustom(standardTuning);
    final tuningHandlerState = context.watch<TuningHandler>().state;
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
              note: tuningHandlerState.note,
              centsOff: tuningHandlerState.centsOff,
            ),
            GuitarHead(
              tuningNotes: standardTuning,
              selectedIndex: selectedString,
              onBubblePressed: _onStringSelected,
            ),
          ],
        ),
      ),
    ]);
  }
}
