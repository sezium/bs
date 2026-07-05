/// Formatta un numero di secondi come `m:ss`, es. 125 -> "2:05".
///
/// Centralizzato qui perché prima la stessa espressione
/// (`x ~/ 60` + `padLeft`) era duplicata in tre punti diversi
/// (ready room, playing/recall bar, finished view).
String formatMinutesSeconds(int totalSeconds) {
  final safeSeconds = totalSeconds < 0 ? 0 : totalSeconds;
  final minutes = safeSeconds ~/ 60;
  final seconds = safeSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}