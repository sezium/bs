sealed class ImagesState {
  const ImagesState();
}

final class ImagesStateInit extends ImagesState {
  const ImagesStateInit();
}

final class ImagesStateLoading extends ImagesState {
  const ImagesStateLoading();
}

final class ImagesStateSuccess extends ImagesState {
  const ImagesStateSuccess();
}

final class ImagesStateFailure extends ImagesState {
  const ImagesStateFailure({required this.message});
  final String message;
}
