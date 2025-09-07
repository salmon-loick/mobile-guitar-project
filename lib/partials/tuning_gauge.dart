import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobile_guitar_project/partials/detected_note_display.dart';
import 'package:mobile_guitar_project/partials/tuning_status.dart';
import 'package:mobile_guitar_project/styles/colors.dart';

class TuningGauge extends StatelessWidget {
  final String note;
  final double centsOff; // ex: -30, +15
  final double maxCents; // amplitude max, ex: ±50
  final bool pitchDetected;

  const TuningGauge({
    Key? key,
    required this.note,
    required this.centsOff,
    required this.pitchDetected,
    this.maxCents = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        TuningStatus(centsOff: centsOff,isTuning: pitchDetected,),
        CustomPaint(
          size: const Size(400, 200), // largeur x hauteur du widget
          painter: _GaugePainter(context: context,
              centsOff: centsOff, maxCents: maxCents, paintNeedle: pitchDetected),
        ),
        DetectedNoteDisplay(note: note)
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  final BuildContext context;
  final double centsOff;
  final double maxCents;
  final bool paintNeedle;

  _GaugePainter({required this.context,
      required this.centsOff, required this.maxCents, this.paintNeedle = true});

  @override
  void paint(Canvas canvas, Size size) {

    final center = Offset(size.width / 2, size.height * 1+20); // centre de l'arc (en bas au milieu)
    final radius = min(size.width / 2.2, size.height);

    const sweepAngle = 2 * pi / 3; // 120°
    const startAngle = -5 * pi / 6;

    // --- Fond derrière la jauge (uniquement sous l'arc) ---
    final bgPaint = Paint()
      ..color = Theme.of(context).unselectedWidgetColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 20; // épaisseur du fond (comme l'arc)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius+25),
      startAngle - 0.1, // léger décalage pour couvrir les graduations
      sweepAngle + 0.2, // léger décalage pour couvrir les graduations
      true, // false = arc, true = secteur
      bgPaint,
    );
    final borderPaint = Paint()
      ..color = Theme.of(context).primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2; // bordure fine
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius+25),
      startAngle - 0.1,
      sweepAngle + 0.2,
      true,
      borderPaint,
    );

    // Graduations principales et secondaires
    int majorSteps = 10;
    int minorSteps = 50; // 5 minor ticks par major
    double majorTickLength = 20;
    double minorTickLength = 10;

    for (int i = 0; i <= minorSteps; i++) {
      double value = -maxCents + (2 * maxCents / minorSteps) * i;
      double ratio = (value / maxCents).clamp(-1.0, 1.0);
      double angle = startAngle + (sweepAngle / 2) + (ratio * (sweepAngle / 2));

      final tickLength = (i % (minorSteps ~/ majorSteps) == 0)
          ? majorTickLength
          : minorTickLength;
      final inner = Offset(center.dx + cos(angle) * (radius - tickLength),
          center.dy + sin(angle) * (radius - tickLength));
      final outer = Offset(
          center.dx + cos(angle) * radius, center.dy + sin(angle) * radius);

      canvas.drawLine(inner, outer, Paint()
        ..color = Theme.of(context).primaryColor
        ..strokeWidth = 2);

      // Texte uniquement sur graduations principales
      if (i % (minorSteps ~/ majorSteps) == 0) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: value.toInt().toString(),
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        // Décalage radial vers l'extérieur
        double textRadius = radius + 15; // quelques pixels en dehors du cercle
        final textOffset = Offset(
          center.dx + cos(angle) * textRadius - textPainter.width / 2,
          center.dy + sin(angle) * textRadius - textPainter.height / 2,
        );
        textPainter.paint(canvas, textOffset);
      }
    }

    // Aiguille
    if(paintNeedle) {
      final needleRatio = (centsOff / maxCents).clamp(-1.0, 1.0);
      final needleAngle = startAngle + (sweepAngle / 2) +
          (needleRatio * (sweepAngle / 2));
      final needleEnd = Offset(center.dx + cos(needleAngle) * radius,
          center.dy + sin(needleAngle) * radius);
      canvas.drawLine(
        center,
        needleEnd,
        Paint()
          ..color = (centsOff.abs() < 5 ? kGreenColor : kRedColor)
          ..strokeWidth = 3,
      );
    }
    // Pivot central
    canvas.drawCircle(center, 6, Paint()
      ..color = Theme.of(context).primaryColor);
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) =>
      oldDelegate.centsOff != centsOff;
}
