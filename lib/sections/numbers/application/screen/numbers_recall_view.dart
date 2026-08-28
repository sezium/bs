import 'package:bs/core/format.dart';
import 'package:bs/core/widgets/button.dart';
import 'package:bs/core/widgets/colors.dart';
import 'package:bs/core/widgets/overlapping_grid.dart';
import 'package:bs/core/widgets/training/training_highlight_bar.dart';
import 'package:bs/sections/numbers/application/bloc/numbers_bloc.dart';
import 'package:bs/sections/numbers/application/bloc/numbers_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Fase di richiamo: l'utente scrive, in ogni slot, il numero che ricorda
/// in quella posizione. I numeri possono ripetersi, quindi non esiste più
/// un mazzo di carte uniche: si usano dei TextField numerici.
class NumbersRecallView extends StatefulWidget {
  const NumbersRecallView({
    super.key,
    required this.originalSequence,
    required this.placedSlots,
    required this.recallSecondsElapsed,
    required this.submitted,
  });

  final List<int> originalSequence;
  final List<int?> placedSlots;
  final int recallSecondsElapsed;
  final bool submitted;

  @override
  State<NumbersRecallView> createState() => _NumbersRecallViewState();
}

class _NumbersRecallViewState extends State<NumbersRecallView> {
  static const double _tileWidth = 56;
  static const double _tileHeight = 40;
  static const double _tileOverlap = 1;

  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _controllers = List.generate(
      widget.placedSlots.length,
      (i) => TextEditingController(text: widget.placedSlots[i]?.toString().padLeft(2, '0') ?? ''),
    );
    _focusNodes = List.generate(widget.placedSlots.length, (_) => FocusNode());
  }

  @override
  void didUpdateWidget(covariant NumbersRecallView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Se cambia la lunghezza della sequenza (nuova partita) ricreo tutto.
    if (oldWidget.placedSlots.length != widget.placedSlots.length) {
      for (final c in _controllers) {
        c.dispose();
      }
      for (final f in _focusNodes) {
        f.dispose();
      }
      _initControllers();
      return;
    }
    // Sincronizza il testo solo se il campo non ha il focus, per non
    // interferire con quello che l'utente sta scrivendo.
    for (var i = 0; i < widget.placedSlots.length; i++) {
      if (_focusNodes[i].hasFocus) continue;
      final expected = widget.placedSlots[i]?.toString().padLeft(2, '0') ?? '';
      if (_controllers[i].text != expected) {
        _controllers[i].text = expected;
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(int slotIndex, String value) {
    if (widget.submitted) return;
    final bloc = context.read<NumbersBloc>();

    if (value.isEmpty) {
      bloc.add(NumbersEventPlaceNumber(number: null, slotIndex: slotIndex));
      return;
    }

    final parsed = int.tryParse(value);
    if (parsed == null) return;
    bloc.add(NumbersEventPlaceNumber(number: parsed.clamp(0, 99), slotIndex: slotIndex));

    // Passa automaticamente al campo successivo dopo 2 cifre.
    if (value.length >= 2 && slotIndex + 1 < _focusNodes.length) {
      FocusScope.of(context).requestFocus(_focusNodes[slotIndex + 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allFilled = !widget.placedSlots.contains(null);
    final bloc = context.read<NumbersBloc>();

    return SizedBox.expand(
      child: Column(
        children: [
          TrainingHighlightBar(
            title: 'Recall',
            color: BsColors.blue,
            info: [TrainingBarLabel(formatMinutesSeconds(widget.recallSecondsElapsed))],
            actions: [
              if (widget.submitted)
                bsButton(title: 'End', color: BsColors.blue, onTap: () => bloc.add(const NumbersEventFinishRecall())),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(child: Column(children: [const SizedBox(height: 12), _buildSlots()])),
          ),
          if (!widget.submitted)
            Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 8),
              child: bsButton(
                title: 'Confirm',
                color: BsColors.blue,
                onTap: allFilled ? () => bloc.add(const NumbersEventConfirmRecall()) : () {},
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
      rowSpacing: 0,
      rowExtraHeight: 15,

      itemBuilder: (context, slotIndex) => _buildSlot(slotIndex),
    );
  }

 Widget _buildSlot(int slotIndex) {
    final placedNumber = widget.placedSlots[slotIndex];
    final isCorrect = widget.submitted && placedNumber != null && placedNumber == widget.originalSequence[slotIndex];
    final isWrong = widget.submitted && placedNumber != null && !isCorrect;

    Color background;
    Color borderColor;

    if (widget.submitted) {
      if (isCorrect) {
        background = BsColors.correct.withValues(alpha: 0.8);
        borderColor = BsColors.black;
      } else if (isWrong) {
        background = BsColors.red.withValues(alpha: 0.8);
        borderColor = BsColors.black;
      } else {
        background = BsColors.white;
        borderColor = BsColors.grey;
      }
    } else {
      background = Colors.white;
      borderColor = BsColors.grey;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (isWrong)
          Positioned(
            left: 0,
            right: 0,
            top: -16,
            child: Center(
              child: Text(
                widget.originalSequence[slotIndex].toString().padLeft(2, '0'),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: BsColors.black,
                ),
              ),
            ),
          ),
        Container(
          width: _tileWidth,
          height: _tileHeight,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Center(
            child: TextField(
              cursorColor: BsColors.black,
              cursorHeight: 20.0,
              cursorWidth: 1.0,
              controller: _controllers[slotIndex],
              focusNode: _focusNodes[slotIndex],
              enabled: !widget.submitted,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: BsColors.black,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => _onChanged(slotIndex, value),
            ),
          ),
        ),
      ],
    );
  }
}
