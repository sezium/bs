import 'package:bs/base/domain/repository/base_repository_manager.dart';
import 'package:bs/sections/$foo$/$domainDir$/$repositoryDir$/$foo$_repository.dart';

mixin $Foo$DependenciesMixin {
  $Foo$Repository get $foo$Repository => BaseRepositoryManager.get<$Foo$Repository>();
}
