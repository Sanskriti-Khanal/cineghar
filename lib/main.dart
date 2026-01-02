import 'package:cineghar/app.dart';
import 'package:cineghar/core/services/hive/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  final hiveService = HiveService();
  await hiveService.init();
  
  runApp(const ProviderScope(child: App()));
}
