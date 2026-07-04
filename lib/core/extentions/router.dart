
import 'package:bs/sections/login/application/screen/login_screen.dart';
import 'package:bs/sections/training/application/screen/training_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: TrainingScreen().routeName,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: LoginScreen().routeName,
        builder: (context, state) => LoginScreen(),
      ),
      
    ],
    errorBuilder: (context, state) => const _RouteNotFoundScreen(),
  );
}

class _RouteNotFoundScreen extends StatelessWidget {
  const _RouteNotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Pagina non trovata')),
    );
  }
}