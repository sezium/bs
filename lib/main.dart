import 'package:bs/base/domain/repository/base_repository_manager.dart';
import 'package:bs/core/settings/category_settings_repository.dart';
import 'package:bs/core/settings/category_settings_repository_impl.dart';
import 'package:bs/main_app.dart';
import 'package:bs/sections/training/domain/repository/training_repository.dart';
import 'package:bs/sections/training/domain/repository/training_repository_impl.dart';
import 'package:flutter/material.dart';
// TODO fix this
//import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {

  BaseRepositoryManager.register<TrainingRepository>(TrainingRepositoryImpl.new);
  BaseRepositoryManager.register<CategorySettingsRepository>(CategorySettingsRepositoryImpl.new);

 //setUrlStrategy(PathUrlStrategy()); // <-- va chiamato PRIMA di runApp
  runApp(const MainApp());
  
}

