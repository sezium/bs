import 'package:bs/base/domain/repository/base_repository.dart';

abstract class BaseRepositoryManager {
  BaseRepositoryManager._();

  static final _factories = <Type, BaseRepository Function()>{};

  static void register<T extends BaseRepository>(T Function() factory) {
    _factories[T] = factory;
  }
  static void unregister<T extends BaseRepository>() {
    _factories.remove(T);
  }

  static T get<T extends BaseRepository>() {

    final factory = _factories[T];
    if (factory == null) {
      throw StateError('Repository not registered for $T');
    }
    return factory() as T;
  }

}
