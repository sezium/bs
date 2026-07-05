import 'dart:ui';

sealed class BsColors {
  static Color get red => const Color(0xFFFF0000);
  static Color get yellow => const Color(0xFFFFE600);
  static Color get olive => const Color.fromARGB(255, 102, 142, 0);
  static Color get green => const Color.fromARGB(255, 0, 142, 5);
  static Color get blue => const Color.fromARGB(255, 0, 129, 235);
  static Color get purple => const Color.fromARGB(255, 217, 0, 255);
  static Color get white => const Color(0xFFFFFFFF);
  static Color get black => const Color(0xFF000000);
  static Color get grey => const Color(0xFFACACAC);
  static Color get button => const Color.fromARGB(255, 0, 129, 235);
  static Color get overlay => const Color.fromARGB(255, 244, 244, 244);
  static Color get transparent => const Color(0x00000000);
  
}