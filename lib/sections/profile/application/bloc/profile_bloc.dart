import 'package:bs/sections/profile/application/bloc/profile_event.dart';
import 'package:bs/sections/profile/application/bloc/profile_state.dart';
import 'package:bs/sections/profile/dependency/profile_dependencies_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class ProfileBloc extends Bloc<ProfileEvent, ProfileState> with ProfileDependenciesMixin {
  ProfileBloc() : super(const ProfileStateInit()) {
    on<ProfileEventInit>(_onInit);
  }

  void _onInit(ProfileEventInit event, Emitter<ProfileState> emit) {
    emit(const ProfileStateInit());
  }
}
