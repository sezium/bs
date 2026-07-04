import 'package:bs/base/domain/repository/base_repository_manager.dart';
import 'package:bs/sections/international_names/domain/repository/international_names_repository.dart';

mixin International_namesDependenciesMixin {
  International_namesRepository get international_namesRepository => BaseRepositoryManager.get<International_namesRepository>();
}
