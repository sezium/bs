import 'package:bs/core/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Disegna un numero a due cifre (es. "07"). Il testo è sempre
/// BsColors.black: sfondo e bordo del rettangolo li decide chi lo usa
/// (numero corrente, slot, deck, lista...).
class NumberArt extends StatelessWidget {
  const NumberArt({super.key, required this.number, this.fontSize = 20});

  final int number;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        number.toString().padLeft(2, '0'),
        style: GoogleFonts.lato(fontSize: fontSize, fontWeight: FontWeight.bold, color: BsColors.black),
      ),
    );
  }
}