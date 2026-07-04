sealed class TrainingState {
  const TrainingState();
}

final class TrainingStateInit extends TrainingState {
  const TrainingStateInit();
}

final class TrainingStateLoading extends TrainingState {
  const TrainingStateLoading();
}

final class TrainingStateSuccess extends TrainingState {
  const TrainingStateSuccess();
}

final class TrainingStateFailure extends TrainingState {
  const TrainingStateFailure({required this.message});
  final String message;
}
