import 'package:equatable/equatable.dart';

/// Company domain entity
class Company extends Equatable {
  final String id;
  final String name;
  final bool isValid;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Company({
    required this.id,
    required this.name,
    this.isValid = true,
    this.createdAt,
    this.updatedAt,
  });

  Company copyWith({
    String? id,
    String? name,
    bool? isValid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      isValid: isValid ?? this.isValid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, isValid, createdAt, updatedAt];
}
