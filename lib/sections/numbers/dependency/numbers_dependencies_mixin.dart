import 'package:bs/base/domain/repository/base_repository_manager.dart';
import 'package:bs/core/settings/category_settings_repository.dart';
import 'package:bs/sections/numbers/domain/repository/numbers_repository.dart';

mixin NumbersDependenciesMixin {
  NumbersRepository get numbersRepository => BaseRepositoryManager.get<NumbersRepository>();
  CategorySettingsRepository get categorySettingsRepository =>
      BaseRepositoryManager.get<CategorySettingsRepository>();
}
