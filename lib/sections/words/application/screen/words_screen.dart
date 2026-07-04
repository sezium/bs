import 'package:bs/base/application/screen/base_screen.dart';
import 'package:bs/sections/words/application/bloc/words_bloc.dart';
import 'package:flutter/material.dart';

class WordsScreen extends SingleBlocScreen<WordsBloc> {
  WordsScreen({super.key}) : super(bloc: WordsBloc());
  static String get route => '/words';

  @override
  Widget mobile(BuildContext context) => const Placeholder();
  @override
  Widget tablet(BuildContext context) => const Placeholder();
  @override
  Widget desktop(BuildContext context) => const Placeholder();

}
