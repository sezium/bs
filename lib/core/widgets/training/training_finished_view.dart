import 'package:bs/core/format.dart';
import 'package:bs/core/widgets/button.dart';
import 'package:bs/core/widgets/colors.dart';
import 'package:bs/sections/training/application/screen/training_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Schermata di fine sessione: mostra il tempo totale di recall e un
/// pulsante per tornare alla home.
///
/// FIX: prima, al termine della sessione, `CardsPhaseFinished`/
/// `NumbersPhaseFinished` mostravano direttamente `TrainingScreen()`
/// annidato dentro la Scaffold di Cards/Numbers (la route rimaneva
/// "/cards" o "/numbers" pur mostrando in video la home). Toccando una
/// card di quella home "finta" si faceva `context.push(...)`, che
/// impilava una nuova route sopra quella vecchia mai chiusa. Usando poi le
/// frecce per tornare indietro (back di sistema/browser) si attraversava
/// questa pila di route incoerente con quello che si vedeva a schermo,
/// mostrando schermate vecchie/sbagliate: la UI si "rompeva".
///
/// Qui invece si torna alla home con una navigazione vera
/// (`context.go(TrainingScreen.route)`), che sostituisce l'intero stack:
/// nessuna route fantasma resta impilata, quindi le frecce indietro
/// tornano a funzionare correttamente.
class TrainingFinishedView extends StatelessWidget {
  const TrainingFinishedView({super.key, required this.color, required this.totalRecallSeconds});

  final Color color;
  final int totalRecallSeconds;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: color, size: 64),
          const SizedBox(height: 16),
          Text(
            'Sessione completata',
            style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold, color: BsColors.black),
          ),
          const SizedBox(height: 8),
          Text(
            'Tempo di recall: ${formatMinutesSeconds(totalRecallSeconds)}',
            style: GoogleFonts.lato(fontSize: 16, color: BsColors.grey),
          ),
          const SizedBox(height: 32),
          bsButton(
            title: 'Torna alla home',
            color: color,
            onTap: () => context.go(TrainingScreen.route),
          ),
        ],
      ),
    );
  }
}
