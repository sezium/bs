import 'package:bs/base/domain/repository/base_repository.dart';

abstract class BaseRepositoryManager {
  BaseRepositoryManager._();

  static final _factories = <Type, BaseRepository Function()>{};
  static final _instances = <Type, BaseRepository>{};

  static void register<T extends BaseRepository>(T Function() factory) {
    _factories[T] = factory;
  }
  static void unregister<T extends BaseRepository>() {
    _factories.remove(T);
    _instances.remove(T);
  }

  /// Restituisce sempre la stessa istanza per un dato tipo (singleton),
  /// creandola al primo utilizzo. Prima ogni chiamata invocava di nuovo la
  /// factory, quindi un repository con uno stato interno (es. impostazioni)
  /// veniva ricreato da zero a ogni accesso e non manteneva nulla.
  static T get<T extends BaseRepository>() {
    final cached = _instances[T];
    if (cached != null) return cached as T;

    final factory = _factories[T];
    if (factory == null) {
      throw StateError('Repository not registered for $T');
    }
    final instance = factory();
    _instances[T] = instance;
    return instance as T;
  }

}
