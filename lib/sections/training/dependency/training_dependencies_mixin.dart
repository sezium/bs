import 'package:bs/base/domain/repository/base_repository_manager.dart';
import 'package:bs/sections/training/domain/repository/training_repository.dart';

mixin TrainingDependenciesMixin {
  TrainingRepository get trainingRepository => BaseRepositoryManager.get<TrainingRepository>();
}
