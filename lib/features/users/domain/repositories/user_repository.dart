import '../entities/user_entity.dart';
import '../../../../core/errors/result.dart';

/// User repository interface
abstract class UserRepository {
  /// Get all users with optional filtering
  Future<Result<List<UserEntity>>> getUsers({
    String? name,
    String? email,
    UserRoleEntity? role,
    String? companyId,
    int? pageNumber,
    int? pageSize,
  });

  /// Get user by ID
  Future<Result<UserEntity>> getUserById(String id);

  /// Get user by email
  Future<Result<UserEntity>> getUserByEmail(String email);

  /// Get users by role
  Future<Result<List<UserEntity>>> getUsersByRole(UserRoleEntity role);

  /// Get users by company
  Future<Result<List<UserEntity>>> getUsersByCompany(String companyId);

  /// Get managers
  Future<Result<List<UserEntity>>> getManagers();

  /// Get HR users
  Future<Result<List<UserEntity>>> getHRUsers();

  /// Search users
  Future<Result<List<UserEntity>>> searchUsers(String searchTerm);

  /// Create user
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

  /// Update user
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

  /// Delete user
  Future<Result<void>> deleteUser(String id);
}
