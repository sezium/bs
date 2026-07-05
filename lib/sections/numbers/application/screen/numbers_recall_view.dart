import 'package:bs/core/format.dart';
import 'package:bs/core/widgets/button.dart';
import 'package:bs/core/widgets/colors.dart';
import 'package:bs/core/widgets/overlapping_grid.dart';
import 'package:bs/core/widgets/training/training_highlight_bar.dart';
import 'package:bs/sections/numbers/application/bloc/numbers_bloc.dart';
import 'package:bs/sections/numbers/application/bloc/numbers_event.dart';
import 'package:bs/sections/numbers/application/screen/numbers_art.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Fase di richiamo: l'utente ripiazza i numeri dal mazzo negli slot nello
/// stesso ordine in cui li ha visti. Stessa meccanica di `CardsRecallView`,
/// ma con tessere numeriche rettangolari (più larghe che alte) invece di
/// carte, e tema verde invece che rosso.
class NumbersRecallView extends StatefulWidget {
  const NumbersRecallView({
    super.key,
    required this.originalSequence,
    required this.deck,
    required this.placedSlots,
    required this.recallSecondsElapsed,
    required this.submitted,
  });

  final List<int> originalSequence;
  final List<int> deck;
  final List<int?> placedSlots;
  final int recallSecondsElapsed;
  final bool submitted;

  @override
  State<NumbersRecallView> createState() => _NumbersRecallViewState();
}

class _NumbersRecallViewState extends State<NumbersRecallView> {
  static const double _tileWidth = 56;
  static const double _tileHeight = 40;
  static const double _tileOverlap = 20;

  int _currentSlotIndex = 0;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (widget.submitted) return false;
    if (event is! KeyDownEvent) return false;

    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _moveCurrentSlot(1);
      return true;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _moveCurrentSlot(-1);
      return true;
    }
    return false;
  }

  void _moveCurrentSlot(int delta) {
    final last = widget.placedSlots.length - 1;
    setState(() => _currentSlotIndex = (_currentSlotIndex + delta).clamp(0, last));
  }

  void _onTapSlot(int slotIndex) {
    if (widget.submitted) return;
    if (widget.placedSlots[slotIndex] != null) {
      context.read<NumbersBloc>().add(NumbersEventReturnNumberToDeck(slotIndex: slotIndex));
    }
    setState(() => _currentSlotIndex = slotIndex);
  }

  void _onTapDeckNumber(int number) {
    if (widget.submitted) return;
    if (widget.placedSlots[_currentSlotIndex] != null) return;

    context.read<NumbersBloc>().add(NumbersEventPlaceNumber(number: number, slotIndex: _currentSlotIndex));

    // Avanza automaticamente al prossimo slot vuoto, se presente.
    final nextEmpty = widget.placedSlots.indexWhere((c) => c == null, _currentSlotIndex + 1);
    final fallbackEmpty = nextEmpty != -1 ? nextEmpty : widget.placedSlots.indexWhere((c) => c == null);
    if (fallbackEmpty != -1) setState(() => _currentSlotIndex = fallbackEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final allPlaced = !widget.placedSlots.contains(null);
    final bloc = context.read<NumbersBloc>();

    return SizedBox.expand(
      child: Column(
        children: [
          TrainingHighlightBar(
            title: 'Recall',
            color: BsColors.blue,
            info: [TrainingBarLabel('Recall Time: ${formatMinutesSeconds(widget.recallSecondsElapsed)}')],
            actions: [
              if (widget.submitted)
                bsButton(title: 'End', color: BsColors.blue, onTap: () => bloc.add(const NumbersEventFinishRecall())),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  _buildSlots(),
                  if (!widget.submitted) ...[
                    const SizedBox(height: 24),
                    _buildDeck(),
                  ],
                ],
              ),
            ),
          ),
          if (!widget.submitted)
            Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 8),
              child: bsButton(
                title: 'Conferma',
                color: BsColors.blue,
                onTap: allPlaced ? () => bloc.add(const NumbersEventConfirmRecall()) : () {},
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSlots() {
    return OverlappingGrid(
      itemCount: widget.placedSlots.length,
      itemWidth: _tileWidth,
      itemHeight: _tileHeight,
      overlap: _tileOverlap,
      itemBuilder: (context, slotIndex) => _buildSlot(slotIndex),
    );
  }

  Widget _buildSlot(int slotIndex) {
    final placedNumber = widget.placedSlots[slotIndex];
    final isCurrent = slotIndex == _currentSlotIndex;
    final isCorrect =
        widget.submitted && placedNumber != null && placedNumber == widget.originalSequence[slotIndex];
    final isWrong = widget.submitted && placedNumber != null && !isCorrect;

    Color background;
    Color borderColor;

    if (widget.submitted) {
      if (isCorrect) {
        background = BsColors.blue.withValues(alpha: 0.35);
        borderColor = BsColors.blue;
      } else if (isWrong) {
        background = BsColors.red.withValues(alpha: 0.35);
        borderColor = BsColors.red;
      } else {
        background = BsColors.white;
        borderColor = BsColors.grey;
      }
    } else if (isCurrent) {
      background = placedNumber == null ? BsColors.blue.withValues(alpha: 0.25) : Colors.white;
      borderColor = BsColors.blue;
    } else {
      background = Colors.white;
      borderColor = BsColors.grey;
    }

    return GestureDetector(
      onTap: () => _onTapSlot(slotIndex),
      child: Container(
        width: _tileWidth,
        height: _tileHeight,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: placedNumber != null ? NumberArt(number: placedNumber) : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildDeck() {
    return OverlappingGrid(
      itemCount: widget.deck.length,
      itemWidth: _tileWidth,
      itemHeight: _tileHeight,
      overlap: _tileOverlap,
      rowSpacing: 16,
      itemBuilder: (context, deckIndex) => _buildDeckTile(widget.deck[deckIndex]),
    );
  }

  Widget _buildDeckTile(int number) {
    return GestureDetector(
      onTap: () => _onTapDeckNumber(number),
      child: Container(
        width: _tileWidth,
        height: _tileHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: BsColors.blue, width: 1),
        ),
        child: NumberArt(number: number),
      ),
    );
  }
}