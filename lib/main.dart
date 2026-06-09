import 'package:flutter/material.dart';
import 'package:project/homepage.dart';

void main() {
  runApp(const Project());
}

class Project extends StatelessWidget {
  const Project({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
