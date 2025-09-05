import 'package:flutter/material.dart';
import 'package:mobile_guitar_project/model/freq_handler.dart';
import 'package:mobile_guitar_project/model/tuning_handler.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:record/record.dart';


class TuningTester extends StatelessWidget {
  const TuningTester({super.key, required this.title});
  final String title;
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

      child: MultiBlocProvider(
        providers: [
          BlocProvider<TuningHandler>(
          create: (context) => TuningHandler(
            context.read<AudioRecorder>(),
            context.read<PitchDetector>(),
            context.read<FreqHandler>(),
          ),
        ),
        ],
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(title),
          ),
          body: TuningResultDisplay()
        ),
      ),
    );
  }
}

class TuningResultDisplay extends StatelessWidget {
  const TuningResultDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final tuningHandlerState = context.watch<TuningHandler>().state;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            tuningHandlerState.note,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            "${tuningHandlerState.centsOff.toStringAsFixed(0)} cents",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            "${tuningHandlerState.actualFrequency.toStringAsFixed(0)} Hz",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          ElevatedButton(
            onPressed: () {
              context.read<FreqHandler>().setCustom({
                "E2": 82.41,
                "A2": 110.0,
                "D3": 146.83,
                "G3": 196.0,
                "B3": 246.94,
                "E4": 329.63,
              });
            },
            child: Text("Passer en mode Custom"),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<FreqHandler>().setChromatic();
            },
            child: Text("Passer en mode Chromatic"),
          ),

        ],
      ),
    );
  }

}