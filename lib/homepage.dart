import 'package:flutter/material.dart';
import 'package:project/LoginPage.dart';
import 'package:project/database/database_helper.dart';
import 'EmployeeDetails.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  int employeeCount = 0;
  Widget _buildStatCard({
    required String label,
    required String value,
    required VoidCallback onPressed,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(255, 22, 114, 190),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(value, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onPressed, child: const Text("visit")),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadEmployeeCount();
  }

  Future<void> loadEmployeeCount() async {
    int count = await DatabaseHelper.instance.getEmployeeCount();

    setState(() {
      employeeCount = count;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: SizedBox(
        //     width: 48,
        //     height: 48,
        //     child: Image.asset(
        //       'lib/assets/images/deepa_logo.png',
        //       fit: BoxFit.contain,
        //       errorBuilder: (context, error, stackTrace) {
        //         return Icon(
        //           Icons.image_not_supported,
        //           color: Colors.grey[600],
        //           size: 32,
        //         );
        //       },
        //     ),
        //   ),
        // ),
        // elevation: 0,
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(right: 20),
        //     child: Center(
        //       child: ElevatedButton(
        //         onPressed: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(builder: (context) => Loginpage()),
        //           );
        //         },
        //         child: Text("Login"),
        //       ),
        //     ),
        //   ),
        // ],
        centerTitle: true,
        title: const Text("Home Page"),
        backgroundColor: const Color(0xFF2196F3),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          final double cardWidth = maxWidth >= 960
              ? 280
              : maxWidth >= 720
              ? (maxWidth - 72) / 2
              : maxWidth - 32;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Center(
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  _buildStatCard(
                    label: 'Total Employees',
                    value: employeeCount.toString(),
                    width: cardWidth,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmployeeDetailsPage(),
                        ),
                      );
                      loadEmployeeCount();
                    },
                  ),
                  _buildStatCard(
                    label: 'Present Employees',
                    value: '90',
                    width: cardWidth,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildStatCard(
                    label: 'Absent Employees',
                    value: '10',
                    width: cardWidth,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
