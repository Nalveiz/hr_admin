class User {
  final String? id;
  final String? name;
  final String? surname;
  final String? email;
  final int? role; // UserRole enum as int
  final DateTime? employmentStartDate;
  final String? phone;
  final String? address;
  final String? note;
  final String? managerId;
  final String? companyId;
  final List<String>? departmentIds;
  final List<String>? teamIds;
  final bool? valid; // aktif/pasif durum

  const User({
    this.id,
    this.name,
    this.surname,
    this.email,
    this.role,
    this.employmentStartDate,
    this.phone,
    this.address,
    this.note,
    this.managerId,
    this.companyId,
    this.departmentIds,
    this.teamIds,
    this.valid,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      role: json['role'],
      employmentStartDate: json['employmentStartDate'] != null
          ? DateTime.tryParse(json['employmentStartDate'])
          : null,
      phone: json['phone'],
      address: json['address'],
      note: json['note'],
      managerId: json['managerId'],
      companyId: json['companyId'],
      departmentIds: json['departmentIds'] != null
          ? List<String>.from(json['departmentIds'])
          : null,
      teamIds: json['teamIds'] != null
          ? List<String>.from(json['teamIds'])
          : null,
      valid: json['valid'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'role': role,
      'employmentStartDate': employmentStartDate?.toIso8601String(),
      'phone': phone,
      'address': address,
      'note': note,
      'managerId': managerId,
      'companyId': companyId,
      'departmentIds': departmentIds,
      'teamIds': teamIds,
      'valid': valid,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? surname,
    String? email,
    int? role,
    DateTime? employmentStartDate,
    String? phone,
    String? address,
    String? note,
    String? managerId,
    String? companyId,
    List<String>? departmentIds,
    List<String>? teamIds,
    bool? valid,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      role: role ?? this.role,
      employmentStartDate: employmentStartDate ?? this.employmentStartDate,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      note: note ?? this.note,
      managerId: managerId ?? this.managerId,
      companyId: companyId ?? this.companyId,
      departmentIds: departmentIds ?? this.departmentIds,
      teamIds: teamIds ?? this.teamIds,
      valid: valid ?? this.valid,
    );
  }

  String get fullName => '${name ?? ''} ${surname ?? ''}'.trim();

  bool get isActive => valid ?? false;

  String get roleText {
    switch (role) {
      case 0:
        return 'Personel';
      case 1:
        return 'Manager';
      case 2:
        return 'Hr';
      case 3:
        return 'SuperUser';
      default:
        return 'Bilinmiyor';
    }
  }
}
