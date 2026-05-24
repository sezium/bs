import 'package:bs/base/application/screen/base_screen.dart';
import 'package:bs/sections/home/application/bloc/home_bloc.dart';
import 'package:bs/sections/login/application/bloc/login_bloc.dart';
import 'package:flutter/material.dart';

class HomeScreen extends MultiBlocScreen {
  HomeScreen({super.key}) : super(blocs: [HomeBloc(), LoginBloc()]);

  // final x = bloc<HomeBloc>(context).add(HomeEventInit());
  @override
  Widget mobile(BuildContext context) => const Placeholder();

  @override
  Widget tablet(BuildContext context) => const Placeholder();
  @override
  Widget desktop(BuildContext context) => const Placeholder();
}
