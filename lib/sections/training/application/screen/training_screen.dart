import 'package:bs/base/application/screen/base_screen.dart';
import 'package:bs/sections/training/application/bloc/training_bloc.dart';
import 'package:flutter/material.dart';

class TrainingScreen extends SingleBlocScreen<TrainingBloc> {
  TrainingScreen({super.key}) : super(bloc: TrainingBloc());
  static String get route => '/training';

  @override
  Widget mobile(BuildContext context) => const Placeholder();
  @override
  Widget tablet(BuildContext context) => const Placeholder();
  @override
  Widget desktop(BuildContext context) => const Placeholder();

}
