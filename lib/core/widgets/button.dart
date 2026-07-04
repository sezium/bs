import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget bsButton({
  required String title,
  required Color color,
  required VoidCallback onTap,
  Key? key,
}) {
  return ElevatedButton(
    key: key,
    onPressed: onTap,
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(color),
      foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      padding: WidgetStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      elevation: WidgetStateProperty.all<double>(0),
      overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
      shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
      surfaceTintColor: WidgetStateProperty.all<Color>(Colors.transparent),
    ),
    child: Text(
      title,
      style: GoogleFonts.lato(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );
}

Widget bsButtonIcon({
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
  Key? key,
}) {
  return ElevatedButton(
    key: key,
    onPressed: onTap,
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(color),
      foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(14)),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      elevation: WidgetStateProperty.all<double>(0),
      overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
      shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
      surfaceTintColor: WidgetStateProperty.all<Color>(Colors.transparent),
      minimumSize: WidgetStateProperty.all<Size>(const Size(48, 48)),
    ),
    child: Icon(icon, color: Colors.white, size: 22),
  );
}