import 'package:bs/sections/training/application/bloc/training_event.dart';
import 'package:bs/sections/training/application/bloc/training_state.dart';
import 'package:bs/sections/training/dependency/training_dependencies_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class TrainingBloc extends Bloc<TrainingEvent, TrainingState> with TrainingDependenciesMixin {
  TrainingBloc() : super(const TrainingStateInit()) {
    on<TrainingEventInit>(_onInit);
  }

  void _onInit(TrainingEventInit event, Emitter<TrainingState> emit) {
    emit(const TrainingStateInit());
  }
}
