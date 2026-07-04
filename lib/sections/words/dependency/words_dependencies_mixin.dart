import 'package:bs/base/domain/repository/base_repository_manager.dart';
import 'package:bs/sections/words/domain/repository/words_repository.dart';

mixin WordsDependenciesMixin {
  WordsRepository get wordsRepository => BaseRepositoryManager.get<WordsRepository>();
}
