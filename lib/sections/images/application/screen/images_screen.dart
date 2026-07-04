import 'package:bs/base/application/screen/base_screen.dart';
import 'package:bs/sections/images/application/bloc/images_bloc.dart';
import 'package:flutter/material.dart';

class ImagesScreen extends SingleBlocScreen<ImagesBloc> {
  ImagesScreen({super.key}) : super(bloc: ImagesBloc());
  static String get route => '/images';

  @override
  Widget mobile(BuildContext context) => const Placeholder();
  @override
  Widget tablet(BuildContext context) => const Placeholder();
  @override
  Widget desktop(BuildContext context) => const Placeholder();

}
