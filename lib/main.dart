import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'core/services/app_database.dart';
import 'features/auth/screens/role_selection_screen.dart';

void main() {
  runApp(const SmartGateApp());
}

class SmartGateApp extends StatelessWidget {
  const SmartGateApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initializing the singleton DB so it's ready app-wide
    final _ = AppDatabase.instance;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Gate',
      theme: AppTheme.lightTheme,
      home: const RoleSelectionScreen(),
    );
  }
}
