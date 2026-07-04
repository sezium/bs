import 'package:bs/base/domain/repository/base_repository.dart';
import 'package:bs/sections/home/domain/repository/home_repository.dart';
import 'package:bs/sections/home/domain/repository/home_repository_impl.dart';
import 'package:bs/sections/login/domain/repository/login_repository.dart';
import 'package:bs/sections/login/domain/repository/login_repository_impl.dart';
import 'package:bs/sections/profile/domain/repository/profile_repository.dart';
import 'package:bs/sections/profile/domain/repository/profile_repository_impl.dart';

abstract class BaseRepositoryManager {
  BaseRepositoryManager._();

  static final _factories = <Type, BaseRepository Function()>{};
  static final _instances = <Type, BaseRepository>{};

  static void register<T extends BaseRepository>(T Function() factory) {
    _factories[T] = factory;
  }

  static T get<T extends BaseRepository>() {
    final cached = _instances[T];
    if (cached != null) {
      return cached as T;
    }

    final factory = _factories[T];
    if (factory == null) {
      throw StateError('Repository not registered for $T');
    }

    final instance = factory() as T;
    _instances[T] = instance;
    return instance;
  }

  static void init() {
    register<LoginRepository>(LoginRepositoryImpl.new);
    register<HomeRepository>(HomeRepositoryImpl.new);
    register<ProfileRepository>(ProfileRepositoryImpl.new);
  }
}
