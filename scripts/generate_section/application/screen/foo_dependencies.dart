import 'package:$baseDir$/$baseClassesDir$/$applicationDir$/$screenDir$/base_dependencies.dart';
import 'package:$baseDir$/$sectionsDir$/$foo$/$domainDir$/$repositoryDir$/$foo$_repository.dart';
import 'package:$baseDir$/$sectionsDir$/$foo$/$domainDir$/$repositoryDir$/$foo$_repository_impl.dart';

class $Foo$Dependencies extends BaseDependencies {
  $Foo$Dependencies._();

  static final $Foo$Dependencies instance = $Foo$Dependencies._();
  factory $Foo$Dependencies() => instance;
}

mixin $Foo$DependenciesMixin {
  $Foo$Repository get $foo$Repository =>
      $Foo$Dependencies.instance.get($Foo$RepositoryImpl.new);
}
