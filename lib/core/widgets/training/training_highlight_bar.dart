import 'package:bs/core/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Barra di stato in alto, usata in ogni sezione di allenamento (Cards,
/// Numbers, ...) durante il countdown della ready room e durante le fasi
/// di playing/recall.
///
/// Prima esistevano due widget quasi identici (`HighlightBarPhasePlaying`
/// e `HighlightBarRoomView`) che duplicavano contenitore, stile e
/// spaziature. Ora questo widget possiede solo il "chrome" (titolo,
/// decorazione, layout), mentre [info] e [actions] sono forniti da chi
/// lo usa in base alla fase.
class TrainingHighlightBar extends StatelessWidget {
  const TrainingHighlightBar({
    super.key,
    required this.title,
    required this.color,
    this.info = const [],
    this.actions = const [],
  });

  final String title;
  final Color color;

  /// Widget mostrati tra il titolo e i pulsanti (countdown, "Card X / Y",
  /// tempo trascorso, ...).
  final List<Widget> info;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: BsColors.overlay,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: BsColors.grey, width: 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Text(
              title,
              style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            const Spacer(),
            for (final widget in info) ...[widget, const SizedBox(width: 20)],
            for (final action in actions) ...[action, const SizedBox(width: 10)],
          ],
        ),
      ),
    );
  }
}

/// Etichetta testuale standard usata dentro [TrainingHighlightBar]
/// (es. "Card 3 / 52", "Recall Time: 1:24").
class TrainingBarLabel extends StatelessWidget {
  const TrainingBarLabel(this.text, {super.key, this.bold = true});

  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lato(
        fontSize: 14,
        color: BsColors.black,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}