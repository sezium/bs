import 'package:bs/base/domain/repository/base_repository.dart';
import 'package:bs/sections/login/domain/entity/user_entity.dart';

abstract class LoginRepository extends BaseRepository {
  Future<UserEntity> login(String email, String password);
}
