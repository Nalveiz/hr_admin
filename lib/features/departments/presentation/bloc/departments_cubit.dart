import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_admin/core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/department_model.dart';
import '../../data/services/department_service.dart';
import 'departments_state.dart';

/// Cubit for managing departments
class DepartmentsCubit extends Cubit<DepartmentsState> {
  final DepartmentService _departmentService;

  DepartmentsCubit({
    required SharedPreferences prefs,
    required ErrorHandlingService errorHandlingService,
  }) : _departmentService = DepartmentService(prefs, errorHandlingService),
       super(DepartmentsInitial());

  /// Load all departments
  Future<void> loadDepartments({
    int? page,
    int? limit,
    String? search,
    bool? isActive,
  }) async {
    emit(DepartmentsLoading());

    try {
      ApiResponse<List<DepartmentModel>> response;

      // Eğer arama yapılıyorsa normal endpoint'i kullan, yoksa /all endpoint'ini kullan
      if (search != null && search.isNotEmpty) {
        response = await _departmentService.getDepartments(
          page: page,
          limit: limit,
          search: search,
          isActive: isActive,
        );
      } else {
        response = await _departmentService.getAllDepartments();
      }

      if (response.success && response.data != null) {
        final departments = response.data!
            .map((model) => model.toEntity())
            .toList();
        emit(
          DepartmentsLoaded(
            departments: departments,
            message: response.message,
          ),
        );
      } else {
        emit(DepartmentsError(response.error ?? 'Failed to load departments'));
      }
    } catch (e) {
      emit(DepartmentsError('Failed to load departments: $e'));
    }
  }

  /// Load department by ID
  Future<void> loadDepartmentById(String id) async {
    emit(DepartmentDetailLoading());

    try {
      final response = await _departmentService.getDepartmentById(id);

      if (response.success && response.data != null) {
        final department = response.data!.toEntity();
        emit(DepartmentDetailLoaded(department: department));
      } else {
        emit(DepartmentsError(response.error ?? 'Failed to load department'));
      }
    } catch (e) {
      emit(DepartmentsError('Failed to load department: $e'));
    }
  }

  /// Load department with users
  Future<void> loadDepartmentWithUsers(String id) async {
    emit(DepartmentDetailLoading());

    try {
      // Load department and users in parallel
      final departmentFuture = _departmentService.getDepartmentById(id);
      final usersFuture = _departmentService.getDepartmentUsers(id);

      final results = await Future.wait([departmentFuture, usersFuture]);
      final departmentResponse = results[0] as dynamic;
      final usersResponse = results[1] as dynamic;

      if (departmentResponse.success && departmentResponse.data != null) {
        final department = departmentResponse.data!.toEntity();
        final users = usersResponse.success ? usersResponse.data : null;

        emit(DepartmentDetailLoaded(department: department, users: users));
      } else {
        emit(
          DepartmentsError(
            departmentResponse.error ?? 'Failed to load department',
          ),
        );
      }
    } catch (e) {
      emit(DepartmentsError('Failed to load department: $e'));
    }
  }

  /// Create new department
  Future<void> createDepartment({
    required String name,
    String? description,
    String? managerId,
    String? budget,
    bool isActive = true,
  }) async {
    emit(DepartmentCreating());

    try {
      final departmentModel = DepartmentModel(
        id: '', // Will be assigned by server
        name: name,
        description: description,
        managerId: managerId,
        employeeCount: 0,
        budget: budget,
        isActive: isActive,
        createdAt: DateTime.now(),
      );

      final response = await _departmentService.createDepartment(
        departmentModel,
      );

      if (response.success && response.data != null) {
        final department = response.data!.toEntity();
        emit(
          DepartmentCreated(
            department: department,
            message: response.message ?? 'Department created successfully',
          ),
        );
      } else {
        emit(DepartmentsError(response.error ?? 'Failed to create department'));
      }
    } catch (e) {
      emit(DepartmentsError('Failed to create department: $e'));
    }
  }

  /// Update department
  Future<void> updateDepartment({
    required String id,
    required String name,
    String? description,
    String? managerId,
    String? budget,
    bool? isActive,
  }) async {
    emit(DepartmentUpdating());

    try {
      final departmentModel = DepartmentModel(
        id: id,
        name: name,
        description: description,
        managerId: managerId,
        employeeCount: 0, // Will be recalculated by server
        budget: budget,
        isActive: isActive ?? true,
        createdAt: DateTime.now(), // Will be ignored by server
        updatedAt: DateTime.now(),
      );

      final response = await _departmentService.updateDepartment(
        id,
        departmentModel,
      );

      if (response.success && response.data != null) {
        final department = response.data!.toEntity();
        emit(
          DepartmentUpdated(
            department: department,
            message: response.message ?? 'Department updated successfully',
          ),
        );
      } else {
        emit(DepartmentsError(response.error ?? 'Failed to update department'));
      }
    } catch (e) {
      emit(DepartmentsError('Failed to update department: $e'));
    }
  }

  /// Delete department
  Future<void> deleteDepartment(String id) async {
    emit(DepartmentDeleting());

    try {
      final response = await _departmentService.deleteDepartment(id);

      if (response.success) {
        emit(
          DepartmentDeleted(
            response.message ?? 'Department deleted successfully',
          ),
        );
      } else {
        emit(DepartmentsError(response.error ?? 'Failed to delete department'));
      }
    } catch (e) {
      emit(DepartmentsError('Failed to delete department: $e'));
    }
  }

  /// Toggle department status (active/inactive)
  Future<void> toggleDepartmentStatus(String id, bool isActive) async {
    emit(DepartmentStatusUpdating());

    try {
      final response = await _departmentService.toggleDepartmentStatus(
        id,
        isActive,
      );

      if (response.success && response.data != null) {
        final department = response.data!.toEntity();
        emit(
          DepartmentStatusUpdated(
            department: department,
            message:
                response.message ?? 'Department status updated successfully',
          ),
        );
      } else {
        emit(
          DepartmentsError(
            response.error ?? 'Failed to update department status',
          ),
        );
      }
    } catch (e) {
      emit(DepartmentsError('Failed to update department status: $e'));
    }
  }

  /// Assign manager to department
  Future<void> assignManager(String departmentId, String managerId) async {
    emit(DepartmentUpdating());

    try {
      final response = await _departmentService.assignManager(
        departmentId,
        managerId,
      );

      if (response.success && response.data != null) {
        final department = response.data!.toEntity();
        emit(
          DepartmentUpdated(
            department: department,
            message: response.message ?? 'Manager assigned successfully',
          ),
        );
      } else {
        emit(DepartmentsError(response.error ?? 'Failed to assign manager'));
      }
    } catch (e) {
      emit(DepartmentsError('Failed to assign manager: $e'));
    }
  }

  /// Refresh departments list
  Future<void> refreshDepartments() async {
    await loadDepartments();
  }
}
