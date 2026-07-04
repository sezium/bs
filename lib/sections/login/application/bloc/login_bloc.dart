import 'package:bs/base/domain/repository/base_repository_manager.dart';
import 'package:bs/sections/login/application/bloc/login_event.dart';
import 'package:bs/sections/login/application/bloc/login_state.dart';
import 'package:bs/sections/login/domain/repository/login_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({LoginRepository? loginRepository})
    : _loginRepository = loginRepository ?? BaseRepositoryManager.get<LoginRepository>(),
      super(const LoginStateInit()) {
    on<LoginEventEmailChanged>(_onEmailChanged);
    on<LoginEventPasswordChanged>(_onPasswordChanged);
    on<LoginEventSubmit>(_onSubmit);
  }

  final LoginRepository _loginRepository;

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
      await _loginRepository.login(form.email, form.password);
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
