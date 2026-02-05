import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(TaskEaseApp());
}

class TaskEaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskEase',
      home: HomeScreen(),
    );
  }
}
