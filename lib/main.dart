import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_guitar_project/tuning_handler.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

import 'PitchHandlerV2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  //final PitchHandlerV2 pitchHandlerV2 = PitchHandlerV2(InstrumentType.guitar);

  // This widget is the root of your application.
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

          RepositoryProvider<PitchHandlerV2>(
            create: (context) => PitchHandlerV2(InstrumentType.guitar),
          ),

        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TuningHandler>(
              create: (context) => TuningHandler(
                context.read<AudioRecorder>(),
                context.read<PitchDetector>(),
                context.read<PitchHandlerV2>(),
              ),
            ),
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const MyHomePage(title: 'Flutter Demo Page'),
          ),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final tuningHandlerState = context.watch<TuningHandler>().state;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              tuningHandlerState.note,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              tuningHandlerState.centsOffString,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () {
                context.read<PitchHandlerV2>().setCustom({
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
                context.read<PitchHandlerV2>().setChromatic();
              },
              child: Text("Passer en mode Chromatic"),
            ),

          ],
        ),
      ),
    );
  }
}
