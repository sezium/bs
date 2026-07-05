import 'dart:async';
import 'package:bs/sections/numbers/application/bloc/numbers_event.dart';
import 'package:bs/sections/numbers/application/bloc/numbers_state.dart';
import 'package:bs/sections/numbers/dependency/numbers_dependencies_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const int _readyRoomDuration = 3;

/// Quanti numeri a due cifre compongono la sequenza/il mazzo: 00..99.
const int _numberCount = 100;

final class NumbersBloc extends Bloc<NumbersEvent, NumbersState> with NumbersDependenciesMixin {
  Timer? _countdownTimer;
  Timer? _recallTimer;

  NumbersBloc() : super(const NumbersStateInit()) {
    on<NumbersEventInit>(_onInit);
    on<NumbersEventStartReadyRoom>(_onStartReadyRoom);
    on<NumbersEventTick>(_onTick);
    on<NumbersEventReadyRoomFinished>(_onReadyRoomFinished);
    on<NumbersEventNextNumber>(_onNextNumber);
    on<NumbersEventPreviousNumber>(_onPreviousNumber);
    on<NumbersEventRestartSequence>(_onRestartSequence);
    on<NumbersEventRecallTick>(_onRecallTick);
    on<NumbersEventSkipPlaying>(_onSkipPlaying);
    on<NumbersEventPlaceNumber>(_onPlaceNumber);
    on<NumbersEventReturnNumberToDeck>(_onReturnNumberToDeck);
    on<NumbersEventConfirmRecall>(_onConfirmRecall);
    on<NumbersEventFinishRecall>(_onFinishRecall);
  }

  void _onInit(NumbersEventInit event, Emitter<NumbersState> emit) {
    emit(const NumbersStateInit());
  }

  void _onStartReadyRoom(NumbersEventStartReadyRoom event, Emitter<NumbersState> emit) {
    emit(const NumbersStateSuccess(phase: NumbersPhaseReadyRoom(secondsRemaining: _readyRoomDuration)));

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(const NumbersEventTick());
    });
  }

  void _onTick(NumbersEventTick event, Emitter<NumbersState> emit) {
    final current = state;
    if (current is! NumbersStateSuccess || current.phase is! NumbersPhaseReadyRoom) return;

    final phase = current.phase as NumbersPhaseReadyRoom;
    final remaining = phase.secondsRemaining - 1;

    if (remaining <= 0) {
      _countdownTimer?.cancel();
      add(const NumbersEventReadyRoomFinished());
    } else {
      emit(NumbersStateSuccess(phase: NumbersPhaseReadyRoom(secondsRemaining: remaining)));
    }
  }

  void _onReadyRoomFinished(NumbersEventReadyRoomFinished event, Emitter<NumbersState> emit) {
    final sequence = List.generate(_numberCount, (i) => i)..shuffle();

    emit(NumbersStateSuccess(
      phase: NumbersPhasePlaying(numberSequence: sequence, currentIndex: 0, recallSecondsElapsed: 0),
    ));

    _recallTimer?.cancel();
    _recallTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(const NumbersEventRecallTick());
    });
  }

  void _onRecallTick(NumbersEventRecallTick event, Emitter<NumbersState> emit) {
    final current = state;
    if (current is! NumbersStateSuccess) return;
    final phase = current.phase;

    if (phase is NumbersPhasePlaying) {
      emit(NumbersStateSuccess(
        phase: NumbersPhasePlaying(
          numberSequence: phase.numberSequence,
          currentIndex: phase.currentIndex,
          recallSecondsElapsed: phase.recallSecondsElapsed + 1,
        ),
      ));
    } else if (phase is NumbersPhaseRecall && !phase.submitted) {
      emit(NumbersStateSuccess(
        phase: NumbersPhaseRecall(
          originalSequence: phase.originalSequence,
          deck: phase.deck,
          placedSlots: phase.placedSlots,
          recallSecondsElapsed: phase.recallSecondsElapsed + 1,
          submitted: false,
        ),
      ));
    } else {
      _recallTimer?.cancel();
    }
  }

  void _onNextNumber(NumbersEventNextNumber event, Emitter<NumbersState> emit) {
    final current = state;
    if (current is! NumbersStateSuccess || current.phase is! NumbersPhasePlaying) return;

    final phase = current.phase as NumbersPhasePlaying;
    final nextIndex = phase.currentIndex + 1;

    if (nextIndex >= phase.numberSequence.length) {
      _emitRecallPhase(
        emit,
        originalSequence: phase.numberSequence,
        recallSecondsElapsed: phase.recallSecondsElapsed,
      );
    } else {
      emit(NumbersStateSuccess(
        phase: NumbersPhasePlaying(
          numberSequence: phase.numberSequence,
          currentIndex: nextIndex,
          recallSecondsElapsed: phase.recallSecondsElapsed,
        ),
      ));
    }
  }

  void _onPreviousNumber(NumbersEventPreviousNumber event, Emitter<NumbersState> emit) {
    final current = state;
    if (current is! NumbersStateSuccess || current.phase is! NumbersPhasePlaying) return;

    final phase = current.phase as NumbersPhasePlaying;
    if (phase.currentIndex == 0) return;

    emit(NumbersStateSuccess(
      phase: NumbersPhasePlaying(
        numberSequence: phase.numberSequence,
        currentIndex: phase.currentIndex - 1,
        recallSecondsElapsed: phase.recallSecondsElapsed,
      ),
    ));
  }

  void _onRestartSequence(NumbersEventRestartSequence event, Emitter<NumbersState> emit) {
    final current = state;
    if (current is! NumbersStateSuccess || current.phase is! NumbersPhasePlaying) return;

    final phase = current.phase as NumbersPhasePlaying;
    emit(NumbersStateSuccess(
      phase: NumbersPhasePlaying(
        numberSequence: phase.numberSequence,
        currentIndex: 0,
        recallSecondsElapsed: phase.recallSecondsElapsed,
      ),
    ));
  }

  void _onSkipPlaying(NumbersEventSkipPlaying event, Emitter<NumbersState> emit) {
    final current = state;
    if (current is! NumbersStateSuccess || current.phase is! NumbersPhasePlaying) return;

    final phase = current.phase as NumbersPhasePlaying;

    _emitRecallPhase(
      emit,
      originalSequence: phase.numberSequence,
      recallSecondsElapsed: 0,
    );
  }

  void _emitRecallPhase(
    Emitter<NumbersState> emit, {
    required List<int> originalSequence,
    required int recallSecondsElapsed,
  }) {
    emit(NumbersStateSuccess(
      phase: NumbersPhaseRecall(
        originalSequence: originalSequence,
        deck: List.generate(_numberCount, (i) => i),
        placedSlots: List<int?>.filled(_numberCount, null),
        recallSecondsElapsed: recallSecondsElapsed,
        submitted: false,
      ),
    ));
  }

  void _onPlaceNumber(NumbersEventPlaceNumber event, Emitter<NumbersState> emit) {
    final current = state;
    if (current is! NumbersStateSuccess || current.phase is! NumbersPhaseRecall) return;
    final phase = current.phase as NumbersPhaseRecall;
    if (phase.submitted) return;
    if (phase.placedSlots[event.slotIndex] != null) return;
    if (!phase.deck.contains(event.number)) return;

    final newDeck = List<int>.from(phase.deck)..remove(event.number);
    final newSlots = List<int?>.from(phase.placedSlots);
    newSlots[event.slotIndex] = event.number;

    emit(NumbersStateSuccess(
      phase: NumbersPhaseRecall(
        originalSequence: phase.originalSequence,
        deck: newDeck,
        placedSlots: newSlots,
        recallSecondsElapsed: phase.recallSecondsElapsed,
        submitted: false,
      ),
    ));
  }

  void _onReturnNumberToDeck(NumbersEventReturnNumberToDeck event, Emitter<NumbersState> emit) {
    final current = state;
    if (current is! NumbersStateSuccess || current.phase is! NumbersPhaseRecall) return;
    final phase = current.phase as NumbersPhaseRecall;
    if (phase.submitted) return;

    final number = phase.placedSlots[event.slotIndex];
    if (number == null) return;

    final newSlots = List<int?>.from(phase.placedSlots);
    newSlots[event.slotIndex] = null;
    final newDeck = List<int>.from(phase.deck)
      ..add(number)
      ..sort();

    emit(NumbersStateSuccess(
      phase: NumbersPhaseRecall(
        originalSequence: phase.originalSequence,
        deck: newDeck,
        placedSlots: newSlots,
        recallSecondsElapsed: phase.recallSecondsElapsed,
        submitted: false,
      ),
    ));
  }

  void _onConfirmRecall(NumbersEventConfirmRecall event, Emitter<NumbersState> emit) {
    final current = state;
    if (current is! NumbersStateSuccess || current.phase is! NumbersPhaseRecall) return;
    final phase = current.phase as NumbersPhaseRecall;

    _recallTimer?.cancel();

    emit(NumbersStateSuccess(
      phase: NumbersPhaseRecall(
        originalSequence: phase.originalSequence,
        deck: phase.deck,
        placedSlots: phase.placedSlots,
        recallSecondsElapsed: phase.recallSecondsElapsed,
        submitted: true,
      ),
    ));
  }

  void _onFinishRecall(NumbersEventFinishRecall event, Emitter<NumbersState> emit) {
    final current = state;
    if (current is! NumbersStateSuccess || current.phase is! NumbersPhaseRecall) return;
    final phase = current.phase as NumbersPhaseRecall;
    if (!phase.submitted) return;

    emit(NumbersStateSuccess(
      phase: NumbersPhaseFinished(totalRecallSeconds: phase.recallSecondsElapsed),
    ));
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    _recallTimer?.cancel();
    return super.close();
  }
}