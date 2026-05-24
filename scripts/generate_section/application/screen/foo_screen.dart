import 'package:$baseDir$/$baseClassesDir$/$applicationDir$/$screenDir$/base_screen.dart';
import 'package:$baseDir$/$sectionsDir$/$foo$/$applicationDir$/$blocDir$/$foo$_bloc.dart';
import 'package:flutter/material.dart';

class $Foo$Screen extends BaseScreen<$Foo$Bloc> {
  $Foo$Screen({super.key}) : super(bloc: $Foo$Bloc());

  @override
  Widget phone(BuildContext context) => const Placeholder();
  @override
  Widget tablet(BuildContext context) => const Placeholder();
  @override
  Widget desktop(BuildContext context) => const Placeholder();

}
