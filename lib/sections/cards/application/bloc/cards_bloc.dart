import 'dart:async';
import 'package:bs/sections/cards/application/bloc/cards_event.dart';
import 'package:bs/sections/cards/application/bloc/cards_state.dart';
import 'package:bs/sections/cards/dependency/cards_dependencies_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const int _readyRoomDuration = 3;
const int _deckSize = 52;

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
    on<CardsEventPlaceCard>(_onPlaceCard);
    on<CardsEventReturnCardToDeck>(_onReturnCardToDeck);
    on<CardsEventConfirmRecall>(_onConfirmRecall);
    on<CardsEventFinishRecall>(_onFinishRecall);
  }

  void _onInit(CardsEventInit event, Emitter<CardsState> emit) {
    emit(const CardsStateInit());
  }

  void _onStartReadyRoom(CardsEventStartReadyRoom event, Emitter<CardsState> emit) {
    emit(const CardsStateSuccess(phase: CardsPhaseReadyRoom(secondsRemaining: _readyRoomDuration)));

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
      emit(CardsStateSuccess(phase: CardsPhaseReadyRoom(secondsRemaining: remaining)));
    }
  }

  void _onReadyRoomFinished(CardsEventReadyRoomFinished event, Emitter<CardsState> emit) {
    final sequence = List.generate(_deckSize, (i) => i)..shuffle();

    emit(CardsStateSuccess(
      phase: CardsPhasePlaying(cardSequence: sequence, currentIndex: 0, recallSecondsElapsed: 0),
    ));

    _recallTimer?.cancel();
    _recallTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(const CardsEventRecallTick());
    });
  }

  void _onRecallTick(CardsEventRecallTick event, Emitter<CardsState> emit) {
    final current = state;
    if (current is! CardsStateSuccess) return;
    final phase = current.phase;

    if (phase is CardsPhasePlaying) {
      emit(CardsStateSuccess(
        phase: CardsPhasePlaying(
          cardSequence: phase.cardSequence,
          currentIndex: phase.currentIndex,
          recallSecondsElapsed: phase.recallSecondsElapsed + 1,
        ),
      ));
    } else if (phase is CardsPhaseRecall && !phase.submitted) {
      emit(CardsStateSuccess(
        phase: CardsPhaseRecall(
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

  void _onNextCard(CardsEventNextCard event, Emitter<CardsState> emit) {
    final current = state;
    if (current is! CardsStateSuccess || current.phase is! CardsPhasePlaying) return;

    final phase = current.phase as CardsPhasePlaying;
    final nextIndex = phase.currentIndex + 1;

    if (nextIndex >= phase.cardSequence.length) {
      _emitRecallPhase(
        emit,
        originalSequence: phase.cardSequence,
        recallSecondsElapsed: phase.recallSecondsElapsed,
      );
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
    _emitRecallPhase(
      emit,
      originalSequence: phase.cardSequence,
      recallSecondsElapsed: phase.recallSecondsElapsed,
    );
  }

  /// Fabbrica comune per entrare in `CardsPhaseRecall` con mazzo pieno e
  /// slot vuoti. Prima questa emissione era duplicata identica in
  /// `_onNextCard` e `_onSkipPlaying`.
  void _emitRecallPhase(
    Emitter<CardsState> emit, {
    required List<int> originalSequence,
    required int recallSecondsElapsed,
  }) {
    emit(CardsStateSuccess(
      phase: CardsPhaseRecall(
        originalSequence: originalSequence,
        deck: List.generate(_deckSize, (i) => i),
        placedSlots: List<int?>.filled(_deckSize, null),
        recallSecondsElapsed: recallSecondsElapsed,
        submitted: false,
      ),
    ));
  }

  void _onPlaceCard(CardsEventPlaceCard event, Emitter<CardsState> emit) {
    final current = state;
    if (current is! CardsStateSuccess || current.phase is! CardsPhaseRecall) return;
    final phase = current.phase as CardsPhaseRecall;
    if (phase.submitted) return;
    if (phase.placedSlots[event.slotIndex] != null) return;
    if (!phase.deck.contains(event.card)) return;

    final newDeck = List<int>.from(phase.deck)..remove(event.card);
    final newSlots = List<int?>.from(phase.placedSlots);
    newSlots[event.slotIndex] = event.card;

    emit(CardsStateSuccess(
      phase: CardsPhaseRecall(
        originalSequence: phase.originalSequence,
        deck: newDeck,
        placedSlots: newSlots,
        recallSecondsElapsed: phase.recallSecondsElapsed,
        submitted: false,
      ),
    ));
  }

  void _onReturnCardToDeck(CardsEventReturnCardToDeck event, Emitter<CardsState> emit) {
    final current = state;
    if (current is! CardsStateSuccess || current.phase is! CardsPhaseRecall) return;
    final phase = current.phase as CardsPhaseRecall;
    if (phase.submitted) return;

    final card = phase.placedSlots[event.slotIndex];
    if (card == null) return;

    final newSlots = List<int?>.from(phase.placedSlots);
    newSlots[event.slotIndex] = null;
    final newDeck = List<int>.from(phase.deck)
      ..add(card)
      ..sort();

    emit(CardsStateSuccess(
      phase: CardsPhaseRecall(
        originalSequence: phase.originalSequence,
        deck: newDeck,
        placedSlots: newSlots,
        recallSecondsElapsed: phase.recallSecondsElapsed,
        submitted: false,
      ),
    ));
  }

  void _onConfirmRecall(CardsEventConfirmRecall event, Emitter<CardsState> emit) {
    final current = state;
    if (current is! CardsStateSuccess || current.phase is! CardsPhaseRecall) return;
    final phase = current.phase as CardsPhaseRecall;

    _recallTimer?.cancel();

    emit(CardsStateSuccess(
      phase: CardsPhaseRecall(
        originalSequence: phase.originalSequence,
        deck: phase.deck,
        placedSlots: phase.placedSlots,
        recallSecondsElapsed: phase.recallSecondsElapsed,
        submitted: true,
      ),
    ));
  }

  /// Fix: prima non esisteva alcun handler che portasse a
  /// `CardsPhaseFinished`. La UI chiamava `context.pop()` invece di
  /// concludere la sessione mostrando il tempo totale di recall.
  void _onFinishRecall(CardsEventFinishRecall event, Emitter<CardsState> emit) {
    final current = state;
    if (current is! CardsStateSuccess || current.phase is! CardsPhaseRecall) return;
    final phase = current.phase as CardsPhaseRecall;
    if (!phase.submitted) return;

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