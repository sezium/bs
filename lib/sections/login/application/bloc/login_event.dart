sealed class LoginEvent {
  const LoginEvent();
}

final class LoginEventInit extends LoginEvent {}

final class LoginEventEmailChanged extends LoginEvent {
  const LoginEventEmailChanged({required this.email});
  final String email;
}

final class LoginEventPasswordChanged extends LoginEvent {
  const LoginEventPasswordChanged({required this.password});
  final String password;
}

final class LoginEventSubmit extends LoginEvent {
  const LoginEventSubmit();
}