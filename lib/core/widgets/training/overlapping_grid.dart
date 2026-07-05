import 'package:flutter/material.dart';

/// Dispone [itemCount] elementi di dimensione fissa in righe che si
/// sovrappongono orizzontalmente, andando a capo quando lo spazio
/// disponibile finisce.
///
/// Prima questa logica (calcolo di quanti elementi entrano per riga,
/// split in righe, Stack con Positioned) era copiata quasi identica in
/// tre punti: slot di recall, deck di recall, sequenza di playing.
/// Ora è un solo widget generico: ogni sezione (Cards, Numbers, ...)
/// fornisce solo `itemBuilder` con l'aspetto del singolo elemento.
///
/// [itemBuilder] deve restituire un widget che si dimensiona da solo a
/// [itemWidth] x [itemHeight]. Se un elemento vuole apparire "sollevato"
/// o leggermente più grande quando selezionato, può farlo internamente
/// (es. con `Transform.translate`), perché lo Stack ha
/// `clipBehavior: Clip.none`.
class OverlappingStackGrid extends StatelessWidget {
  const OverlappingStackGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.itemWidth,
    required this.itemHeight,
    required this.overlap,
    this.rowSpacing = 12,
    this.rowExtraHeight = 10,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double itemWidth;
  final double itemHeight;
  final double overlap;
  final double rowSpacing;
  final double rowExtraHeight;

  @override
  Widget build(BuildContext context) {
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
      child: Center(
        child: SizedBox(
          width: totalWidth,
          child: Stack(
            alignment: Alignment.center,
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