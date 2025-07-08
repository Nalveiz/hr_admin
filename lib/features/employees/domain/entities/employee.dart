import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String id;
  final String employeeId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String position;
  final String department;
  final DateTime hireDate;
  final double salary;
  final String status;
  final DateTime? birthDate;
  final String? address;
  final String? emergencyContact;
  final String? profileImageUrl;

  const Employee({
    required this.id,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.position,
    required this.department,
    required this.hireDate,
    required this.salary,
    required this.status,
    this.birthDate,
    this.address,
    this.emergencyContact,
    this.profileImageUrl,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
    id,
    employeeId,
    firstName,
    lastName,
    email,
    phone,
    position,
    department,
    hireDate,
    salary,
    status,
    birthDate,
    address,
    emergencyContact,
    profileImageUrl,
  ];

  Employee copyWith({
    String? id,
    String? employeeId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? position,
    String? department,
    DateTime? hireDate,
    double? salary,
    String? status,
    DateTime? birthDate,
    String? address,
    String? emergencyContact,
    String? profileImageUrl,
  }) {
    return Employee(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      position: position ?? this.position,
      department: department ?? this.department,
      hireDate: hireDate ?? this.hireDate,
      salary: salary ?? this.salary,
      status: status ?? this.status,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      employeeId: json['employeeId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      position: json['position'],
      department: json['department'],
      hireDate: DateTime.parse(json['hireDate']),
      salary: (json['salary'] as num).toDouble(),
      status: json['status'],
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : null,
      address: json['address'],
      emergencyContact: json['emergencyContact'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'position': position,
      'department': department,
      'hireDate': hireDate.toIso8601String(),
      'salary': salary,
      'status': status,
      'birthDate': birthDate?.toIso8601String(),
      'address': address,
      'emergencyContact': emergencyContact,
      'profileImageUrl': profileImageUrl,
    };
  }
}
