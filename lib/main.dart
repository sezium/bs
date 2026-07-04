import 'package:bs/base/domain/repository/base_repository_manager.dart';
import 'package:bs/main_app.dart';
import 'package:flutter/material.dart';

void main() {
  BaseRepositoryManager.init();
  runApp(const MainApp());
}
