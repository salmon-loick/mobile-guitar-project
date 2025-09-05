class TuningResult {
  final String note;
  final double centsOff;
  String get centsOffString => centsOff.toInt().toString();
  TuningResult({
    required this.note,
    required this.centsOff,
  });
}