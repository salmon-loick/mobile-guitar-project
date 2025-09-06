import 'dart:math';

import 'package:mobile_guitar_project/model/tuning_result.dart';

enum TuningMode { chromatic, custom }

class FreqHandler {
  TuningMode _mode = TuningMode.chromatic;
  late double _minimumFreq;
  late double _maximumFreq;
  late List<String> _noteStrings;
  Map<String, double>? _customTunings;

  FreqHandler() {
    setChromatic();
  }

  void setChromatic() {
    _mode = TuningMode.chromatic;
    _noteStrings = [
      "C",
      "C#",
      "D",
      "D#",
      "E",
      "F",
      "F#",
      "G",
      "G#",
      "A",
      "A#",
      "B"
    ];
    _minimumFreq = 60.0;
    _maximumFreq = 1600.0;
  }

  void setCustom(Map<String, double> customTunings,
      {double toleranceRatio = 0.12}) {
    _mode = TuningMode.custom;

    // Normaliser les clés (ajouter octave si manquant)
    _customTunings = customTunings.map((note, freq) {
      final hasOctave = RegExp(r'\d$').hasMatch(note);
      if (hasOctave) {
        return MapEntry(note, freq);
      } else {
        final midi = _midiFromFrequency(freq);
        final octave = (midi ~/ 12) - 1;
        return MapEntry("$note$octave", freq);
      }
    });

    // Définir min et max avec marge
    final minFreq = _customTunings!.values.reduce(min);
    final maxFreq = _customTunings!.values.reduce(max);
    _minimumFreq = minFreq * (1.0 - toleranceRatio);
    _maximumFreq = maxFreq * (1.0 + toleranceRatio);

    _noteStrings = _customTunings!.keys.toList();
  }

  Future<TuningResult> handleFreq(double freq) {
    if (!_isFreqInRange(freq)) {
      return Future.value(TuningResult(
          note: "", actualFrequency: freq, expectedFrequency: 0.0));
    }
    String note;
    double expectedFrequency;
    if (_mode == TuningMode.chromatic) {
      final closest = _findClosestChromatic(freq);
      note = closest.key;
      expectedFrequency = closest.value;
    } else {
      final closest = _findClosestCustom(freq);
      note = closest.key;
      expectedFrequency = closest.value;
    }
    return Future.value(TuningResult(
        note: note,
        actualFrequency: freq,
        expectedFrequency: expectedFrequency));
  }

  /// Checks if pitch is between the range of the instrument
  bool _isFreqInRange(double frequency) {
    return frequency > _minimumFreq && frequency < _maximumFreq;
  }

  /// Find closest note in chromatic mode
  MapEntry<String, double> _findClosestChromatic(double frequency) {
    final midi = _midiFromFrequency(frequency);
    final expectedFrequency = _frequencyFromNoteNumber(midi);
    final noteName = _noteStrings[midi % 12];
    final octave = (midi ~/ 12) - 1;
    return MapEntry("$noteName$octave", expectedFrequency);
  }

  // Find closest note in custom tuning
  MapEntry<String, double> _findClosestCustom(double frequency) {
    // Trouver la note la plus proche en fréquence
    return _customTunings!.entries.reduce((a, b) =>
        (frequency - a.value).abs() < (frequency - b.value).abs() ? a : b);
  }

  int _midiFromFrequency(double frequency) {
    final noteNum = 12.0 * (log((frequency / 440.0)) / log(2.0));
    return (noteNum.roundToDouble() + 69.0).toInt();
  }

  double _frequencyFromNoteNumber(int note) {
    final exp = (note - 69.0).toDouble() / 12.0;
    return (440.0 * pow(2.0, exp)).toDouble();
  }
}
