sealed class NumbersState {
  const NumbersState();
}

final class NumbersStateInit extends NumbersState {
  const NumbersStateInit();
}

final class NumbersStateLoading extends NumbersState {
  const NumbersStateLoading();
}

final class NumbersStateSuccess extends NumbersState {
  const NumbersStateSuccess({required this.phase});
  final NumbersPhase phase;
}

final class NumbersStateFailure extends NumbersState {
  const NumbersStateFailure({required this.message});
  final String message;
}

sealed class NumbersPhase {
  const NumbersPhase();
}

final class NumbersPhaseReadyRoom extends NumbersPhase {
  const NumbersPhaseReadyRoom({required this.secondsRemaining});
  final int secondsRemaining;
}

final class NumbersPhasePlaying extends NumbersPhase {
  const NumbersPhasePlaying({
    required this.numberSequence,
    required this.currentIndex,
    required this.recallSecondsElapsed,
  });
  final List<int> numberSequence;
  final int currentIndex;
  final int recallSecondsElapsed;
}

final class NumbersPhaseFinished extends NumbersPhase {
  const NumbersPhaseFinished({required this.totalRecallSeconds});
  final int totalRecallSeconds;
}

final class NumbersPhaseRecall extends NumbersPhase {
  const NumbersPhaseRecall({
    required this.originalSequence,
    required this.placedSlots,
    required this.recallSecondsElapsed,
    required this.submitted,
  });
  final List<int> originalSequence;
  final List<int?> placedSlots;
  final int recallSecondsElapsed;
  final bool submitted;
}