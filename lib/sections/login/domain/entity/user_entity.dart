import 'package:bs/base/domain/entity/base_entity.dart';

// TODO add @GenerateModel()
class UserEntity extends BaseEntity {
  const UserEntity({required this.name, required this.id});

  final String name;
  final String id;
}
