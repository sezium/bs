import 'package:bs/base/application/screen/base_dependencies.dart';
import 'package:bs/sections/profile/domain/repository/profile_repository.dart';
import 'package:bs/sections/profile/domain/repository/profile_repository_impl.dart';

class ProfileDependencies extends BaseDependencies {
  ProfileDependencies._();

  static final ProfileDependencies _instance = ProfileDependencies._();
  static ProfileRepository get repository => _instance.get(ProfileRepositoryImpl.new);
}
