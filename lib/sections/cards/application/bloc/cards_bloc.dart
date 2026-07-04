import 'dart:async';
import 'package:bs/sections/cards/application/bloc/cards_event.dart';
import 'package:bs/sections/cards/application/bloc/cards_state.dart';
import 'package:bs/sections/cards/dependency/cards_dependencies_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const int _readyRoomDuration = 3;

final class CardsBloc extends Bloc<CardsEvent, CardsState> with CardsDependenciesMixin {
  Timer? _countdownTimer;
  Timer? _recallTimer;

  CardsBloc() : super(const CardsStateInit()) {
    on<CardsEventInit>(_onInit);
    on<CardsEventStartReadyRoom>(_onStartReadyRoom);
    on<CardsEventTick>(_onTick);
    on<CardsEventReadyRoomFinished>(_onReadyRoomFinished);
    on<CardsEventNextCard>(_onNextCard);
    on<CardsEventPreviousCard>(_onPreviousCard);
    on<CardsEventRestartSequence>(_onRestartSequence);
    on<CardsEventRecallTick>(_onRecallTick);
    on<CardsEventSkipPlaying>(_onSkipPlaying);
  }

  void _onInit(CardsEventInit event, Emitter<CardsState> emit) {
    emit(const CardsStateInit());
  }

  void _onStartReadyRoom(CardsEventStartReadyRoom event, Emitter<CardsState> emit) {
    emit(const CardsStateSuccess(
      phase: CardsPhaseReadyRoom(secondsRemaining: _readyRoomDuration),
    ));

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(const CardsEventTick());
    });
  }

  void _onTick(CardsEventTick event, Emitter<CardsState> emit) {
    final current = state;
    if (current is! CardsStateSuccess || current.phase is! CardsPhaseReadyRoom) return;

    final phase = current.phase as CardsPhaseReadyRoom;
    final remaining = phase.secondsRemaining - 1;

    if (remaining <= 0) {
      _countdownTimer?.cancel();
      add(const CardsEventReadyRoomFinished());
    } else {
      emit(CardsStateSuccess(
        phase: CardsPhaseReadyRoom(secondsRemaining: remaining),
      ));
    }
  }

  void _onReadyRoomFinished(CardsEventReadyRoomFinished event, Emitter<CardsState> emit) {
    final sequence = List.generate(52, (i) => i)..shuffle();

    emit(CardsStateSuccess(
      phase: CardsPhasePlaying(
        cardSequence: sequence,
        currentIndex: 0,
        recallSecondsElapsed: 0,
      ),
    ));

    _recallTimer?.cancel();
    _recallTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(const CardsEventRecallTick());
    });
  }

  void _onRecallTick(CardsEventRecallTick event, Emitter<CardsState> emit) {
    final current = state;
    if (current is! CardsStateSuccess || current.phase is! CardsPhasePlaying) return;

    final phase = current.phase as CardsPhasePlaying;
    emit(CardsStateSuccess(
      phase: CardsPhasePlaying(
        cardSequence: phase.cardSequence,
        currentIndex: phase.currentIndex,
        recallSecondsElapsed: phase.recallSecondsElapsed + 1,
      ),
    ));
  }

  void _onNextCard(CardsEventNextCard event, Emitter<CardsState> emit) {
    final current = state;
    if (current is! CardsStateSuccess || current.phase is! CardsPhasePlaying) return;

    final phase = current.phase as CardsPhasePlaying;
    final nextIndex = phase.currentIndex + 1;

    if (nextIndex >= phase.cardSequence.length) {
      _recallTimer?.cancel();
      emit(CardsStateSuccess(
        phase: CardsPhaseFinished(totalRecallSeconds: phase.recallSecondsElapsed),
      ));
    } else {
      emit(CardsStateSuccess(
        phase: CardsPhasePlaying(
          cardSequence: phase.cardSequence,
          currentIndex: nextIndex,
          recallSecondsElapsed: phase.recallSecondsElapsed,
        ),
      ));
    }
  }

  void _onPreviousCard(CardsEventPreviousCard event, Emitter<CardsState> emit) {
    final current = state;
    if (current is! CardsStateSuccess || current.phase is! CardsPhasePlaying) return;

    final phase = current.phase as CardsPhasePlaying;
    if (phase.currentIndex == 0) return;

    emit(CardsStateSuccess(
      phase: CardsPhasePlaying(
        cardSequence: phase.cardSequence,
        currentIndex: phase.currentIndex - 1,
        recallSecondsElapsed: phase.recallSecondsElapsed,
      ),
    ));
  }

  void _onRestartSequence(CardsEventRestartSequence event, Emitter<CardsState> emit) {
    final current = state;
    if (current is! CardsStateSuccess || current.phase is! CardsPhasePlaying) return;

    final phase = current.phase as CardsPhasePlaying;
    emit(CardsStateSuccess(
      phase: CardsPhasePlaying(
        cardSequence: phase.cardSequence,
        currentIndex: 0,
        recallSecondsElapsed: phase.recallSecondsElapsed,
      ),
    ));
  }

  void _onSkipPlaying(CardsEventSkipPlaying event, Emitter<CardsState> emit) {
    final current = state;
    if (current is! CardsStateSuccess || current.phase is! CardsPhasePlaying) return;

    final phase = current.phase as CardsPhasePlaying;
    _recallTimer?.cancel();
    emit(CardsStateSuccess(
      phase: CardsPhaseFinished(totalRecallSeconds: phase.recallSecondsElapsed),
    ));
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    _recallTimer?.cancel();
    return super.close();
  }
}