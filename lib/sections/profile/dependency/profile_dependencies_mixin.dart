import 'package:bs/sections/profile/dependency/profile_dependencies.dart';
import 'package:bs/sections/profile/domain/repository/profile_repository.dart';

mixin ProfileDependenciesMixin {
  ProfileRepository get profileRepository => ProfileDependencies.repository;
}