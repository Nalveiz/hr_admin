import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String? id;
  final String name;
  final String surname;
  final String email;
  final String? role;
  final String company;
  final String department;
  final String position;
  final DateTime employmentStartDate;
  final String phone;
  final String? address;
  final String? signature;
  final String? attachment;
  final String? note;
  final int status;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;

  const Employee({
    this.id,
    required this.name,
    required this.surname,
    required this.email,
    this.role,
    required this.department,
    required this.company,
    required this.position,
    required this.employmentStartDate,
    required this.phone,
    this.address,
    this.signature,
    this.attachment,
    this.note,
    required this.status,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  String get fullName => '$name $surname';

  @override
  List<Object?> get props => [
    id,
    name,
    surname,
    email,
    role,
    department,
    company,
    position,
    employmentStartDate,
    phone,
    address,
    signature,
    attachment,
    note,
    status,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
  ];
  Employee copyWith({
    String? id,
    String? name,
    String? surname,
    String? email,
    String? role,
    String? department,
    String? company,
    String? position,
    DateTime? employmentStartDate,
    String? phone,
    String? address,
    String? signature,
    String? attachment,
    String? note,
    int? status,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      role: role ?? this.role,
      department: department ?? this.department,
      company: company ?? this.company,
      position: position ?? this.position,
      employmentStartDate: employmentStartDate ?? this.employmentStartDate,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      signature: signature ?? this.signature,
      attachment: attachment ?? this.attachment,
      note: note ?? this.note,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      role: json['role'],
      company: json['company'],
      department: json['department'],
      position: json['position'],
      employmentStartDate: DateTime.parse(json['employmentStartDate']),
      phone: json['phone'],
      address: json['address'],
      signature: json['signature'],
      attachment: json['attachment'],
      note: json['note'],
      status: json['status'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      createdBy: json['createdBy'],
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      if (role != null) 'role': role,
      'department': department,
      'company': company,
      'position': position,
      'employmentStartDate': employmentStartDate.toIso8601String(),
      'phone': phone,
      if (address != null) 'address': address,
      if (signature != null) 'signature': signature,
      if (attachment != null) 'attachment': attachment,
      if (note != null) 'note': note,
      'status': status,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (createdBy != null) 'createdBy': createdBy,
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (updatedBy != null) 'updatedBy': updatedBy,
    };
  }
}
