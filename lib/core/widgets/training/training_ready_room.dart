import 'package:bs/core/format.dart';
import 'package:bs/core/widgets/button.dart';
import 'package:bs/core/widgets/training/training_highlight_bar.dart';
import 'package:flutter/material.dart';

/// Countdown prima dell'inizio della memorizzazione. Generica: qualsiasi
/// sezione la usa passando solo titolo/colore/secondi rimanenti.
class TrainingReadyRoomView extends StatelessWidget {
  const TrainingReadyRoomView({
    super.key,
    required this.title,
    required this.color,
    required this.secondsRemaining,
    required this.onSkip,
  });

  final String title;
  final Color color;
  final int secondsRemaining;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TrainingHighlightBar(
          title: title,
          color: color,
          info: [TrainingBarLabel(formatMinutesSeconds(secondsRemaining))],
          actions: [bsButton(title: 'Skip', color: color, onTap: onSkip)],
        ),
      ],
    );
  }
}