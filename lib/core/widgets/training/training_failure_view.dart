import 'package:flutter/material.dart';

/// Schermata di errore generica, mostra solo il messaggio.
class TrainingFailureView extends StatelessWidget {
  const TrainingFailureView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(child: Text(message));
}