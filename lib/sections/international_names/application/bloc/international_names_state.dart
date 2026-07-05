sealed class InternationalNamesState {
  const InternationalNamesState();
}

final class InternationalNamesStateInit extends InternationalNamesState {
  const InternationalNamesStateInit();
}

final class InternationalNamesStateLoading extends InternationalNamesState {
  const InternationalNamesStateLoading();
}

final class InternationalNamesStateSuccess extends InternationalNamesState {
  const InternationalNamesStateSuccess();
}

final class InternationalNamesStateFailure extends InternationalNamesState {
  const InternationalNamesStateFailure({required this.message});
  final String message;
}
