import 'package:bs/base/application/screen/base_screen.dart';
import 'package:bs/sections/profile/application/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends SingleBlocScreen<ProfileBloc> {
  ProfileScreen({super.key}) : super(bloc: ProfileBloc());

  @override
  Widget mobile(BuildContext context) => const Placeholder();
  @override
  Widget tablet(BuildContext context) => const Placeholder();
  @override
  Widget desktop(BuildContext context) => const Placeholder();

}
