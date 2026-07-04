import 'package:bs/base/application/screen/base_screen.dart';
import 'package:bs/sections/international_names/application/bloc/international_names_bloc.dart';
import 'package:flutter/material.dart';

class InternationalNamesScreen extends SingleBlocScreen<InternationalNamesBloc> {
  InternationalNamesScreen({super.key}) : super(bloc: InternationalNamesBloc());
  static String get route => '/international_names';

  @override
  Widget mobile(BuildContext context) => const Placeholder();
  @override
  Widget tablet(BuildContext context) => const Placeholder();
  @override
  Widget desktop(BuildContext context) => const Placeholder();

}
