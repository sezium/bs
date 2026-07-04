import 'package:bs/sections/cards/application/screen/cards_screen.dart';
import 'package:bs/sections/images/application/screen/images_screen.dart';
import 'package:bs/sections/international_names/application/screen/international_names_screen.dart';
import 'package:bs/sections/names/application/screen/names_screen.dart';
import 'package:bs/sections/numbers/application/screen/numbers_screen.dart';
import 'package:bs/sections/training/application/screen/training_screen.dart';
import 'package:bs/sections/words/application/screen/words_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: TrainingScreen.route,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: 'training',
        path: TrainingScreen.route,
        builder: (context, state) => TrainingScreen(),
      ),
      GoRoute(
        name: 'cards',
        path: CardsScreen.route,
        builder: (context, state) => CardsScreen(),
      ),
      GoRoute(
        path: ImagesScreen.route,
        builder: (context, state) => ImagesScreen(),
      ),
      GoRoute(
        path: InternationalNamesScreen.route,
        builder: (context, state) => InternationalNamesScreen(),
      ),
      GoRoute(
        path: NamesScreen.route,
        builder: (context, state) => NamesScreen(),
      ),
      GoRoute(
        path: NumbersScreen.route,
        builder: (context, state) =>NumbersScreen(),
      ),
      GoRoute(
        path: WordsScreen.route,
        builder: (context, state) => WordsScreen(),
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