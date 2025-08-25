import 'package:equatable/equatable.dart';
import '../../domain/entities/department.dart';

/// Base state for departments
abstract class DepartmentsState extends Equatable {
  const DepartmentsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class DepartmentsInitial extends DepartmentsState {}

/// Loading state
class DepartmentsLoading extends DepartmentsState {}

/// Success state with departments list
class DepartmentsLoaded extends DepartmentsState {
  final List<Department> departments;
  final String? message;

  const DepartmentsLoaded({required this.departments, this.message});

  @override
  List<Object?> get props => [departments, message];
}

/// Error state
class DepartmentsError extends DepartmentsState {
  final String message;

  const DepartmentsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Department creation loading
class DepartmentCreating extends DepartmentsState {}

/// Department creation success
class DepartmentCreated extends DepartmentsState {
  final Department department;
  final String message;

  const DepartmentCreated({required this.department, required this.message});

  @override
  List<Object?> get props => [department, message];
}

/// Department update loading
class DepartmentUpdating extends DepartmentsState {}

/// Department update success
class DepartmentUpdated extends DepartmentsState {
  final Department department;
  final String message;

  const DepartmentUpdated({required this.department, required this.message});

  @override
  List<Object?> get props => [department, message];
}

/// Department deletion loading
class DepartmentDeleting extends DepartmentsState {}

/// Department deletion success
class DepartmentDeleted extends DepartmentsState {
  final String message;

  const DepartmentDeleted(this.message);

  @override
  List<Object?> get props => [message];
}

/// Department detail loading
class DepartmentDetailLoading extends DepartmentsState {}

/// Department detail loaded
class DepartmentDetailLoaded extends DepartmentsState {
  final Department department;
  final List<Map<String, dynamic>>? users;

  const DepartmentDetailLoaded({required this.department, this.users});

  @override
  List<Object?> get props => [department, users];
}

/// Department status updating
class DepartmentStatusUpdating extends DepartmentsState {}

/// Department status updated
class DepartmentStatusUpdated extends DepartmentsState {
  final Department department;
  final String message;

  const DepartmentStatusUpdated({
    required this.department,
    required this.message,
  });

  @override
  List<Object?> get props => [department, message];
}
