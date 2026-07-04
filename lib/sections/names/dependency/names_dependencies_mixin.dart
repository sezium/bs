import 'package:bs/base/domain/repository/base_repository_manager.dart';
import 'package:bs/sections/names/domain/repository/names_repository.dart';

mixin NamesDependenciesMixin {
  NamesRepository get namesRepository => BaseRepositoryManager.get<NamesRepository>();
}
