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

/// Fase di richiamo: l'utente ripiazza le carte dal mazzo negli slot nello
/// stesso ordine in cui le ha viste. Riceve solo i dati della fase e legge
/// il bloc dal context per dispatchare gli eventi: prima gli stessi
/// callback venivano ricreati (e ripassati identici) nello switch dello
/// screen, qui sono semplici `context.read<CardsBloc>().add(...)`.
class CardsRecallView extends StatefulWidget {
  const CardsRecallView({
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
  State<CardsRecallView> createState() => _CardsRecallViewState();
}

class _CardsRecallViewState extends State<CardsRecallView> {
  static const double _slotWidth = 60;
  static const double _slotHeight = 84;
  static const double _slotOverlap = 40;

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
      context.read<CardsBloc>().add(CardsEventReturnCardToDeck(slotIndex: slotIndex));
    }
    setState(() => _currentSlotIndex = slotIndex);
  }

  void _onTapDeckCard(int card) {
    if (widget.submitted) return;
    if (widget.placedSlots[_currentSlotIndex] != null) return;

    context.read<CardsBloc>().add(CardsEventPlaceCard(card: card, slotIndex: _currentSlotIndex));

    // Avanza automaticamente al prossimo slot vuoto, se presente.
    final nextEmpty = widget.placedSlots.indexWhere((c) => c == null, _currentSlotIndex + 1);
    final fallbackEmpty = nextEmpty != -1 ? nextEmpty : widget.placedSlots.indexWhere((c) => c == null);
    if (fallbackEmpty != -1) setState(() => _currentSlotIndex = fallbackEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final allPlaced = !widget.placedSlots.contains(null);
    final bloc = context.read<CardsBloc>();

    return SizedBox.expand(
      child: Column(
        children: [
          TrainingHighlightBar(
            title: 'Recall',
            color: BsColors.red,
            info: [TrainingBarLabel('Recall Time: ${formatMinutesSeconds(widget.recallSecondsElapsed)}')],
            // Il tasto "End" compare solo dopo la conferma: prima era
            // sempre visibile e chiamava context.pop() invece di chiudere
            // davvero la sessione.
            actions: [
              if (widget.submitted)
                bsButton(title: 'End', color: BsColors.red, onTap: () => bloc.add(const CardsEventFinishRecall())),
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
                color: BsColors.red,
                onTap: allPlaced ? () => bloc.add(const CardsEventConfirmRecall()) : () {},
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSlots() {
    return OverlappingStackGrid(
      itemCount: widget.placedSlots.length,
      itemWidth: _slotWidth,
      itemHeight: _slotHeight,
      overlap: _slotOverlap,
      itemBuilder: (context, slotIndex) => _buildSlot(slotIndex),
    );
  }

  Widget _buildSlot(int slotIndex) {
    final placedCard = widget.placedSlots[slotIndex];
    final isCurrent = slotIndex == _currentSlotIndex;
    final isCorrect = widget.submitted && placedCard != null && placedCard == widget.originalSequence[slotIndex];
    final isWrong = widget.submitted && placedCard != null && !isCorrect;

    Color background;
    Color borderColor;

    if (widget.submitted) {
      if (isCorrect) {
        background = BsColors.green.withValues(alpha: 0.35);
        borderColor = BsColors.green;
      } else if (isWrong) {
        background = BsColors.red.withValues(alpha: 0.35);
        borderColor = BsColors.red;
      } else {
        background = BsColors.white;
        borderColor = BsColors.grey;
      }
    } else if (isCurrent) {
      background = placedCard == null ? BsColors.red.withValues(alpha: 0.25) : Colors.white;
      borderColor = BsColors.red;
    } else {
      background = Colors.white;
      borderColor = BsColors.grey;
    }

    return GestureDetector(
      onTap: () => _onTapSlot(slotIndex),
      child: Container(
        width: _slotWidth,
        height: _slotHeight,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: placedCard != null ? CardArt(cardIndex: placedCard) : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildDeck() {
    return OverlappingStackGrid(
      itemCount: widget.deck.length,
      itemWidth: _slotWidth,
      itemHeight: _slotHeight,
      overlap: _slotOverlap,
      rowSpacing: 16,
      itemBuilder: (context, deckIndex) => _buildDeckCard(widget.deck[deckIndex]),
    );
  }

  Widget _buildDeckCard(int card) {
    return GestureDetector(
      onTap: () => _onTapDeckCard(card),
      child: Container(
        width: _slotWidth,
        height: _slotHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: BsColors.grey, width: 1),
        ),
        child: CardArt(cardIndex: card),
      ),
    );
  }
}