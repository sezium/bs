sealed class LoginState {
  const LoginState();

  bool get isLoading => this is LoginStateLoading;
  bool get isEditing => this is LoginStateEditing;
  bool get isSuccess => this is LoginStateSuccess;
}

final class LoginStateInit extends LoginState {
  const LoginStateInit();
}

final class LoginStateEditing extends LoginState {
  const LoginStateEditing({this.email = '', this.password = ''});

  final String email;
  final String password;
}

final class LoginStateLoading extends LoginState {
  const LoginStateLoading({required this.email, required this.password});

  final String email;
  final String password;
}

final class LoginStateSuccess extends LoginState {
  const LoginStateSuccess();
}

final class LoginStateFailure extends LoginState {
  const LoginStateFailure({
    required this.message,
    this.email = '',
    this.password = '',
  });

  final String message;
  final String email;
  final String password;
}
