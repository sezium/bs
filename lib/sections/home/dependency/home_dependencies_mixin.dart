import 'package:bs/base/domain/repository/base_repository_manager.dart';
import 'package:bs/sections/home/domain/repository/home_repository.dart';

mixin HomeDependenciesMixin {
  HomeRepository get homeRepository => BaseRepositoryManager.get<HomeRepository>();
}
