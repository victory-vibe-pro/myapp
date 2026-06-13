import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/employee_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('employee.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE employees (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      empId TEXT NOT NULL,
      name TEXT NOT NULL,
      department TEXT NOT NULL,
      phone TEXT NOT NULL,

      basicSalary TEXT NOT NULL,
      allowances TEXT NOT NULL,
      deductions TEXT NOT NULL,

      email TEXT,
      joiningDate TEXT,
      skills TEXT,
      status TEXT,
      experience TEXT,
      photo TEXT
    )
  ''');
    await db.execute('''
      CREATE TABLE user_master(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.insert('user_master', {
      'username': 'admin',
      'password': 'admin123',
    });
  }

  Future<bool> login(String username, String password) async {
    final db = await instance.database;

    final result = await db.query(
      'user_master',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty;
  }

  // Insert Employee
  Future<int> insertEmployee(Employee employee) async {
    final db = await database;

    return await db.insert('employees', employee.toMap());
  }

  // Get All Employees
  Future<List<Employee>> getEmployees() async {
    final db = await instance.database;

    final result = await db.query('employees');

    return result.map((e) => Employee.fromMap(e)).toList();
  }

  // Get Employee By ID
  Future<Employee?> getEmployeeById(int id) async {
    final db = await instance.database;

    final result = await db.query(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Employee.fromMap(result.first);
    }

    return null;
  }

  // Update Employee
  Future<int> updateEmployee(Employee employee) async {
    final db = await instance.database;

    return await db.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  // Delete Employee
  Future<int> deleteEmployee(int id) async {
    final db = await instance.database;

    return await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }

  // Close Database
  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
