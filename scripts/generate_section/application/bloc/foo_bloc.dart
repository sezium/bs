import 'package:$baseDir$/$sectionsDir$/$foo$/$applicationDir$/$blocDir$/$foo$_event.dart';
import 'package:$baseDir$/$sectionsDir$/$foo$/$applicationDir$/$blocDir$/$foo$_state.dart';
import 'package:$baseDir$/$sectionsDir$/$foo$/$dependencyDir$/$foo$_dependencies_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class $Foo$Bloc extends Bloc<$Foo$Event, $Foo$State> with $Foo$DependenciesMixin {
  $Foo$Bloc() : super(const $Foo$StateInit()) {
    on<$Foo$EventInit>(_onInit);
  }

  void _onInit($Foo$EventInit event, Emitter<$Foo$State> emit) {
    emit(const $Foo$StateInit());
  }
}
