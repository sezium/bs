import 'package:bs/core/extentions/build_context_extention.dart';
import 'package:bs/core/widgets/button.dart';
import 'package:bs/core/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Schermata iniziale generica di una sezione di allenamento: titolo,
/// immagine e pulsante "Start". Ogni sezione (Cards, Numbers, ...) passa
/// solo titolo, immagine e colore.
class TrainingStartView extends StatelessWidget {
  const TrainingStartView({
    super.key,
    required this.title,
    required this.imagePath,
    required this.color,
    required this.onStart,
  });

  final String title;
  final String imagePath;
  final Color color;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // if(!context.isMobile)
            // SizedBox(
            //   width: 200,
            //   child: Text(
            //     title,
            //     style: GoogleFonts.lato(color: color, fontSize: 28, fontWeight: FontWeight.bold),
            //   ),
            // ),
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 150, // You can adjust this value as needed
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
       
          ],
        ),
         const SizedBox(height: 24),
         Padding(
           padding: const EdgeInsets.only(top: 24, bottom: 36),
           child: Divider(color: BsColors.grey),
         ),
        const SizedBox(height: 36),
        Center(child: bsButton(title: 'Start', color: color, onTap: onStart)),
      ],
    );
  }
}