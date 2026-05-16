import 'package:flutter/material.dart';
import 'screens/todo_screen.dart'; // Import change kiya hy

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week 2 Task',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoScreen(), // Yahan TodoScreen set kr di
    );
  }
}