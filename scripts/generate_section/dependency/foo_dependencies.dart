import 'package:$baseDir$/$baseClassesDir$/$applicationDir$/$screenDir$/base_dependencies.dart';
import 'package:$baseDir$/$sectionsDir$/$foo$/$domainDir$/$repositoryDir$/$foo$_repository.dart';
import 'package:$baseDir$/$sectionsDir$/$foo$/$domainDir$/$repositoryDir$/$foo$_repository_impl.dart';

class $Foo$Dependencies extends BaseDependencies {
  $Foo$Dependencies._();

  static final $Foo$Dependencies _instance = $Foo$Dependencies._();
  static $Foo$Repository get repository => _instance.get($Foo$RepositoryImpl.new);
}
