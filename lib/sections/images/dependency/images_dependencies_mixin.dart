import 'package:bs/base/domain/repository/base_repository_manager.dart';
import 'package:bs/sections/images/domain/repository/images_repository.dart';

mixin ImagesDependenciesMixin {
  ImagesRepository get imagesRepository => BaseRepositoryManager.get<ImagesRepository>();
}
