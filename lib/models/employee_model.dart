class Employee {
  int? id;

  String empId;
  String name;
  String department;
  String phone;

  // Payroll Fields
  String basicSalary;
  String allowances;
  String deductions;

  // Expanded Profile Fields
  String email;
  String joiningDate;
  String skills;
  String status;
  String experience;
  String photo;

  Employee({
    this.id,
    required this.empId,
    required this.name,
    required this.department,
    required this.phone,
    required this.basicSalary,
    required this.allowances,
    required this.deductions,
    required this.email,
    required this.joiningDate,
    required this.skills,
    required this.status,
    required this.experience,
    required this.photo,
  });

  // Calculate Net Salary
  int get netSalary {
    return int.parse(basicSalary) +
        int.parse(allowances) -
        int.parse(deductions);
  }

  // Convert Employee object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'empId': empId,
      'name': name,
      'department': department,
      'phone': phone,
      'basicSalary': basicSalary,
      'allowances': allowances,
      'deductions': deductions,
      'email': email,
      'joiningDate': joiningDate,
      'skills': skills,
      'status': status,
      'experience': experience,
      'photo': photo,
    };
  }

  // Convert SQLite Map to Employee object
  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      empId: map['empId'],
      name: map['name'],
      department: map['department'],
      phone: map['phone'],
      basicSalary: map['basicSalary'] ?? '0',
      allowances: map['allowances'] ?? '0',
      deductions: map['deductions'] ?? '0',
      email: map['email'] ?? '',
      joiningDate: map['joiningDate'] ?? '',
      skills: map['skills'] ?? '',
      status: map['status'] ?? '',
      experience: map['experience'] ?? '',
      photo: map['photo'] ?? '',
    );
  }
}
