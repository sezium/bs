import 'package:bs/sections/names/application/bloc/names_event.dart';
import 'package:bs/sections/names/application/bloc/names_state.dart';
import 'package:bs/sections/names/dependency/names_dependencies_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class NamesBloc extends Bloc<NamesEvent, NamesState> with NamesDependenciesMixin {
  NamesBloc() : super(const NamesStateInit()) {
    on<NamesEventInit>(_onInit);
  }

  void _onInit(NamesEventInit event, Emitter<NamesState> emit) {
    emit(const NamesStateInit());
  }
}
