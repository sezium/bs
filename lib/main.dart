import 'package:bs/base/domain/repository/base_repository_manager.dart';
import 'package:bs/main_app.dart';
import 'package:bs/sections/training/domain/repository/training_repository.dart';
import 'package:bs/sections/training/domain/repository/training_repository_impl.dart';
import 'package:flutter/material.dart';

void main() {

  BaseRepositoryManager.register<TrainingRepository>(TrainingRepositoryImpl.new);

  runApp(const MainApp());
  
}

