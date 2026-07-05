sealed class CardsState {
  const CardsState();
}

final class CardsStateInit extends CardsState {
  const CardsStateInit();
}

final class CardsStateLoading extends CardsState {
  const CardsStateLoading();
}

final class CardsStateSuccess extends CardsState {
  const CardsStateSuccess({required this.phase});
  final CardsPhase phase;
}

final class CardsStateFailure extends CardsState {
  const CardsStateFailure({required this.message});
  final String message;
}

sealed class CardsPhase {
  const CardsPhase();
}

final class CardsPhaseReadyRoom extends CardsPhase {
  const CardsPhaseReadyRoom({required this.secondsRemaining});
  final int secondsRemaining;
}

final class CardsPhasePlaying extends CardsPhase {
  const CardsPhasePlaying({
    required this.cardSequence,
    required this.currentIndex,
    required this.recallSecondsElapsed,
  });
  final List<int> cardSequence;
  final int currentIndex;
  final int recallSecondsElapsed;
}

final class CardsPhaseFinished extends CardsPhase {
  const CardsPhaseFinished({required this.totalRecallSeconds});
  final int totalRecallSeconds;
}

final class CardsPhaseRecall extends CardsPhase {
  const CardsPhaseRecall({
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
}