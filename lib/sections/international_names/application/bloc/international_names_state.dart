sealed class International_namesState {
  const International_namesState();
}

final class International_namesStateInit extends International_namesState {
  const International_namesStateInit();
}

final class International_namesStateLoading extends International_namesState {
  const International_namesStateLoading();
}

final class International_namesStateSuccess extends International_namesState {
  const International_namesStateSuccess();
}

final class International_namesStateFailure extends International_namesState {
  const International_namesStateFailure({required this.message});
  final String message;
}
