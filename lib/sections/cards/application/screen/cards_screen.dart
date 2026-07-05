import 'package:bs/base/application/screen/base_screen.dart';
import 'package:bs/core/widgets/colors.dart';
import 'package:bs/core/widgets/training/training_failure_view.dart';
import 'package:bs/core/widgets/training/training_finished_view.dart';
import 'package:bs/core/widgets/training/training_ready_room.dart';
import 'package:bs/core/widgets/training/training_start_view.dart';
import 'package:bs/sections/cards/application/bloc/cards_bloc.dart';
import 'package:bs/sections/cards/application/bloc/cards_event.dart';
import 'package:bs/sections/cards/application/bloc/cards_state.dart';
import 'package:bs/sections/cards/application/screen/cards_playing_view.dart';
import 'package:bs/sections/cards/application/screen/cards_recall_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardsScreen extends SingleBlocScreen<CardsBloc> {
  CardsScreen({super.key}) : super(bloc: CardsBloc());
  static String get route => '/cards';

  Widget page(BuildContext context) {
    return Scaffold(
      backgroundColor: BsColors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: BlocBuilder<CardsBloc, CardsState>(builder: _buildState),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildState(BuildContext context, CardsState state) {
    return switch (state) {
      CardsStateInit() => TrainingStartView(
          title: 'Cards',
          imagePath: 'long/event_cards_long.png',
          color: BsColors.red,
          onStart: () => context.read<CardsBloc>().add(const CardsEventStartReadyRoom()),
        ),
      CardsStateLoading() => Center(child: CircularProgressIndicator(color: BsColors.red)),
      CardsStateFailure(:final message) => TrainingFailureView(message: message),
      CardsStateSuccess(:final phase) => _buildPhase(context, phase),
    };
  }

  Widget _buildPhase(BuildContext context, CardsPhase phase) {
    return switch (phase) {
      CardsPhaseReadyRoom(:final secondsRemaining) => TrainingReadyRoomView(
          title: 'Cards',
          color: BsColors.red,
          secondsRemaining: secondsRemaining,
          onSkip: () => context.read<CardsBloc>().add(const CardsEventReadyRoomFinished()),
        ),
      CardsPhasePlaying(:final cardSequence, :final currentIndex, :final recallSecondsElapsed) => CardsPlayingView(
          key: const ValueKey('playing-view'),
          cardSequence: cardSequence,
          currentIndex: currentIndex,
          secondsElapsed: recallSecondsElapsed,
        ),
      CardsPhaseRecall(
        :final originalSequence,
        :final deck,
        :final placedSlots,
        :final recallSecondsElapsed,
        :final submitted,
      ) =>
        CardsRecallView(
          originalSequence: originalSequence,
          deck: deck,
          placedSlots: placedSlots,
          recallSecondsElapsed: recallSecondsElapsed,
          submitted: submitted,
        ),
      CardsPhaseFinished(:final totalRecallSeconds) => TrainingFinishedView(
          totalRecallSeconds: totalRecallSeconds,
          onRestart: () => context.read<CardsBloc>().add(const CardsEventStartReadyRoom()),
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