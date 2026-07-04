
import 'package:bs/sections/login/application/screen/login_screen.dart';
import 'package:bs/sections/training/application/screen/training_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: TrainingScreen().route,
    debugLogDiagnostics: true,
    routes: [
     
      GoRoute(
        path: LoginScreen().route,
        builder: (context, state) => LoginScreen(),
      ),
      
    ],
    errorBuilder: (context, state) => const _RouteNotFoundScreen(),
    redirect: (context, state) {
      // Esempio: guard di autenticazione
      // final isLoggedIn = context.read<AuthBloc>().state.isAuthenticated;
      // final goingToLogin = state.matchedLocation == LoginScreen.route;
      //
      // if (!isLoggedIn && !goingToLogin) return LoginScreen.route;
      // if (isLoggedIn && goingToLogin) return HomeScreen.route;

      return null; // nessun redirect
    },
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