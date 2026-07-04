import 'package:bs/sections/international_names/application/bloc/international_names_event.dart';
import 'package:bs/sections/international_names/application/bloc/international_names_state.dart';
import 'package:bs/sections/international_names/dependency/international_names_dependencies_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class InternationalNamesBloc extends Bloc<InternationalNamesEvent, International_namesState> with International_namesDependenciesMixin {
  InternationalNamesBloc() : super(const International_namesStateInit()) {
    on<InternationalNamesEventInit>(_onInit);
  }

  void _onInit(InternationalNamesEventInit event, Emitter<International_namesState> emit) {
    emit(const International_namesStateInit());
  }
}
