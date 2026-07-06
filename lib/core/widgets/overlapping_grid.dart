import 'package:flutter/material.dart';

/// Dispone [itemCount] elementi di dimensione fissa in righe che si
/// sovrappongono orizzontalmente, andando a capo quando lo spazio
/// disponibile finisce.
///
/// Un solo widget generico condiviso da tutte le sezioni (Cards, Numbers,
/// ...): ogni sezione fornisce solo [itemBuilder] con l'aspetto del
/// singolo elemento (carta, tessera numerica, ...).
///
/// [itemBuilder] deve restituire un widget che si dimensiona da solo a
/// [itemWidth] x [itemHeight]. Se un elemento vuole apparire "sollevato"
/// o leggermente più grande quando selezionato, può farlo internamente
/// (es. con `Transform.translate`), perché lo Stack ha
/// `clipBehavior: Clip.none`.
class OverlappingGrid extends StatelessWidget {
  const OverlappingGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.itemWidth,
    required this.itemHeight,
    required this.overlap,
    this.rowSpacing = 12,
    this.rowExtraHeight = 10,
  });

  /// Numero totale di elementi da disporre.
  final int itemCount;

  /// Costruisce il widget per l'elemento all'indice [index].
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Larghezza di ogni elemento, usata anche per calcolare quanti
  /// elementi entrano per riga.
  final double itemWidth;

  /// Altezza di ogni elemento.
  final double itemHeight;

  /// Quanto ogni elemento si sovrappone al successivo (in pixel).
  /// Deve essere minore di [itemWidth].
  final double overlap;

  /// Spazio verticale tra una riga e la successiva.
  final double rowSpacing;

  /// Spazio extra aggiunto all'altezza di ogni riga, per lasciare respiro
  /// a piccoli scostamenti verticali (es. l'elemento selezionato che si
  /// "solleva" leggermente).
  final double rowExtraHeight;

  @override
  Widget build(BuildContext context) {
    assert(overlap < itemWidth, 'overlap deve essere minore di itemWidth, altrimenti step <= 0');

    final step = itemWidth - overlap;

    return LayoutBuilder(
      builder: (context, constraints) {
        var perRow = ((constraints.maxWidth - itemWidth) / step).floor() + 1;
        if (perRow < 1) perRow = 1;

        final rows = <List<int>>[];
        for (var i = 0; i < itemCount; i += perRow) {
          final end = (i + perRow < itemCount) ? i + perRow : itemCount;
          rows.add(List.generate(end - i, (j) => i + j));
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final row in rows) ...[
              _buildRow(row, step),
              if (row != rows.last) SizedBox(height: rowSpacing),
            ],
          ],
        );
      },
    );
  }
Widget _buildRow(List<int> indices, double step) {
  final totalWidth = itemWidth + (indices.length - 1) * step;

  return SizedBox(
    height: itemHeight + rowExtraHeight,
    child: Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: totalWidth,
        child: Stack(
          alignment: Alignment.centerLeft,
          clipBehavior: Clip.none,
          children: [
            for (var pos = 0; pos < indices.length; pos++)
              Positioned(
                left: pos * step,
                child: Builder(builder: (context) => itemBuilder(context, indices[pos])),
              ),
          ],
        ),
      ),
    ),
  );
}
}