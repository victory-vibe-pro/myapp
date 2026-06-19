import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/employee_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController empIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController basicSalaryController = TextEditingController();

  final TextEditingController allowancesController = TextEditingController();

  final TextEditingController deductionsController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController joiningDateController = TextEditingController();

  final TextEditingController skillsController = TextEditingController();

  final TextEditingController experienceController = TextEditingController();

  String? selectedDepartment;
  String selectedStatus = 'Active';

  final List<String> departments = [
    'IT',
    'HR',
    'Finance',
    'Marketing',
    'Sales',
    'Operations',
  ];

  final List<String> statuses = ['Active', 'Inactive', 'On Leave', 'Resigned'];
  //image selection
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    empIdController.dispose();
    nameController.dispose();
    phoneController.dispose();
    basicSalaryController.dispose();
    allowancesController.dispose();
    deductionsController.dispose();
    emailController.dispose();
    joiningDateController.dispose();
    skillsController.dispose();
    experienceController.dispose();

    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        joiningDateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  void _clearForm() {
    empIdController.clear();
    nameController.clear();
    phoneController.clear();
    basicSalaryController.clear();
    allowancesController.clear();
    deductionsController.clear();
    emailController.clear();
    joiningDateController.clear();
    skillsController.clear();
    experienceController.clear();

    selectedDepartment = null;
    selectedStatus = "Active";

    setState(() {});
  }

  Future<void> _showClearDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Clear Form"),
          content: const Text("Are you sure you want to clear the form?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _clearForm();
              },
              child: const Text("Clear"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      if (selectedDepartment == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select department")),
        );
        return;
      }

      Employee employee = Employee(
        empId: empIdController.text.trim(),
        name: nameController.text.trim(),
        department: selectedDepartment!,
        phone: phoneController.text.trim(),
        basicSalary: basicSalaryController.text.trim(),
        allowances: allowancesController.text.trim().isEmpty
            ? "0"
            : allowancesController.text.trim(),
        deductions: deductionsController.text.trim().isEmpty
            ? "0"
            : deductionsController.text.trim(),
        email: emailController.text.trim(),
        joiningDate: joiningDateController.text.trim(),
        skills: skillsController.text.trim(),
        status: selectedStatus,
        experience: experienceController.text.trim(),
        photo: _selectedImage?.path ?? '',
      );

      await DatabaseHelper.instance.insertEmployee(employee);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Employee Added Successfully"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Employee"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              TextFormField(
                controller: empIdController,
                decoration: const InputDecoration(
                  labelText: "Employee ID",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter Employee ID";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Employee Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter Employee Name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                initialValue: selectedDepartment,
                decoration: const InputDecoration(
                  labelText: "Department",
                  border: OutlineInputBorder(),
                ),
                items: departments.map((dept) {
                  return DropdownMenuItem(value: dept, child: Text(dept));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDepartment = value;
                  });
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter Phone Number";
                  }

                  if (value.length != 10) {
                    return "Enter valid phone number";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: basicSalaryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Basic Salary",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter Basic Salary";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: allowancesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Allowances",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: deductionsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Deductions",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: joiningDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Joining Date",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: skillsController,
                decoration: const InputDecoration(
                  labelText: "Skills (Comma Separated)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
                items: statuses.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: experienceController,
                decoration: const InputDecoration(
                  labelText: "Experience",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),
              Container(
                width: 120,
                height: 120,

                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      )
                    : const Icon(Icons.person, size: 60),
              ),

              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.photo),
                label: const Text("Choose Photo"),
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveEmployee,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),

                      child: const Text(
                        "Save Employee",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showClearDialog,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),

                      child: const Text(
                        "Clear",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
