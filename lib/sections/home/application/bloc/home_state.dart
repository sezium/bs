sealed class HomeState {
  const HomeState();
}

final class HomeStateInit extends HomeState {
  const HomeStateInit();
}

final class HomeStateLoading extends HomeState {
  const HomeStateLoading();
}

final class HomeStateSuccess extends HomeState {
  const HomeStateSuccess();
}

final class HomeStateFailure extends HomeState {
  const HomeStateFailure({required this.message});
  final String message;
}
