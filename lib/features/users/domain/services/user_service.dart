import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/errors/exceptions.dart';

/// User service interface for business logic
abstract class UserService {
  /// Get all users with optional filtering
  Future<Result<List<UserEntity>>> getUsers({
    String? searchTerm,
    UserRoleEntity? role,
    String? companyId,
    int? pageNumber,
    int? pageSize,
  });

  /// Get user by ID
  Future<Result<UserEntity>> getUserById(String id);

  /// Create user with validation
  Future<Result<UserEntity>> createUser({
    required String name,
    required String surname,
    required String email,
    required UserRoleEntity role,
    required String companyId,
    DateTime? employmentStartDate,
    String? phone,
    String? address,
    String? note,
    String? managerId,
    List<String> departmentIds = const [],
    List<String> teamIds = const [],
  });

  /// Update user with validation
  Future<Result<UserEntity>> updateUser({
    required String id,
    required String name,
    required String surname,
    required String email,
    required UserRoleEntity role,
    required String companyId,
    DateTime? employmentStartDate,
    String? phone,
    String? address,
    String? note,
    String? managerId,
    List<String>? departmentIds,
    List<String>? teamIds,
  });

  /// Delete user with validation
  Future<Result<void>> deleteUser(String id);

  /// Search users
  Future<Result<List<UserEntity>>> searchUsers(String searchTerm);

  /// Get users by role
  Future<Result<List<UserEntity>>> getUsersByRole(UserRoleEntity role);

  /// Get managers
  Future<Result<List<UserEntity>>> getManagers();

  /// Get HR users
  Future<Result<List<UserEntity>>> getHRUsers();
}

/// Concrete implementation of UserService
class UserServiceImpl implements UserService {
  final UserRepository _repository;

  UserServiceImpl(this._repository);

  @override
  Future<Result<List<UserEntity>>> getUsers({
    String? searchTerm,
    UserRoleEntity? role,
    String? companyId,
    int? pageNumber,
    int? pageSize,
  }) async {
    try {
      return await _repository.getUsers(
        role: role,
        companyId: companyId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
    } catch (e) {
      return Result.failure(BusinessException(message: e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> getUserById(String id) async {
    if (id.isEmpty) {
      return Result.failure(
        const ValidationException(message: 'User ID cannot be empty'),
      );
    }
    return await _repository.getUserById(id);
  }

  @override
  Future<Result<UserEntity>> createUser({
    required String name,
    required String surname,
    required String email,
    required UserRoleEntity role,
    required String companyId,
    DateTime? employmentStartDate,
    String? phone,
    String? address,
    String? note,
    String? managerId,
    List<String> departmentIds = const [],
    List<String> teamIds = const [],
  }) async {
    // Validation
    if (name.trim().isEmpty) {
      return Result.failure(
        const ValidationException(message: 'Name is required'),
      );
    }
    if (surname.trim().isEmpty) {
      return Result.failure(
        const ValidationException(message: 'Surname is required'),
      );
    }
    if (email.trim().isEmpty) {
      return Result.failure(
        const ValidationException(message: 'Email is required'),
      );
    }
    if (!_isValidEmail(email)) {
      return Result.failure(
        const ValidationException(message: 'Invalid email format'),
      );
    }
    if (companyId.trim().isEmpty) {
      return Result.failure(
        const ValidationException(message: 'Company ID is required'),
      );
    }

    return await _repository.createUser(
      name: name.trim(),
      surname: surname.trim(),
      email: email.trim(),
      role: role,
      companyId: companyId.trim(),
      employmentStartDate: employmentStartDate,
      phone: phone?.trim(),
      address: address?.trim(),
      note: note?.trim(),
      managerId: managerId?.trim(),
      departmentIds: departmentIds,
      teamIds: teamIds,
    );
  }

  @override
  Future<Result<UserEntity>> updateUser({
    required String id,
    required String name,
    required String surname,
    required String email,
    required UserRoleEntity role,
    required String companyId,
    DateTime? employmentStartDate,
    String? phone,
    String? address,
    String? note,
    String? managerId,
    List<String>? departmentIds,
    List<String>? teamIds,
  }) async {
    // Validation
    if (id.trim().isEmpty) {
      return Result.failure(
        const ValidationException(message: 'User ID is required'),
      );
    }
    if (name.trim().isEmpty) {
      return Result.failure(
        const ValidationException(message: 'Name is required'),
      );
    }
    if (surname.trim().isEmpty) {
      return Result.failure(
        const ValidationException(message: 'Surname is required'),
      );
    }
    if (email.trim().isEmpty) {
      return Result.failure(
        const ValidationException(message: 'Email is required'),
      );
    }
    if (!_isValidEmail(email)) {
      return Result.failure(
        const ValidationException(message: 'Invalid email format'),
      );
    }

    return await _repository.updateUser(
      id: id.trim(),
      name: name.trim(),
      surname: surname.trim(),
      email: email.trim(),
      role: role,
      companyId: companyId.trim(),
      employmentStartDate: employmentStartDate,
      phone: phone?.trim(),
      address: address?.trim(),
      note: note?.trim(),
      managerId: managerId?.trim(),
      departmentIds: departmentIds ?? [],
      teamIds: teamIds ?? [],
    );
  }

  @override
  Future<Result<void>> deleteUser(String id) async {
    if (id.trim().isEmpty) {
      return Result.failure(
        const ValidationException(message: 'User ID cannot be empty'),
      );
    }
    return await _repository.deleteUser(id.trim());
  }

  @override
  Future<Result<List<UserEntity>>> searchUsers(String searchTerm) async {
    if (searchTerm.trim().isEmpty) {
      return Result.failure(
        const ValidationException(message: 'Search term cannot be empty'),
      );
    }
    return await _repository.searchUsers(searchTerm.trim());
  }

  @override
  Future<Result<List<UserEntity>>> getUsersByRole(UserRoleEntity role) async {
    return await _repository.getUsersByRole(role);
  }

  @override
  Future<Result<List<UserEntity>>> getManagers() async {
    return await _repository.getManagers();
  }

  @override
  Future<Result<List<UserEntity>>> getHRUsers() async {
    return await _repository.getHRUsers();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
