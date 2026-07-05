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
              child: BlocBuilder<NumbersBloc, NumbersState>(builder: _buildState),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildState(BuildContext context, NumbersState state) {
    return switch (state) {
      NumbersStateInit() => TrainingStartView(
          title: 'Numbers',
          imagePath: 'long/event_numbers_long.png',
          color: BsColors.blue,
          onStart: () => context.read<NumbersBloc>().add(const NumbersEventStartReadyRoom()),
        ),
      NumbersStateLoading() => Center(child: CircularProgressIndicator(color: BsColors.blue)),
      NumbersStateFailure(:final message) => TrainingFailureView(message: message),
      NumbersStateSuccess(:final phase) => _buildPhase(context, phase),
    };
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
        :final deck,
        :final placedSlots,
        :final recallSecondsElapsed,
        :final submitted,
      ) =>
        NumbersRecallView(
          originalSequence: originalSequence,
          deck: deck,
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