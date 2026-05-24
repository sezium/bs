import 'package:bs/sections/home/application/bloc/home_event.dart';
import 'package:bs/sections/home/application/bloc/home_state.dart';
import 'package:bs/sections/home/application/screen/home_dependencies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> with HomeDependenciesMixin {
  HomeBloc() : super(const HomeStateInit()) {
    on<HomeEventInit>(_onInit);
  }

  void _onInit(HomeEventInit event, Emitter<HomeState> emit) {
    emit(const HomeStateInit());
  }
}
