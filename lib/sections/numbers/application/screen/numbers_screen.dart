import 'package:bs/base/application/screen/base_screen.dart';
import 'package:bs/core/widgets/colors.dart';
import 'package:bs/core/widgets/training/training_failure_view.dart';
import 'package:bs/core/widgets/training/training_finished_view.dart';
import 'package:bs/core/widgets/training/training_ready_room.dart';
import 'package:bs/core/widgets/training/training_start_view.dart';
import 'package:bs/sections/numbers/application/bloc/numbers_bloc.dart';
import 'package:bs/sections/numbers/application/bloc/numbers_event.dart';
import 'package:bs/sections/numbers/application/bloc/numbers_state.dart';
import 'package:bs/sections/numbers/application/screen/numbers_playing_view.dart';
import 'package:bs/sections/numbers/application/screen/numbers_recall_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumbersScreen extends SingleBlocScreen<NumbersBloc> {
  NumbersScreen({super.key}) : super(bloc: NumbersBloc());
  static String get route => '/numbers';

  Widget page(BuildContext context) {
    return Scaffold(
      backgroundColor: BsColors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              // buildWhen: evita di ricostruire l'intero albero (100 TextField
              // nella recall) ad ogni tick del timer; rebuilda solo quando
              // cambia la "forma" dello stato (fase diversa, dati diversi da
              // quelli temporali). I singoli sotto-widget (timer, griglia)
              // isolano ulteriormente i rebuild al loro interno.
              child: BlocBuilder<NumbersBloc, NumbersState>(
                buildWhen: _shouldRebuildScreen,
                builder: _buildState,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _shouldRebuildScreen(NumbersState previous, NumbersState current) {
    // Cambio di stato/fase "strutturale": sempre rebuild.
    if (previous.runtimeType != current.runtimeType) return true;

    if (previous is NumbersStateSuccess && current is NumbersStateSuccess) {
      final prevPhase = previous.phase;
      final currPhase = current.phase;
      if (prevPhase.runtimeType != currPhase.runtimeType) return true;

      // ReadyRoom: il countdown va mostrato, quindi qui il rebuild è ok
      // (è una vista leggera, nessun TextField).
      if (currPhase is NumbersPhaseReadyRoom) return true;

      // Playing: currentIndex/recallSecondsElapsed cambiano spesso ma la
      // vista non ha TextField pesanti, quindi rebuild pure qui.
      if (currPhase is NumbersPhasePlaying) return true;

      // Recall: qui evitiamo il rebuild "globale" per i soli tick del
      // timer. NumbersRecallView riceve comunque il valore aggiornato di
      // recallSecondsElapsed tramite un BlocBuilder interno isolato,
      // quindi non serve ricostruire l'intera vista per quello.
      if (currPhase is NumbersPhaseRecall && prevPhase is NumbersPhaseRecall) {
        final samePlacedSlots = _listEquals(prevPhase.placedSlots, currPhase.placedSlots);
        final sameSubmitted = prevPhase.submitted == currPhase.submitted;
        final sameSeconds = prevPhase.recallSecondsElapsed == currPhase.recallSecondsElapsed;
        // Se cambia solo il tempo, non serve un rebuild qui: lo gestisce
        // NumbersRecallView internamente.
        if (samePlacedSlots && sameSubmitted && !sameSeconds) return false;
        return !(samePlacedSlots && sameSubmitted && sameSeconds);
      }

      if (currPhase is NumbersPhaseFinished) return true;
    }

    return true;
  }

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Widget _buildState(BuildContext context, NumbersState state) {
    return switch (state) {
      NumbersStateInit() => _buildInitView(context),
      NumbersStateLoading() => Center(child: CircularProgressIndicator(color: BsColors.blue)),
      NumbersStateFailure(:final message) => TrainingFailureView(message: message),
      NumbersStateSuccess(:final phase) => _buildPhase(context, phase),
    };
  }

  Widget _buildInitView(BuildContext context) {
    final controller = TextEditingController(text: '100');

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        TrainingStartView(
          title: 'Numbers',
          imagePath: 'long/event_numbers_long.png',
          color: BsColors.blue,
          onStart: () {
            final count = int.tryParse(controller.text) ?? 100;
            context.read<NumbersBloc>().add(NumbersEventStartReadyRoom(numberCount: count));
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 100,
          child: TextField(
            controller: controller,
            cursorColor: BsColors.black,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: BsColors.grey, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: BsColors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: BsColors.grey, width: 1),
              ),
            ),
       
          ),
        ),
        
      ],
    );
  }

  Widget _buildPhase(BuildContext context, NumbersPhase phase) {
    return switch (phase) {
      NumbersPhaseReadyRoom(:final secondsRemaining) => TrainingReadyRoomView(
          title: 'Numbers',
          color: BsColors.blue,
          secondsRemaining: secondsRemaining,
          onSkip: () => context.read<NumbersBloc>().add(const NumbersEventReadyRoomFinished()),
        ),
      NumbersPhasePlaying(:final numberSequence, :final currentIndex, :final recallSecondsElapsed) =>
        NumbersPlayingView(
          key: const ValueKey('playing-view'),
          numberSequence: numberSequence,
          currentIndex: currentIndex,
          secondsElapsed: recallSecondsElapsed,
        ),
      NumbersPhaseRecall(
        :final originalSequence,
        :final placedSlots,
        :final recallSecondsElapsed,
        :final submitted,
      ) =>
        NumbersRecallView(
          // Key stabile: fondamentale perché Flutter riusi lo State (e quindi
          // i TextEditingController/FocusNode) tra un rebuild e l'altro
          // invece di ricrearli, cosa che causerebbe perdita di focus e
          // ritardi percepiti nell'interazione.
          key: const ValueKey('recall-view'),
          originalSequence: originalSequence,
          placedSlots: placedSlots,
          recallSecondsElapsed: recallSecondsElapsed,
          submitted: submitted,
        ),
      NumbersPhaseFinished(:final totalRecallSeconds) => TrainingFinishedView(
          totalRecallSeconds: totalRecallSeconds,
          onRestart: () => context.read<NumbersBloc>().add(const NumbersEventStartReadyRoom()),
        ),
    };
  }

  @override
  Widget mobile(BuildContext context) => page(context);

  @override
  Widget tablet(BuildContext context) => page(context);

  @override
  Widget desktop(BuildContext context) => page(context);
}