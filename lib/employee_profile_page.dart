import 'package:flutter/material.dart';

class EmployeeProfilePage extends StatelessWidget {
  final String srno;
  final String empId;
  final String name;
  final String department;
  final String phone;
  final String salary;

  const EmployeeProfilePage({
    super.key,
    required this.srno,
    required this.empId,
    required this.name,
    required this.department,
    required this.phone,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Profile"),
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Employee Details",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 20),

                Text("Employee ID : $empId"),
                SizedBox(height: 10),

                Text("Name : $name"),
                SizedBox(height: 10),

                Text("Department : HR"),
                SizedBox(height: 10),

                Text("Designation : Manager"),
                SizedBox(height: 10),

                Text("Phone : 9876543210"),
                SizedBox(height: 10),

                Text("Email : employee@gmail.com"),
                SizedBox(height: 10),

                Text("Salary : ₹40,000"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
