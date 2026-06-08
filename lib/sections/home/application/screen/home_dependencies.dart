import 'package:bs/base/application/screen/base_dependencies.dart';
import 'package:bs/sections/home/domain/repository/home_repository.dart';
import 'package:bs/sections/home/domain/repository/home_repository_impl.dart';

class HomeDependencies extends BaseDependencies {
  HomeDependencies._();

  static final HomeDependencies _instance = HomeDependencies._();
  static HomeRepository get repository => _instance.get(HomeRepositoryImpl.new);
}

mixin HomeDependenciesMixin {
  HomeRepository get homeRepository =>
      HomeDependencies.repository;
}