import 'package:bs/sections/numbers/application/bloc/numbers_event.dart';
import 'package:bs/sections/numbers/application/bloc/numbers_state.dart';
import 'package:bs/sections/numbers/dependency/numbers_dependencies_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class NumbersBloc extends Bloc<NumbersEvent, NumbersState> with NumbersDependenciesMixin {
  NumbersBloc() : super(const NumbersStateInit()) {
    on<NumbersEventInit>(_onInit);
  }

  void _onInit(NumbersEventInit event, Emitter<NumbersState> emit) {
    emit(const NumbersStateInit());
  }
}
