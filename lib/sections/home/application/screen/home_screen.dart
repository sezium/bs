import 'package:bs/base/application/screen/base_screen.dart';
import 'package:bs/sections/home/application/bloc/home_bloc.dart';
import 'package:flutter/material.dart';

class HomeScreen extends SingleBlocScreen<HomeBloc> {
  HomeScreen({super.key}) : super(bloc: HomeBloc());

  @override
  Widget mobile(BuildContext context) => const Placeholder();
  @override
  Widget tablet(BuildContext context) => const Placeholder();
  @override
  Widget desktop(BuildContext context) => const Placeholder();

}
