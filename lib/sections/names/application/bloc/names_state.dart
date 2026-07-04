sealed class NamesState {
  const NamesState();
}

final class NamesStateInit extends NamesState {
  const NamesStateInit();
}

final class NamesStateLoading extends NamesState {
  const NamesStateLoading();
}

final class NamesStateSuccess extends NamesState {
  const NamesStateSuccess();
}

final class NamesStateFailure extends NamesState {
  const NamesStateFailure({required this.message});
  final String message;
}
