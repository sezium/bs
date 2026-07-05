import 'package:bs/sections/international_names/application/bloc/international_names_event.dart';
import 'package:bs/sections/international_names/application/bloc/international_names_state.dart';
import 'package:bs/sections/international_names/dependency/international_names_dependencies_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class InternationalNamesBloc extends Bloc<InternationalNamesEvent, InternationalNamesState> with InternationalNamesDependenciesMixin {
  InternationalNamesBloc() : super(const InternationalNamesStateInit()) {
    on<InternationalNamesEventInit>(_onInit);
  }

  void _onInit(InternationalNamesEventInit event, Emitter<InternationalNamesState> emit) {
    emit(const InternationalNamesStateInit());
  }
}
