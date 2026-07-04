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
  const NumbersStateSuccess();
}

final class NumbersStateFailure extends NumbersState {
  const NumbersStateFailure({required this.message});
  final String message;
}
