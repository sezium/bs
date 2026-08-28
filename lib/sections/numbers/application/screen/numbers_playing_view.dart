import 'package:bs/core/extentions/build_context_extention.dart';
import 'package:bs/core/format.dart';
import 'package:bs/core/widgets/button.dart';
import 'package:bs/core/widgets/colors.dart';
import 'package:bs/core/widgets/training/training_highlight_bar.dart';
import 'package:bs/sections/numbers/application/bloc/numbers_bloc.dart';
import 'package:bs/sections/numbers/application/bloc/numbers_event.dart';
import 'package:bs/sections/numbers/application/screen/numbers_art.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

/// Mostra il numero corrente al centro, i numeri ancora da leggere a
/// sinistra e quelli già usciti a destra. Rettangoli di grandezza fissa,
/// più larghi che alti; i numeri sono sempre BsColors.black, il resto
/// (bordi, contorni, pulsanti) usa BsColors.blue.
class NumbersPlayingView extends StatefulWidget {
  const NumbersPlayingView({
    super.key,
    required this.numberSequence,
    required this.currentIndex,
    required this.secondsElapsed,
  });

  final List<int> numberSequence;
  final int currentIndex;
  final int secondsElapsed;

  @override
  State<NumbersPlayingView> createState() => _NumbersPlayingViewState();
}

class _NumbersPlayingViewState extends State<NumbersPlayingView> {
  static const double _centerWidth = 200;
  static const double _centerHeight = 80;
  static const double _sideWidth = 100;
  static const double _sideHeight = 40;

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
    if (event is! KeyDownEvent) return false;
    final bloc = context.read<NumbersBloc>();

    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      bloc.add(const NumbersEventNextNumber());
      return true;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      bloc.add(const NumbersEventPreviousNumber());
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NumbersBloc>();
    final current = widget.numberSequence[widget.currentIndex];
    final isFirst = widget.currentIndex == 0;

    // Successivi da leggere (a sinistra) e già usciti, dal più recente (a destra).
    final upcoming = widget.numberSequence.sublist(widget.currentIndex + 1);
    final gone = widget.numberSequence.sublist(0, widget.currentIndex).toList();

    return SizedBox.expand(
      child: Column(
        children: [
          TrainingHighlightBar(
            title: 'Numbers',
            color: BsColors.blue,
            info: [
              TrainingBarLabel('${widget.currentIndex + 1} / ${widget.numberSequence.length}'),
              TrainingBarLabel(formatMinutesSeconds(widget.secondsElapsed)),
            ],
            actions: [
              bsButton(title: 'Skip', color: BsColors.blue, onTap: () => bloc.add(const NumbersEventSkipPlaying())),
            ],
          ),

          const SizedBox(height: 16),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: BsColors.overlay,
                border: Border.all(color: BsColors.grey, width: 1),
              ),

              padding: EdgeInsets.symmetric(horizontal: 10),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _NumberList(numbers: upcoming, itemWidth: _sideWidth, itemHeight: _sideHeight),
                        ),
                        _buildCurrent(current),
                        Expanded(
                          child: _NumberList(
                            numbers: gone,
                            itemWidth: _sideWidth,
                            itemHeight: _sideHeight,
                            scrollLast: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        bsButtonIcon(
                          icon: Icons.restart_alt,
                          color: BsColors.blue,
                          onTap: () => bloc.add(const NumbersEventRestartSequence()),
                        ),
                        const SizedBox(width: 12),
                        bsButtonIcon(
                          icon: Icons.arrow_back,
                          color: BsColors.blue,
                          onTap: isFirst ? () {} : () => bloc.add(const NumbersEventPreviousNumber()),
                        ),
                        const SizedBox(width: 12),
                        bsButtonIcon(
                          icon: Icons.arrow_forward,
                          color: BsColors.blue,
                          onTap: () => bloc.add(const NumbersEventNextNumber()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrent(int number) {
    return Center(
      child: Container(
        width: _centerWidth,
        height: _centerHeight,
        decoration: BoxDecoration(
          color: BsColors.white,
          borderRadius: BorderRadius.circular(0),
          border: Border.all(color: BsColors.grey, width: 1),
        ),
        child: NumberArt(number: number, fontSize: 42),
      ),
    );
  }
}

/// Colonna scorrevole di numeri già usciti o ancora da leggere.
class _NumberList extends StatelessWidget {
  _NumberList({required this.numbers, required this.itemWidth, required this.itemHeight, this.scrollLast = false});

  final List<int> numbers;
  final double itemWidth;
  final double itemHeight;
  final bool scrollLast;

  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    if (scrollLast) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: numbers.isEmpty
              ? const SizedBox.shrink()
              : ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(scrollbars: false),
                  child: SizedBox(
                    height: itemHeight, // constrain height to itemHeight
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      scrollDirection: Axis.horizontal,
                      itemCount: numbers.length,
                      itemBuilder: (context, index) => Container(
                        width: itemWidth, // set fixed width for each item
                        height: itemHeight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(color: BsColors.grey),
                        ),
                        child: Center(child: NumberArt(number: numbers[index])),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
