import 'package:bs/base/application/screen/base_screen.dart';
import 'package:bs/sections/numbers/application/bloc/numbers_bloc.dart';
import 'package:flutter/material.dart';

class NumbersScreen extends SingleBlocScreen<NumbersBloc> {
  NumbersScreen({super.key}) : super(bloc: NumbersBloc());
  static String get route => '/numbers';

  @override
  Widget mobile(BuildContext context) => const Placeholder();
  @override
  Widget tablet(BuildContext context) => const Placeholder();
  @override
  Widget desktop(BuildContext context) => const Placeholder();

}
