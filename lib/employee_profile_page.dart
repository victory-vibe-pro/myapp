import 'package:flutter/material.dart';
import '../models/employee_model.dart';

class EmployeeProfilePage extends StatelessWidget {
  final Employee employee;

  const EmployeeProfilePage({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Profile"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            // Photo Section
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),

              child: employee.photo.isNotEmpty
                  ? Image.asset(employee.photo, fit: BoxFit.cover)
                  : const Icon(Icons.person, size: 70),
            ),

            const SizedBox(height: 15),

            Text(
              employee.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            Text(
              employee.empId,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 10),

            Chip(
              label: Text(employee.status),
              backgroundColor: Colors.green.shade100,
            ),

            const SizedBox(height: 20),

            // Basic Information
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Basic Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Divider(),

                    profileRow("Department", employee.department),
                    profileRow("Phone", employee.phone),
                    profileRow("Email", employee.email),
                    profileRow("Joining Date", employee.joiningDate),
                    profileRow("Experience", employee.experience),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Skills
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Skills",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Divider(),

                    Text(employee.skills),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Salary Information
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Salary Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Divider(),

                    profileRow("Basic Salary", "₹${employee.basicSalary}"),

                    profileRow("Allowances", "₹${employee.allowances}"),

                    profileRow("Deductions", "₹${employee.deductions}"),

                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Text(
                        "Net Salary : ₹${employee.netSalary}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },

                icon: const Icon(Icons.arrow_back),

                label: const Text("Back"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
