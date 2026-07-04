import 'package:bs/sections/login/domain/entity/user_entity.dart';
import 'package:bs/sections/login/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  @override
  Future<UserEntity> login(String email, String password) async {
    return UserEntity(name: email, id: email);
  }
}
