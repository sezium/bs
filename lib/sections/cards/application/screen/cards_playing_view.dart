import 'package:bs/core/format.dart';
import 'package:bs/core/widgets/button.dart';
import 'package:bs/core/widgets/colors.dart';
import 'package:bs/core/widgets/training/overlapping_grid.dart';
import 'package:bs/core/widgets/training/training_highlight_bar.dart';
import 'package:bs/sections/cards/application/bloc/cards_bloc.dart';
import 'package:bs/sections/cards/application/bloc/cards_event.dart';
import 'package:bs/sections/cards/application/screen/card_art.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Mostra la carta corrente con i controlli next/previous/restart.
///
/// Precarica ogni SVG della sequenza prima del primo frame, così cambiare
/// carta non causa mai un lag di decodifica asset.
class CardsPlayingView extends StatefulWidget {
  const CardsPlayingView({
    super.key,
    required this.cardSequence,
    required this.currentIndex,
    required this.secondsElapsed,
  });

  final List<int> cardSequence;
  final int currentIndex;
  final int secondsElapsed;

  @override
  State<CardsPlayingView> createState() => _CardsPlayingViewState();
}

class _CardsPlayingViewState extends State<CardsPlayingView> {
  static const double _thumbWidth = 80;
  static const double _thumbHeight = 110;
  static const double _overlap = 60;

  bool _assetsReady = false;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    // Lasciamo passare due frame con tutte le SvgPicture costruite offstage:
    // questo forza flutter_svg a caricare e decodificare ogni SVG e a
    // metterle in cache, prima di mostrare la UI reale.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _assetsReady = true);
      });
    });
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final bloc = context.read<CardsBloc>();

    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      bloc.add(const CardsEventNextCard());
      return true;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      bloc.add(const CardsEventPreviousCard());
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Offstage(
          child: Column(
            children: [for (final card in widget.cardSequence) CardArt(cardIndex: card, width: 200, height: 300)],
          ),
        ),
        if (!_assetsReady) Center(child: CircularProgressIndicator(color: BsColors.red)) else _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    final card = widget.cardSequence[widget.currentIndex];
    final isFirst = widget.currentIndex == 0;
    final bloc = context.read<CardsBloc>();

    return SizedBox.expand(
      child: Column(
        children: [
          TrainingHighlightBar(
            title: 'Cards',
            color: BsColors.red,
            info: [
              TrainingBarLabel('Card ${widget.currentIndex + 1} / ${widget.cardSequence.length}'),
              TrainingBarLabel('Recall Time: ${formatMinutesSeconds(widget.secondsElapsed)}'),
            ],
            actions: [
              bsButton(title: 'Skip', color: BsColors.red, onTap: () => bloc.add(const CardsEventSkipPlaying())),
            ],
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                key: ValueKey('card-box-$card'),
                width: 200,
                height: 300,
                child: CardArt(cardIndex: card, width: 200, height: 300),
              ),
            ),
          ),
          _buildThumbnailRow(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                bsButtonIcon(
                  icon: Icons.restart_alt,
                  color: BsColors.red,
                  onTap: () => bloc.add(const CardsEventRestartSequence()),
                ),
                const SizedBox(width: 12),
                bsButtonIcon(
                  icon: Icons.arrow_back,
                  color: BsColors.red,
                  onTap: isFirst ? () {} : () => bloc.add(const CardsEventPreviousCard()),
                ),
                const SizedBox(width: 12),
                bsButtonIcon(
                  icon: Icons.arrow_forward,
                  color: BsColors.red,
                  onTap: () => bloc.add(const CardsEventNextCard()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnailRow() {
    return OverlappingStackGrid(
      itemCount: widget.cardSequence.length,
      itemWidth: _thumbWidth,
      itemHeight: _thumbHeight,
      overlap: _overlap,
      itemBuilder: (context, index) => _buildThumb(index),
    );
  }

  Widget _buildThumb(int index) {
    final isSelected = index == widget.currentIndex;
    final card = widget.cardSequence[index];

    return Transform.translate(
      offset: Offset(0, isSelected ? 0 : 5),
      child: Container(
        width: _thumbWidth,
        height: _thumbHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: isSelected ? BsColors.red : BsColors.transparent, width: isSelected ? 1 : 0),
        ),
        child: CardArt(cardIndex: card),
      ),
    );
  }
}