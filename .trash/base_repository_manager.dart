import 'package:bs/base/repository/base_repository.dart';

abstract class BaseRepositoryManager {
  BaseRepositoryManager._();

  static final Map<Type, BaseRepository> _repositories = {};

  static T? get<T extends BaseRepository>() {
    return _repositories[T] as T?;
  }

  static void add<T extends BaseRepository>(T repository) {
    _repositories[T] = repository;
  }

  static void delete<T extends BaseRepository>(T repository) {
    _repositories.remove(repository);
  }
}
