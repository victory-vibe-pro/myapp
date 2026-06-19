// import 'package:flutter/material.dart';
// import 'employee_profile_page.dart';

// class Employeedetails extends StatefulWidget {
//   const Employeedetails({super.key});

//   @override
//   State<Employeedetails> createState() => _EmployeedetailsState();
// }

// class _EmployeedetailsState extends State<Employeedetails> {
//   final List<Map<String, String>> employees = [
//     {
//       "srno": "1",
//       "empid": "EMP001",
//       "name": "Rahul Sharma",
//       "department": "HR",
//       "phone": "9876543210",
//       "salary": "40000",
//     },
//     {
//       "srno": "2",
//       "empid": "EMP002",
//       "name": "Priya Verma",
//       "department": "Finance",
//       "phone": "9876543211",
//       "salary": "50000",
//     },
//     {
//       "srno": "3",
//       "empid": "EMP003",
//       "name": "Amit Kumar",
//       "department": "IT",
//       "phone": "9876543212",
//       "salary": "45000",
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Employee Details"),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           children: [
//             // Header Row
//             Container(
//               color: Colors.blue,
//               padding: const EdgeInsets.all(12),
//               child: const Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       "Sr.No",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Text(
//                       "Emp ID",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Text(
//                       "Name",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Data Rows
//             Expanded(
//               child: ListView.builder(
//                 itemCount: employees.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade300),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(child: Text(employees[index]["srno"]!)),

//                         Expanded(
//                           child: InkWell(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => EmployeeProfilePage(
//                                     srno: employees[index]["srno"]!,
//                                     empId: employees[index]["empid"]!,
//                                     name: employees[index]["name"]!,
//                                     department: employees[index]["department"]!,
//                                     phone: employees[index]["phone"]!,
//                                     salary: employees[index]["salary"]!,
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: Text(
//                               employees[index]["empid"]!,
//                               style: const TextStyle(
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.bold,
//                                 decoration: TextDecoration.underline,
//                               ),
//                             ),
//                           ),
//                         ),

//                         Expanded(child: Text(employees[index]["name"]!)),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  void _loadEmployees() {
    _employeesFuture = DatabaseHelper.instance.getEmployees();
  }

  Future<void> _refreshEmployees() async {
    setState(() {
      _loadEmployees();
    });
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
                            DataColumn(label: Text('ACTION')),
                          ],
                          rows: employees.map((employee) {
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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EmployeeProfilePage(
                                          employee: employee,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                DataCell(Text(employee.name)),
                                DataCell(Text(employee.department)),
                                DataCell(Text(employee.phone)),
                                DataCell(Text('₹${employee.netSalary}')),
                                DataCell(
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.delete),
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
