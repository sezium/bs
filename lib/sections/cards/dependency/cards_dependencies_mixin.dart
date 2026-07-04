import 'package:bs/base/domain/repository/base_repository_manager.dart';
import 'package:bs/sections/cards/domain/repository/cards_repository.dart';

mixin CardsDependenciesMixin {
  CardsRepository get cardsRepository => BaseRepositoryManager.get<CardsRepository>();
}
