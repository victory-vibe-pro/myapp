import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/employee_model.dart';
import 'employee_profile_page.dart';
import 'add_employee.dart';

class EmployeeDetailsPage extends StatefulWidget {
  const EmployeeDetailsPage({super.key});

  @override
  State<EmployeeDetailsPage> createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  late Future<List<Employee>> _employeesFuture;
  final searchController = TextEditingController();

  List<Employee> allEmployees = [];
  List<Employee> filteredEmployees = [];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
    loadEmployees();
  }

  void _loadEmployees() {
    _employeesFuture = DatabaseHelper.instance.getEmployees();
  }

  Future<void> _refreshEmployees() async {
    setState(() {
      _loadEmployees();
    });
    await loadEmployees();
  }

  Future<void> loadEmployees() async {
    allEmployees = await DatabaseHelper.instance.getEmployees();

    filteredEmployees = allEmployees;

    setState(() {});
  }

  void searchEmployee(String value) {
    filteredEmployees = allEmployees.where((employee) {
      return employee.name.toLowerCase().contains(value.toLowerCase()) ||
          employee.empId.toLowerCase().contains(value.toLowerCase());
    }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Details"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: FutureBuilder<List<Employee>>(
        future: _employeesFuture,

        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final employees = snapshot.data ?? [];

          // Empty State
          if (employees.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey),

                  SizedBox(height: 10),

                  Text(
                    "No Employees Found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Click + button to add employees",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshEmployees,
            child: SizedBox.expand(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),

                    child: TextField(
                      controller: searchController,

                      decoration: const InputDecoration(
                        hintText: "Search Employee",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),

                      onChanged: searchEmployee,
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(Colors.blue),
                          headingTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          dataRowHeight: 60,
                          columnSpacing: 20,
                          columns: const [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('EMP ID')),
                            DataColumn(label: Text('NAME')),
                            DataColumn(label: Text('DEPARTMENT')),
                            DataColumn(label: Text('PHONE')),
                            DataColumn(label: Text('Net SALARY')),
                            DataColumn(label: Text('Delete')),
                          ],
                          rows: filteredEmployees.map((employee) {
                            return DataRow(
                              cells: [
                                DataCell(Text(employee.id.toString())),
                                DataCell(
                                  Text(
                                    employee.empId,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EmployeeProfilePage(
                                          employee: employee,
                                        ),
                                      ),
                                    );

                                    _refreshEmployees();
                                  },
                                ),
                                DataCell(Text(employee.name)),
                                DataCell(Text(employee.department)),
                                DataCell(Text(employee.phone)),
                                DataCell(Text('₹${employee.netSalary}')),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      bool? confirm = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                              "Delete Employee",
                                            ),
                                            content: Text(
                                              "Are you sure you want to permanently delete ${employee.name} ?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                                child: const Text("Cancel"),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),

                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },

                                                child: const Text("Delete"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (confirm == true) {
                                        await DatabaseHelper.instance
                                            .deleteEmployee(employee.id!);

                                        _refreshEmployees();

                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "${employee.name} deleted successfully",
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,

        onPressed: () async {
          await Navigator.push(
            context,

            MaterialPageRoute(builder: (_) => const AddEmployeePage()),
          );

          _refreshEmployees();
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}
