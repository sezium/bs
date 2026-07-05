import 'package:bs/base/domain/repository/base_repository_manager.dart';
import 'package:bs/sections/international_names/domain/repository/international_names_repository.dart';

mixin InternationalNamesDependenciesMixin {
  InternationalNamesRepository get internationalNamesRepository => BaseRepositoryManager.get<InternationalNamesRepository>();
}
