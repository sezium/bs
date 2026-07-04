import 'package:bs/sections/images/application/bloc/images_event.dart';
import 'package:bs/sections/images/application/bloc/images_state.dart';
import 'package:bs/sections/images/dependency/images_dependencies_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class ImagesBloc extends Bloc<ImagesEvent, ImagesState> with ImagesDependenciesMixin {
  ImagesBloc() : super(const ImagesStateInit()) {
    on<ImagesEventInit>(_onInit);
  }

  void _onInit(ImagesEventInit event, Emitter<ImagesState> emit) {
    emit(const ImagesStateInit());
  }
}
