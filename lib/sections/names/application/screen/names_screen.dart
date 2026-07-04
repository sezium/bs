import 'package:bs/base/application/screen/base_screen.dart';
import 'package:bs/sections/names/application/bloc/names_bloc.dart';
import 'package:flutter/material.dart';

class NamesScreen extends SingleBlocScreen<NamesBloc> {
  NamesScreen({super.key}) : super(bloc: NamesBloc());
  static String get route => '/names';

  @override
  Widget mobile(BuildContext context) => const Placeholder();
  @override
  Widget tablet(BuildContext context) => const Placeholder();
  @override
  Widget desktop(BuildContext context) => const Placeholder();

}
