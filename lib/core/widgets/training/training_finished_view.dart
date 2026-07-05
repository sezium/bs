import 'package:bs/core/format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Schermata di fine sessione: tempo totale di recall + pulsante restart.
/// I testi sono parametrizzati (non hardcoded in italiano) così ogni
/// sezione può personalizzarli mantenendo lo stesso layout.
class TrainingFinishedView extends StatelessWidget {
  const TrainingFinishedView({
    super.key,
    required this.totalRecallSeconds,
    required this.onRestart,
    this.timeLabel = 'Tempo di recall',
    this.restartLabel = 'Ricomincia',
  });

  final int totalRecallSeconds;
  final VoidCallback onRestart;
  final String timeLabel;
  final String restartLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$timeLabel: ${formatMinutesSeconds(totalRecallSeconds)}',
            style: GoogleFonts.lato(fontSize: 18, color: Colors.grey[700]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRestart,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Text(restartLabel),
            ),
          ),
        ],
      ),
    );
  }
}