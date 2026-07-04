import 'package:$baseDir$/$baseClassesDir$/$applicationDir$/$screenDir$/base_screen.dart';
import 'package:$baseDir$/$sectionsDir$/$foo$/$applicationDir$/$blocDir$/$foo$_bloc.dart';
import 'package:flutter/material.dart';

class $Foo$Screen extends SingleBlocScreen<$Foo$Bloc> {
  $Foo$Screen({super.key}) : super(bloc: $Foo$Bloc());
  static String get route => '/$foo$';

  @override
  Widget mobile(BuildContext context) => const Placeholder();
  @override
  Widget tablet(BuildContext context) => const Placeholder();
  @override
  Widget desktop(BuildContext context) => const Placeholder();

}
