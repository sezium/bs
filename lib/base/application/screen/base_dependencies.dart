import 'package:bs/base/domain/repository/base_repository.dart';

abstract class BaseDependencies {
  static final Map<Type, BaseDependencies> _instances = {};

  static T of<T extends BaseDependencies>(T Function() create) =>
      _instances.putIfAbsent(T, create) as T;

  final Map<Type, BaseRepository> _repositories = {};

  T get<T extends BaseRepository>(T Function() create) =>
      _repositories.putIfAbsent(T, create) as T;
}