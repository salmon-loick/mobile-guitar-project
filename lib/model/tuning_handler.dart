import 'package:flutter/foundation.dart';
import 'package:mobile_guitar_project/model/tuning_result.dart';
import 'package:mobile_guitar_project/model/freq_handler.dart';

import 'package:buffered_list_stream/buffered_list_stream.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:record/record.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TuningHandler extends Cubit<TuningResult> {
  final PitchDetector _pitchDetector;
  final AudioRecorder _audioRecorder;
  final FreqHandler _pitchHandler;

  TuningHandler(
    this._audioRecorder,
    this._pitchDetector,
    this._pitchHandler):
        super(TuningResult(
            note: "", actualFrequency: 0.0, expectedFrequency: 0.0)) {
    _init();
  }

  _init() async {
    if (await _audioRecorder.hasPermission() == false) {
      // Handle the lack of permission as needed
      if (kDebugMode) {
        print("Microphone permission denied");
      }
      // Display a message
      emit(TuningResult(
          note: 'No mic permission',
          actualFrequency: 0.0,
          expectedFrequency: 0.0));
    }
    final recordStream = await _audioRecorder.startStream(const RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      numChannels: 1,
      bitRate: 128000,
      sampleRate: PitchDetector.DEFAULT_SAMPLE_RATE,
      noiseSuppress: true,
    ));

    var audioSampleBufferedStream = bufferedListStream(
      recordStream.map((event) {
        return event.toList();
      }),
      //The library converts a PCM16 to 8bits internally. So we need twice as many bytes
      PitchDetector.DEFAULT_BUFFER_SIZE * 2,
    );

    await for (var audioSample in audioSampleBufferedStream) {
      final intBuffer = Uint8List.fromList(audioSample);

      _pitchDetector.getPitchFromIntBuffer(intBuffer).then((detectedPitch) {
        if (detectedPitch.pitched) {
          _pitchHandler.handleFreq(detectedPitch.pitch).then((tuningResult) {
            // --- Buffer pour les freq (moyenne mobile numérique) ---
            /*
            _freqBuffer.add(tuningResult.actualFrequency);
            if (_freqBuffer.length > _bufferSize) {
              _freqBuffer.removeAt(0);
            }
            final smoothedFreq =
                _freqBuffer.reduce((a, b) => a + b) / _freqBuffer.length;

            // --- Buffer pour les notes (vote majoritaire) ---
            _noteBuffer.add(tuningResult.note);
            if (_noteBuffer.length > _bufferSize) {
              _noteBuffer.removeAt(0);
            }
            // Trouver la note la plus fréquente
            /*final smoothedNote = _noteBuffer
                .fold<Map<String, int>>({}, (map, note) {
              map[note] = (map[note] ?? 0) + 1;
              return map;
            })
                .entries
                .reduce((a, b) => a.value >= b.value ? a : b)
                .key;*/
            */
            // --- Émettre la fréquence lissée ---
            emit(tuningResult);
          });
        }
      });
    }
  }
}
