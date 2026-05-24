import 'package:bs/base/domain/repository/base_repository.dart';

abstract class LoginRepository extends BaseRepository {
  void getUser(String email, String password);
}
