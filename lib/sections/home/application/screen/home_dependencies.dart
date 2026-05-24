import 'package:bs/base/application/screen/base_dependencies.dart';
import 'package:bs/sections/home/domain/repository/home_repository.dart';
import 'package:bs/sections/home/domain/repository/home_repository_impl.dart';

class HomeDependencies extends BaseDependencies {
  HomeDependencies._();

  static final HomeDependencies instance = HomeDependencies._();
  factory HomeDependencies() => instance;
}

mixin HomeDependenciesMixin {
  HomeRepository get homeRepository =>
      HomeDependencies.instance.get(HomeRepositoryImpl.new);
}
