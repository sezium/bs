import 'package:bs/base/domain/repository/base_repository_manager.dart';
import 'package:bs/sections/profile/domain/repository/profile_repository.dart';

mixin ProfileDependenciesMixin {
  ProfileRepository get profileRepository => BaseRepositoryManager.get<ProfileRepository>();
}
