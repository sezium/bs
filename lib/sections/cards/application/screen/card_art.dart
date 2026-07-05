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
    return SvgPicture.asset('cards/card$cardIndex.svg', width: width, height: height, fit: fit);
  }
}