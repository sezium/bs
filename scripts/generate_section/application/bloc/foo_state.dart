sealed class $Foo$State {
  const $Foo$State();
}

final class $Foo$StateInit extends $Foo$State {
  const $Foo$StateInit();
}

final class $Foo$StateLoading extends $Foo$State {
  const $Foo$StateLoading();
}

final class $Foo$StateSuccess extends $Foo$State {
  const $Foo$StateSuccess();
}

final class $Foo$StateFailure extends $Foo$State {
  const $Foo$StateFailure({required this.message});
  final String message;
}
