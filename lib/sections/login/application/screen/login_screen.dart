import 'package:bs/base/application/screen/base_screen.dart';
import 'package:bs/sections/home/application/screen/home_screen.dart';
import 'package:bs/sections/login/application/bloc/login_bloc.dart';
import 'package:bs/sections/login/application/bloc/login_event.dart';
import 'package:bs/sections/login/application/bloc/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends SingleBlocScreen<LoginBloc> {
  LoginScreen({super.key}) : super(bloc: LoginBloc());

  @override
  Widget mobile(BuildContext context) => page(context);
  @override
  Widget tablet(BuildContext context) => page(context);
  @override
  Widget desktop(BuildContext context) => page(context);

  Widget page(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (_, current) => current is LoginStateFailure || current is LoginStateSuccess,
      listener: (context, state) {
        switch (state) {
          case LoginStateFailure(:final message):
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          case LoginStateSuccess():
            Navigator.pushReplacement<void, void>(context, MaterialPageRoute<void>(builder: (_) => HomeScreen()));
          default:
            break;
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginStateLoading;
        final errorMessage = switch (state) {
          LoginStateFailure(:final message) => message,
          _ => null,
        };
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                enabled: !isLoading,
                onChanged: (email) => bloc.add(LoginEventEmailChanged(email: email)),
              ),
              TextField(
                enabled: !isLoading,
                obscureText: true,
                onChanged: (password) => bloc.add(LoginEventPasswordChanged(password: password)),
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(errorMessage, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ),
              if (isLoading) const CircularProgressIndicator(),
              ElevatedButton(
                onPressed: isLoading ? null : () => bloc.add(const LoginEventSubmit()),
                child: const Text('Login'),
              ),
            ],
          ),
        );
      },
    );
  }
  
}