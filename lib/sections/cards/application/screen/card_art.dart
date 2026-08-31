import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Disegna l'SVG di una carta. Centralizza qui la convenzione dei nomi
/// asset ('cards/card$n.svg'), prima ripetuta in tre punti diversi.
class CardArt extends StatelessWidget {
  const CardArt({
    super.key,
    required this.cardIndex,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final int cardIndex;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    // FIX: mancava il prefisso 'assets/' richiesto dal path dichiarato in
    // pubspec.yaml ('assets/'). La chiave generata da Flutter per ogni file
    // è il path completo dal root del progetto (es. 'assets/cards/card0.svg'),
    // quindi 'cards/card0.svg' non veniva mai trovato: in release (APK) il
    // fallback silenzioso di flutter_svg lasciava lo spazio vuoto/bianco.
    return SvgPicture.asset('cards/card$cardIndex.svg', width: width, height: height, fit: fit);
  }
}