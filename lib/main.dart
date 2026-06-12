import 'package:flutter/material.dart';
import 'package:project/LoginPage.dart';

void main() {
  runApp(const ProjectApp());
}

class ProjectApp extends StatelessWidget {
  const ProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Salary Management',
      home: Loginpage(),
    );
  }
}
