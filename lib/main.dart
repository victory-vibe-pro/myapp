import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:project/slash_page.dart';

void main() {
  // sqfliteFfiInit();

  // databaseFactory = databaseFactoryFfi;
  runApp(const ProjectApp());
}

class ProjectApp extends StatelessWidget {
  const ProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Salary Management',

      home: const SlashPage(),
      // home: Loginpage(),
    );
  }
}
