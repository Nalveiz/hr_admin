import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/errors/exceptions.dart';
import '../services/user_service.dart' as data_service;
import '../models/user_model.dart';

/// User repository implementation
class UserRepositoryImpl implements UserRepository {
  final data_service.UserApiService _userService;

  UserRepositoryImpl(this._userService);

  @override
  Future<Result<List<UserEntity>>> getUsers({
    String? name,
    String? email,
    UserRoleEntity? role,
    String? companyId,
    int? pageNumber,
    int? pageSize,
  }) async {
    try {
      print('🔍 UserRepositoryImpl: getUsers called');

      final params = UserFilterParams(
        name: name,
        email: email,
        role: role?.value.toString(),
        companyId: companyId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      final response = await _userService.getUsers(params);
      print(
        '🔍 UserRepositoryImpl: Service response - isSuccess: ${response.isSuccess}',
      );

      if (response.isSuccess && response.data != null) {
        final entities = response.data!
            .map((model) => model.toEntity())
            .toList();
        print(
          '🔍 UserRepositoryImpl: Converted ${entities.length} models to entities',
        );
        return Result.success(entities);
      } else {
        print(
          '🔍 UserRepositoryImpl: Service returned error: ${response.message}',
        );
        return Result.failure(
          BusinessException(
            message: response.message ?? 'Failed to fetch users',
          ),
        );
      }
    } catch (e) {
      print('🔍 UserRepositoryImpl: Exception caught: $e');
      return Result.failure(BusinessException(message: e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> getUserById(String id) async {
    try {
      final response = await _userService.getUserById(id);

      if (response.isSuccess && response.data != null) {
        return Result.success(response.data!.toEntity());
      } else {
        return Result.failure(
          BusinessException(message: response.message ?? 'User not found'),
        );
      }
    } catch (e) {
      return Result.failure(BusinessException(message: e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> getUserByEmail(String email) async {
    try {
      final response = await _userService.getUserByEmail(email);

      if (response.isSuccess && response.data != null) {
        return Result.success(response.data!.toEntity());
      } else {
        return Result.failure(
          BusinessException(message: response.message ?? 'User not found'),
        );
      }
    } catch (e) {
      return Result.failure(BusinessException(message: e.toString()));
    }
  }

  @override
  Future<Result<List<UserEntity>>> getUsersByCompany(String companyId) async {
    try {
      final response = await _userService.getUsersByCompany(companyId);

      if (response.isSuccess && response.data != null) {
        final entities = response.data!
            .map((model) => model.toEntity())
            .toList();
        return Result.success(entities);
      } else {
        return Result.failure(
          BusinessException(
            message: response.message ?? 'Failed to fetch users by company',
          ),
        );
      }
    } catch (e) {
      return Result.failure(BusinessException(message: e.toString()));
    }
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
    try {
      final createDto = CreateUserDto(
        name: name,
        surname: surname,
        email: email,
        role: _mapToDataRole(role),
        companyId: companyId,
        employmentStartDate: employmentStartDate,
        phone: phone,
        address: address,
        note: note,
        managerId: managerId,
        departmentIds: departmentIds,
        teamIds: teamIds,
      );

      final response = await _userService.createUser(createDto);

      if (response.isSuccess && response.data != null) {
        return Result.success(response.data!.toEntity());
      } else {
        return Result.failure(
          BusinessException(
            message: response.message ?? 'Failed to create user',
          ),
        );
      }
    } catch (e) {
      return Result.failure(BusinessException(message: e.toString()));
    }
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
    try {
      final updateDto = UpdateUserDto(
        name: name,
        surname: surname,
        email: email,
        role: _mapToDataRole(role),
        companyId: companyId,
        employmentStartDate: employmentStartDate,
        phone: phone,
        address: address,
        note: note,
        managerId: managerId,
        departmentIds: departmentIds ?? [],
        teamIds: teamIds ?? [],
      );

      final response = await _userService.updateUser(id, updateDto);

      if (response.isSuccess && response.data != null) {
        return Result.success(response.data!.toEntity());
      } else {
        return Result.failure(
          BusinessException(
            message: response.message ?? 'Failed to update user',
          ),
        );
      }
    } catch (e) {
      return Result.failure(BusinessException(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteUser(String id) async {
    try {
      final response = await _userService.deleteUser(id);

      if (response.isSuccess) {
        return Result.success(null);
      } else {
        return Result.failure(
          BusinessException(
            message: response.message ?? 'Failed to delete user',
          ),
        );
      }
    } catch (e) {
      return Result.failure(BusinessException(message: e.toString()));
    }
  }

  @override
  Future<Result<List<UserEntity>>> searchUsers(String searchTerm) async {
    try {
      final params = UserFilterParams(name: searchTerm);
      final response = await _userService.getUsers(params);

      if (response.isSuccess && response.data != null) {
        final entities = response.data!
            .map((model) => model.toEntity())
            .toList();
        return Result.success(entities);
      } else {
        return Result.failure(
          BusinessException(message: response.message ?? 'Search failed'),
        );
      }
    } catch (e) {
      return Result.failure(BusinessException(message: e.toString()));
    }
  }

  @override
  Future<Result<List<UserEntity>>> getUsersByRole(UserRoleEntity role) async {
    try {
      final response = await _userService.getUsersByRole(_mapToDataRole(role));

      if (response.isSuccess && response.data != null) {
        final entities = response.data!
            .map((model) => model.toEntity())
            .toList();
        return Result.success(entities);
      } else {
        return Result.failure(
          BusinessException(
            message: response.message ?? 'Failed to fetch users by role',
          ),
        );
      }
    } catch (e) {
      return Result.failure(BusinessException(message: e.toString()));
    }
  }

  @override
  Future<Result<List<UserEntity>>> getManagers() async {
    try {
      final response = await _userService.getManagers();

      if (response.isSuccess && response.data != null) {
        final entities = response.data!
            .map((model) => model.toEntity())
            .toList();
        return Result.success(entities);
      } else {
        return Result.failure(
          BusinessException(
            message: response.message ?? 'Failed to fetch managers',
          ),
        );
      }
    } catch (e) {
      return Result.failure(BusinessException(message: e.toString()));
    }
  }

  @override
  Future<Result<List<UserEntity>>> getHRUsers() async {
    try {
      final response = await _userService.getHRUsers();

      if (response.isSuccess && response.data != null) {
        final entities = response.data!
            .map((model) => model.toEntity())
            .toList();
        return Result.success(entities);
      } else {
        return Result.failure(
          BusinessException(
            message: response.message ?? 'Failed to fetch HR users',
          ),
        );
      }
    } catch (e) {
      return Result.failure(BusinessException(message: e.toString()));
    }
  }

  /// Convert entity role to data role
  UserRole _mapToDataRole(UserRoleEntity role) {
    switch (role) {
      case UserRoleEntity.personel:
        return UserRole.Personel;
      case UserRoleEntity.manager:
        return UserRole.Manager;
      case UserRoleEntity.hr:
        return UserRole.HR;
      case UserRoleEntity.superUser:
        return UserRole.SuperUser;
    }
  }
}
