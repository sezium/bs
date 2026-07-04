import 'package:bs/sections/training/application/screen/training_screen.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TrainingScreen(),
    );
  }
}
