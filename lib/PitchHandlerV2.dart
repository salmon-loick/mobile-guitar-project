import 'dart:math';

import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_result.dart';
import 'package:pitchupdart/tuning_status.dart';


enum PitchMode { chromatic, custom }

class PitchHandlerV2 {
  PitchMode _mode = PitchMode.chromatic;
  InstrumentType _instrumentType;
  late double _minimumPitch;
  late double _maximumPitch;
  late List<String> _noteStrings;
  Map<String, double>? _customTunings;

  PitchHandlerV2(this._instrumentType) {
    switch (_instrumentType) {
      case InstrumentType.guitar:
        this._minimumPitch = 60.0;
        this._maximumPitch = 1600.0;
        this._noteStrings = [
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
        break;
      default:
        _minimumPitch = 20.0;
        _maximumPitch = 20000.0;
        _noteStrings = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"];
        break;
    }
  }

  void setChromatic() {
    _mode = PitchMode.chromatic;
    _noteStrings = [
      "C","C#","D","D#","E","F","F#","G","G#","A","A#","B"
    ];
    _minimumPitch = 60.0;
    _maximumPitch = 1600.0;
  }


  void setCustom(Map<String, double> customTunings,
      {double toleranceRatio = 0.12}) {
    _mode = PitchMode.custom;

    // Normaliser les clés (ajouter octave si manquant)
    _customTunings = customTunings.map((note, freq) {
      final hasOctave = RegExp(r'\d$').hasMatch(note);
      if (hasOctave) {
        return MapEntry(note, freq);
      } else {
        final midi = _midiFromPitch(freq);
        final octave = (midi ~/ 12) - 1;
        return MapEntry("$note$octave", freq);
      }
    });

    // Définir min et max avec marge
    final minFreq = _customTunings!.values.reduce(min);
    final maxFreq = _customTunings!.values.reduce(max);
    _minimumPitch = minFreq * (1.0 - toleranceRatio);
    _maximumPitch = maxFreq * (1.0 + toleranceRatio);

    _noteStrings = _customTunings!.keys.toList();
  }


  Future<PitchResult> handlePitch(double pitch) {
    if (!_isPitchInRange(pitch)) {
      return Future.value(
          PitchResult("", TuningStatus.undefined, 0.0, 0.0, 0.0));
    }
    String note;
    double expectedFrequency;
    if (_mode == PitchMode.chromatic) {
      final closest = _findClosestChromatic(pitch);
      note = closest.key;
      expectedFrequency = closest.value;
    } else {
      final closest = _findClosestCustom(pitch);
      note = closest.key;
      expectedFrequency = closest.value;
    }

    final diffHz = expectedFrequency - pitch;
    final diffCents = _diffInCents(expectedFrequency, pitch);
    final tuningStatus = _getTuningStatus(diffHz);

    return Future.value(
        PitchResult(note, tuningStatus, expectedFrequency, diffHz, diffCents));
  }

  /// Checks if pitch is between the range of the instrument
  bool _isPitchInRange(double pitch) {
    return pitch > _minimumPitch && pitch < _maximumPitch;
  }

  /// Find closest note in chromatic mode
  MapEntry<String, double> _findClosestChromatic(double frequency) {
    final midi = _midiFromPitch(frequency);
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

  int _midiFromPitch(double frequency) {
    final noteNum = 12.0 * (log((frequency / 440.0)) / log(2.0));
    return (noteNum.roundToDouble() + 69.0).toInt();
  }

  double _frequencyFromNoteNumber(int note) {
    final exp = (note - 69.0).toDouble() / 12.0;
    return (440.0 * pow(2.0, exp)).toDouble();
  }

  /// Difference in Hz to the closest note
  double _diffInCents(double expectedFrequency, double frequency) {
    return 1200.0 * log(expectedFrequency / frequency);
  }

  /// Returns tunning status
  TuningStatus _getTuningStatus(double diff) {
    if (diff >= -0.3 && diff <= 0.3) {
      return TuningStatus.tuned;
    } else if (diff >= -1.0 && diff <= 0.0) {
      return TuningStatus.toohigh;
    } else if (diff > 0.0 && diff <= 1.0) {
      return TuningStatus.toolow;
    } else if (diff >= double.negativeInfinity && diff <= -1.0) {
      return TuningStatus.waytoohigh;
    } else {
      return TuningStatus.waytoolow;
    }
  }
}
