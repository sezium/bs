import 'package:bs/base/application/screen/base_dependencies.dart';
import 'package:bs/sections/login/domain/repository/login_repository.dart';
import 'package:bs/sections/login/domain/repository/login_repository_impl.dart';

class LoginDependencies extends BaseDependencies {
  LoginDependencies._();

  static final LoginDependencies instance = LoginDependencies._();
  factory LoginDependencies() => instance;

}

mixin LoginDependenciesMixin {
  LoginRepository get loginRepository => LoginDependencies.instance.get(LoginRepositoryImpl.new);
}
