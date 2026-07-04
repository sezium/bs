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

extension LoginStateForm on LoginState {
  String get email => switch (this) {
    LoginStateEditing(:final email) => email,
    LoginStateLoading(:final email) => email,
    LoginStateFailure(:final email) => email,
    _ => '',
  };

  String get password => switch (this) {
    LoginStateEditing(:final password) => password,
    LoginStateLoading(:final password) => password,
    LoginStateFailure(:final password) => password,
    _ => '',
  };

  String? get errorMessage => switch (this) {
    LoginStateFailure(:final message) => message,
    _ => null,
  };
}
