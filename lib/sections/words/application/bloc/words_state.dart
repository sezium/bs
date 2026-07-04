sealed class WordsState {
  const WordsState();
}

final class WordsStateInit extends WordsState {
  const WordsStateInit();
}

final class WordsStateLoading extends WordsState {
  const WordsStateLoading();
}

final class WordsStateSuccess extends WordsState {
  const WordsStateSuccess();
}

final class WordsStateFailure extends WordsState {
  const WordsStateFailure({required this.message});
  final String message;
}
