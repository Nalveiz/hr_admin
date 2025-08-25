import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/services/user_service.dart';

// States
abstract class UsersStateNew extends Equatable {
  const UsersStateNew();

  @override
  List<Object?> get props => [];
}

class UsersInitialNew extends UsersStateNew {}

class UsersLoadingNew extends UsersStateNew {}

class UsersLoadedNew extends UsersStateNew {
  final List<UserEntity> users;
  final List<UserEntity> filteredUsers;

  const UsersLoadedNew({required this.users, required this.filteredUsers});

  UsersLoadedNew copyWith({
    List<UserEntity>? users,
    List<UserEntity>? filteredUsers,
  }) {
    return UsersLoadedNew(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
    );
  }

  @override
  List<Object?> get props => [users, filteredUsers];
}

class UsersErrorNew extends UsersStateNew {
  final String message;

  const UsersErrorNew(this.message);

  @override
  List<Object?> get props => [message];
}

class UserCreatedNew extends UsersStateNew {
  final UserEntity user;

  const UserCreatedNew(this.user);

  @override
  List<Object?> get props => [user];
}

class UserUpdatedNew extends UsersStateNew {
  final UserEntity user;

  const UserUpdatedNew(this.user);

  @override
  List<Object?> get props => [user];
}

class UserDeletedNew extends UsersStateNew {
  final String userId;

  const UserDeletedNew(this.userId);

  @override
  List<Object?> get props => [userId];
}

// Cubit
class UsersCubitNew extends Cubit<UsersStateNew> {
  final UserService _userService;
  List<UserEntity> _allUsers = [];

  UsersCubitNew(this._userService) : super(UsersInitialNew());

  /// Fetch all users
  Future<void> fetchUsers({
    String? searchTerm,
    UserRoleEntity? role,
    String? companyId,
    int? pageNumber,
    int? pageSize,
  }) async {
    print(
      '🔍 UsersCubitNew: fetchUsers called with searchTerm: $searchTerm, role: $role, companyId: $companyId',
    );
    try {
      print('🔍 UsersCubitNew: Emitting UsersLoadingNew state');
      emit(UsersLoadingNew());

      print('🔍 UsersCubitNew: Calling _userService.getUsers');
      final result = await _userService.getUsers(
        searchTerm: searchTerm,
        role: role,
        companyId: companyId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      print(
        '🔍 UsersCubitNew: Service result - isSuccess: ${result.isSuccess}, data length: ${result.isSuccess ? result.data?.length : 'N/A'}, errorMessage: ${result.exception?.message}',
      );

      if (result.isSuccess && result.data != null) {
        _allUsers = result.data!;
        print(
          '🔍 UsersCubitNew: Emitting UsersLoadedNew with ${_allUsers.length} users',
        );
        emit(UsersLoadedNew(users: _allUsers, filteredUsers: _allUsers));
      } else {
        print(
          '🔍 UsersCubitNew: Emitting UsersErrorNew - ${result.exception?.message}',
        );
        emit(
          UsersErrorNew(
            result.exception?.message ?? 'Kullanıcılar yüklenirken hata oluştu',
          ),
        );
      }
    } catch (e) {
      print('🔍 UsersCubitNew: Exception caught: $e');
      emit(UsersErrorNew('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Get user by ID
  Future<void> getUserById(String id) async {
    try {
      emit(UsersLoadingNew());

      final result = await _userService.getUserById(id);

      if (result.isSuccess && result.data != null) {
        emit(
          UsersLoadedNew(users: [result.data!], filteredUsers: [result.data!]),
        );
      } else {
        emit(
          UsersErrorNew(result.exception?.message ?? 'Kullanıcı bulunamadı'),
        );
      }
    } catch (e) {
      emit(UsersErrorNew('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Get users by role
  Future<void> getUsersByRole(UserRoleEntity role) async {
    try {
      emit(UsersLoadingNew());

      final result = await _userService.getUsersByRole(role);

      if (result.isSuccess && result.data != null) {
        _allUsers = result.data!;
        emit(UsersLoadedNew(users: _allUsers, filteredUsers: _allUsers));
      } else {
        emit(
          UsersErrorNew(
            result.exception?.message ??
                'Rol bazlı kullanıcılar yüklenirken hata oluştu',
          ),
        );
      }
    } catch (e) {
      emit(UsersErrorNew('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Get managers
  Future<void> getManagers() async {
    try {
      emit(UsersLoadingNew());

      final result = await _userService.getManagers();

      if (result.isSuccess && result.data != null) {
        _allUsers = result.data!;
        emit(UsersLoadedNew(users: _allUsers, filteredUsers: _allUsers));
      } else {
        emit(
          UsersErrorNew(
            result.exception?.message ?? 'Yöneticiler yüklenirken hata oluştu',
          ),
        );
      }
    } catch (e) {
      emit(UsersErrorNew('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Get HR users
  Future<void> getHRUsers() async {
    try {
      emit(UsersLoadingNew());

      final result = await _userService.getHRUsers();

      if (result.isSuccess && result.data != null) {
        _allUsers = result.data!;
        emit(UsersLoadedNew(users: _allUsers, filteredUsers: _allUsers));
      } else {
        emit(
          UsersErrorNew(
            result.exception?.message ??
                'İK kullanıcıları yüklenirken hata oluştu',
          ),
        );
      }
    } catch (e) {
      emit(UsersErrorNew('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Search users
  void searchUsers({
    String? searchTerm,
    UserRoleEntity? role,
    String? companyId,
  }) {
    final currentState = state;
    if (currentState is UsersLoadedNew) {
      List<UserEntity> filtered = List.from(currentState.users);

      // Apply search term filter
      if (searchTerm != null && searchTerm.isNotEmpty) {
        final searchLower = searchTerm.toLowerCase();
        filtered = filtered.where((user) {
          return user.name.toLowerCase().contains(searchLower) ||
              user.surname.toLowerCase().contains(searchLower) ||
              user.email.toLowerCase().contains(searchLower) ||
              user.fullName.toLowerCase().contains(searchLower);
        }).toList();
      }

      // Apply role filter
      if (role != null) {
        filtered = filtered.where((user) => user.role == role).toList();
      }

      // Apply company filter
      if (companyId != null && companyId.isNotEmpty) {
        filtered = filtered
            .where((user) => user.companyId == companyId)
            .toList();
      }

      emit(currentState.copyWith(filteredUsers: filtered));
    }
  }

  /// Create user
  Future<void> createUser({
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
      emit(UsersLoadingNew());

      final result = await _userService.createUser(
        name: name,
        surname: surname,
        email: email,
        role: role,
        companyId: companyId,
        employmentStartDate: employmentStartDate,
        phone: phone,
        address: address,
        note: note,
        managerId: managerId,
        departmentIds: departmentIds,
        teamIds: teamIds,
      );

      if (result.isSuccess && result.data != null) {
        emit(UserCreatedNew(result.data!));
        // Refresh the list
        await fetchUsers();
      } else {
        emit(
          UsersErrorNew(
            result.exception?.message ?? 'Kullanıcı oluşturulamadı',
          ),
        );
      }
    } catch (e) {
      emit(UsersErrorNew('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Update user
  Future<void> updateUser({
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
      emit(UsersLoadingNew());

      final result = await _userService.updateUser(
        id: id,
        name: name,
        surname: surname,
        email: email,
        role: role,
        companyId: companyId,
        employmentStartDate: employmentStartDate,
        phone: phone,
        address: address,
        note: note,
        managerId: managerId,
        departmentIds: departmentIds,
        teamIds: teamIds,
      );

      if (result.isSuccess && result.data != null) {
        emit(UserUpdatedNew(result.data!));
        // Refresh the list
        await fetchUsers();
      } else {
        emit(
          UsersErrorNew(
            result.exception?.message ?? 'Kullanıcı güncellenemedi',
          ),
        );
      }
    } catch (e) {
      emit(UsersErrorNew('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Delete user
  Future<void> deleteUser(String id) async {
    try {
      emit(UsersLoadingNew());

      final result = await _userService.deleteUser(id);

      if (result.isSuccess) {
        emit(UserDeletedNew(id));
        // Refresh the list
        await fetchUsers();
      } else {
        emit(
          UsersErrorNew(result.exception?.message ?? 'Kullanıcı silinemedi'),
        );
      }
    } catch (e) {
      emit(UsersErrorNew('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Clear search and show all users
  void clearSearch() {
    final currentState = state;
    if (currentState is UsersLoadedNew) {
      emit(currentState.copyWith(filteredUsers: currentState.users));
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    await fetchUsers();
  }
}
