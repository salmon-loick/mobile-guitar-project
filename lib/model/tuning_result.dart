import 'dart:math';
class TuningResult {
  final String note;
  final double actualFrequency;
  final double expectedFrequency;
  double get diffFrequency => actualFrequency - expectedFrequency;
  double get centsOff {
    if (actualFrequency <= 0.000001 || expectedFrequency <= 0.000001) {
      return 0.0;
    }
    return 1200.0 * log(actualFrequency / expectedFrequency);
  }
  String get centsOffString => centsOff.toInt().toString();
  TuningResult({
    required this.note,
    required this.actualFrequency,
    required this.expectedFrequency,
  });
}