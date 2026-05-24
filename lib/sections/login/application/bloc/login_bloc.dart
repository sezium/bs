import 'package:bs/sections/login/application/bloc/login_event.dart';
import 'package:bs/sections/login/application/bloc/login_state.dart';
import 'package:bs/sections/login/application/screen/login_dependencies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> with LoginDependenciesMixin {
  LoginBloc()
      : super(const LoginStateInit()) {
    on<LoginEventInit>(_onInit);
    on<LoginEventEmailChanged>(_onEmailChanged);
    on<LoginEventPasswordChanged>(_onPasswordChanged);
    on<LoginEventSubmit>(_onSubmit);
  }

  void _onInit(LoginEventInit event, Emitter<LoginState> emit) {
    emit(const LoginStateInit());
  }

  void _onEmailChanged(LoginEventEmailChanged event, Emitter<LoginState> emit) {
    final form = _formData;
    emit(LoginStateEditing(email: event.email, password: form.password));
  }

  void _onPasswordChanged(
    LoginEventPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final form = _formData;
    emit(LoginStateEditing(email: form.email, password: event.password));
  }

  Future<void> _onSubmit(
    LoginEventSubmit event,
    Emitter<LoginState> emit,
  ) async {
    final form = _formData;
    if (form.email.isEmpty || form.password.isEmpty) {
      emit(
        LoginStateFailure(
          message: 'Email e password sono obbligatorie',
          email: form.email,
          password: form.password,
        ),
      );
      return;
    }

    emit(LoginStateLoading(email: form.email, password: form.password));

    try {
      await Future<void>(() {
        loginRepository.getUser(form.email, form.password);
      });
      emit(const LoginStateSuccess());
    } catch (error) {
      emit(
        LoginStateFailure(
          message: error.toString(),
          email: form.email,
          password: form.password,
        ),
      );
    }
  }

  ({String email, String password}) get _formData {
    return switch (state) {
      LoginStateEditing(:final email, :final password) => (
        email: email,
        password: password,
      ),
      LoginStateLoading(:final email, :final password) => (
        email: email,
        password: password,
      ),
      LoginStateFailure(:final email, :final password) => (
        email: email,
        password: password,
      ),
      _ => (email: '', password: ''),
    };
  }

}
