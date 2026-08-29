import 'package:bs/base/domain/repository/base_repository_manager.dart';
import 'package:bs/core/settings/category_settings_repository.dart';
import 'package:bs/sections/cards/domain/repository/cards_repository.dart';

mixin CardsDependenciesMixin {
  CardsRepository get cardsRepository => BaseRepositoryManager.get<CardsRepository>();
  CategorySettingsRepository get categorySettingsRepository =>
      BaseRepositoryManager.get<CategorySettingsRepository>();
}
