import 'package:bs/base/application/screen/base_screen.dart';
import 'package:bs/core/widgets/colors.dart';
import 'package:bs/core/widgets/button.dart';
import 'package:bs/sections/cards/application/bloc/cards_bloc.dart';
import 'package:bs/sections/cards/application/bloc/cards_event.dart';
import 'package:bs/sections/cards/application/bloc/cards_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart'; 

class CardsScreen extends SingleBlocScreen<CardsBloc> {
  CardsScreen({super.key}) : super(bloc: CardsBloc());
  static String get route => '/cards';

  Widget page(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.only(left: 20, right: 20, top: 20),
          child: BlocBuilder<CardsBloc, CardsState>(
            builder: (context, state) {
              return switch (state) {
                CardsStateInit() => _StartView(
                    onStart: () => context.read<CardsBloc>().add(const CardsEventStartReadyRoom()),
                    imagePath: 'long/event_cards_long.png',
                    color: BsColors.red,
                  ),
                CardsStateLoading() => Center(child: CircularProgressIndicator(color: BsColors.red)),
                CardsStateFailure(:final message) => _FailureView(message: message),
                CardsStateSuccess(:final phase) => switch (phase) {
                    CardsPhaseReadyRoom(:final secondsRemaining) => _ReadyRoomView(
                        secondsRemaining: secondsRemaining,
                        color: BsColors.red,
                        onSkip: () => context.read<CardsBloc>().add(const CardsEventReadyRoomFinished()),
                        title: 'Cards',
                      ),
                    CardsPhasePlaying(:final cardSequence, :final currentIndex, :final recallSecondsElapsed) =>
                      _PlayingView(
                        key: const ValueKey('playing-view'),
                        cardSequence: cardSequence,
                        currentIndex: currentIndex,
                        title: 'Cards',
                        onNext: () => context.read<CardsBloc>().add(const CardsEventNextCard()),
                        onPrevious: () => context.read<CardsBloc>().add(const CardsEventPreviousCard()),
                        onRestart: () => context.read<CardsBloc>().add(const CardsEventRestartSequence()),
                        onSkip: () => context.read<CardsBloc>().add(const CardsEventSkipPlaying()),
                        secondsElapsed: recallSecondsElapsed,
                      ),
                    CardsPhaseFinished(:final totalRecallSeconds) => _FinishedView(
                        onRestart: () =>
                            context.read<CardsBloc>().add(const CardsEventStartReadyRoom()),
                        totalRecallSeconds: totalRecallSeconds,
                      ),
                  },
              };
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget mobile(BuildContext context) => page(context);

  @override
  Widget tablet(BuildContext context) => page(context);

  @override
  Widget desktop(BuildContext context) => page(context);
}

class _StartView extends StatelessWidget {
  const _StartView({required this.onStart, required this.imagePath, required this.color});
  final VoidCallback onStart;
  final String imagePath;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              child: Text(
                'Cards',
                style: GoogleFonts.lato(color: color, fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            Image.asset(imagePath, height: 100),
          ],
        ),
        const SizedBox(height: 24),
        Divider(),
        const SizedBox(height: 36),
        Center(
          child: bsButton(title: 'Start', color: color, onTap: onStart),
        ),
      ],
    );
  }
}

class HighlightBarPhasePlaying extends StatelessWidget {
  const HighlightBarPhasePlaying({
    super.key,
    required this.secondsElapsed,
    required this.onSkip,
    required this.color,
    required this.title,
  });

  final VoidCallback onSkip;
  final int secondsElapsed;
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: BsColors.overlay,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: BsColors.grey, width: 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Text(
              title,
              style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            Spacer(),
            Text(
              'Recall Time: ${secondsElapsed ~/ 60}:${(secondsElapsed % 60).toString().padLeft(2, '0')}',
              style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(width: 20),
            bsButton(title: 'Skip', color: color, onTap: onSkip),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

class HighlightBarRoomView extends StatelessWidget {
  const HighlightBarRoomView({
    super.key,
    required this.secondsRemaining,
    required this.onSkip,
    required this.color,
    required this.title,
  });

  final VoidCallback onSkip;
  final int secondsRemaining;
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: BsColors.overlay,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: BsColors.grey, width: 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Text(
              title,
              style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            Spacer(),
            Text(
              'Memorization Starts in: ${secondsRemaining ~/ 60}:${(secondsRemaining % 60).toString().padLeft(2, '0')}',
              style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(width: 20),
            bsButton(title: 'Skip', color: color, onTap: onSkip),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

class _ReadyRoomView extends StatelessWidget {
  const _ReadyRoomView({
    required this.secondsRemaining,
    required this.color,
    required this.onSkip,
    required this.title,
  });
  final int secondsRemaining;
  final Color color;
  final VoidCallback onSkip;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HighlightBarRoomView(
          secondsRemaining: secondsRemaining,
          onSkip: onSkip,
          color: color,
          title: title,
        ),
      ],
    );
  }
}

/// Displays the current card with next/previous/restart controls.
/// Preloads every SVG in [cardSequence] before rendering the first frame,
/// so switching cards never re-triggers a network/asset decode lag.
class _PlayingView extends StatefulWidget {
  const _PlayingView({
    super.key,
    required this.cardSequence,
    required this.currentIndex,
    required this.title,
    required this.onNext,
    required this.onPrevious,
    required this.onRestart,
    required this.onSkip,
    required this.secondsElapsed,
  });

  final List<int> cardSequence;
  final int currentIndex;
  final String title;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onRestart;
  final VoidCallback onSkip;
  final int secondsElapsed;

  @override
  State<_PlayingView> createState() => _PlayingViewState();
}
class _PlayingViewState extends State<_PlayingView> {
  bool _assetsReady = false;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    // Lasciamo passare due frame con tutte le SvgPicture costruite offstage:
    // questo forza Flutter/flutter_svg a caricare e decodificare ogni SVG
    // e a metterle nella propria cache interna, prima di mostrare la UI reale.
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
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      widget.onNext();
      return true;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      widget.onPrevious();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Offstage(
          offstage: true,
          child: Column(
            children: [
              for (final card in widget.cardSequence)
                SvgPicture.asset('cards/card$card.svg', width: 200, height: 300),
            ],
          ),
        ),
        if (!_assetsReady)
          Center(child: CircularProgressIndicator(color: BsColors.red))
        else
          _buildContent(),
      ],
    );
  }

Widget _buildContent() {
  final card = widget.cardSequence[widget.currentIndex];
  final isFirst = widget.currentIndex == 0;

  return SizedBox.expand(
    child: Column(
      children: [
        HighlightBarPhasePlaying(
          secondsElapsed: widget.secondsElapsed,
          onSkip: widget.onSkip,
          color: BsColors.red,
          title: widget.title,
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Card ${widget.currentIndex + 1} / ${widget.cardSequence.length}',
                  style: GoogleFonts.lato(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  key: ValueKey('card-box-$card'),
                  width: 200,
                  height: 300,
                  child: SvgPicture.asset('cards/card$card.svg', width: 200, height: 300),
                ),
              ],
            ),
          ),
        ),
        _buildOverlappingRow(),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              bsButtonIcon(icon: Icons.restart_alt, color: BsColors.red, onTap: widget.onRestart),
              const SizedBox(width: 12),
              bsButtonIcon(
                icon: Icons.arrow_back,
                color: BsColors.red,
                onTap: isFirst ? () {} : widget.onPrevious,
              ),
              const SizedBox(width: 12),
              bsButtonIcon(icon: Icons.arrow_forward, color: BsColors.red, onTap: widget.onNext),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildOverlappingRow() {
  const double thumbWidth = 80;
  const double thumbHeight = 110;
  const double selectedWidth = 80;
  const double selectedHeight = 110;
  const double overlap = 60; // quanto si sovrappongono le carte
  const double step = thumbWidth - overlap; // avanzamento orizzontale per carta
  const double rowSpacing = 12; // spazio verticale tra le righe

  return LayoutBuilder(
    builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;

      // Quante carte entrano in una riga, dato lo step di overlap.
      // La prima carta occupa thumbWidth, le successive aggiungono `step`.
      int cardsPerRow = ((maxWidth - thumbWidth) / step).floor() + 1;
      if (cardsPerRow < 1) cardsPerRow = 1;

      // Spezza cardSequence in chunk da `cardsPerRow` elementi ciascuno,
      // mantenendo gli indici assoluti per sapere quale card è selezionata.
      final rows = <List<int>>[];
      for (var i = 0; i < widget.cardSequence.length; i += cardsPerRow) {
        final end = (i + cardsPerRow < widget.cardSequence.length)
            ? i + cardsPerRow
            : widget.cardSequence.length;
        rows.add(List.generate(end - i, (j) => i + j));
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final rowIndices in rows) ...[
            _buildSingleOverlappingRow(
              rowIndices: rowIndices,
              thumbWidth: thumbWidth,
              thumbHeight: thumbHeight,
              selectedWidth: selectedWidth,
              selectedHeight: selectedHeight,
              overlap: overlap,
            ),
            if (rowIndices != rows.last) const SizedBox(height: rowSpacing),
          ],
        ],
      );
    },
  );
}

Widget _buildSingleOverlappingRow({
  required List<int> rowIndices,
  required double thumbWidth,
  required double thumbHeight,
  required double selectedWidth,
  required double selectedHeight,
  required double overlap,
}) {
  final step = thumbWidth - overlap;
  final count = rowIndices.length;
  final totalWidth = thumbWidth + (count - 1) * step;

  return SizedBox(
    height: selectedHeight + 10,
    child: Center(
      child: SizedBox(
        width: totalWidth + (selectedWidth - thumbWidth),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: List.generate(count, (posInRow) {
            final index = rowIndices[posInRow];
            final isSelected = index == widget.currentIndex;
            final thumbCard = widget.cardSequence[index];
            final left = posInRow * step;

            return Positioned(
              left: left,
              top: isSelected ? 0 : 5, // rialzo
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 0),
                curve: Curves.easeOut,
                width: isSelected ? selectedWidth : thumbWidth,
                height: isSelected ? selectedHeight : thumbHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? BsColors.red : BsColors.transparent,
                    width: isSelected ? 1 : 1,
                  ),
                  boxShadow: [
                    // BoxShadow(
                    //   color: Colors.black.withValues(alpha: isSelected ? 0.12 : 0.12),
                    //   blurRadius: isSelected ? 3 : 3,
                    //   offset: const Offset(0, 2),
                    // ),
                  ],
                ),
                padding: const EdgeInsets.all(0),
                child: SvgPicture.asset(
                  'cards/card$thumbCard.svg',
                  fit: BoxFit.contain,
                ),
              ),
            );
          }),
        ),
      ),
    ),
  );
}
}

class _FinishedView extends StatelessWidget {
  const _FinishedView({required this.onRestart, required this.totalRecallSeconds});
  final VoidCallback onRestart;
  final int totalRecallSeconds;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Completato!', style: GoogleFonts.lato(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            'Tempo di recall: ${totalRecallSeconds ~/ 60}:${(totalRecallSeconds % 60).toString().padLeft(2, '0')}',
            style: GoogleFonts.lato(fontSize: 18, color: Colors.grey[700]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRestart,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Text('Ricomincia'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}