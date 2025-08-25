import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hr_admin/features/users/data/models/user_model_new.dart';
import 'package:hr_admin/features/users/data/services/user_service_new.dart';

// States
abstract class UsersStateNew extends Equatable {
  const UsersStateNew();

  @override
  List<Object?> get props => [];
}

class UsersInitialNew extends UsersStateNew {}

class UsersLoadingNew extends UsersStateNew {}

class UsersLoadedNew extends UsersStateNew {
  final List<UserModelNew> users;
  final List<UserModelNew> filteredUsers;

  const UsersLoadedNew({required this.users, required this.filteredUsers});

  UsersLoadedNew copyWith({
    List<UserModelNew>? users,
    List<UserModelNew>? filteredUsers,
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
  final UserModelNew user;

  const UserCreatedNew(this.user);

  @override
  List<Object?> get props => [user];
}

class UserUpdatedNew extends UsersStateNew {
  final UserModelNew user;

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
  final UserServiceNew _userService;
  List<UserModelNew> _allUsers = [];

  UsersCubitNew(this._userService) : super(UsersInitialNew());

  /// Fetch all users
  Future<void> fetchUsers([UserFilterParams? params]) async {
    print('🔍 UsersCubitNew: fetchUsers called with params: $params');
    try {
      print('🔍 UsersCubitNew: Emitting UsersLoadingNew state');
      emit(UsersLoadingNew());

      print('🔍 UsersCubitNew: Calling _userService.getUsers');
      final response = await _userService.getUsers(params);
      print('🔍 UsersCubitNew: Service response - isSuccess: ${response.isSuccess}, data length: ${response.data?.length}, message: ${response.message}');

      if (response.isSuccess && response.data != null) {
        _allUsers = response.data!;
        print('🔍 UsersCubitNew: Emitting UsersLoadedNew with ${_allUsers.length} users');
        emit(UsersLoadedNew(users: _allUsers, filteredUsers: _allUsers));
      } else {
        print('🔍 UsersCubitNew: Emitting UsersErrorNew - ${response.message}');
        emit(
          UsersErrorNew(
            response.message ?? 'Kullanıcılar yüklenirken hata oluştu',
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

      final response = await _userService.getUserById(id);

      if (response.isSuccess && response.data != null) {
        // You can handle single user result here
        emit(
          UsersLoadedNew(
            users: [response.data!],
            filteredUsers: [response.data!],
          ),
        );
      } else {
        emit(UsersErrorNew(response.message ?? 'Kullanıcı bulunamadı'));
      }
    } catch (e) {
      emit(UsersErrorNew('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Get users by role
  Future<void> getUsersByRole(UserRole role) async {
    try {
      emit(UsersLoadingNew());

      final response = await _userService.getUsersByRole(role);

      if (response.isSuccess && response.data != null) {
        _allUsers = response.data!;
        emit(UsersLoadedNew(users: _allUsers, filteredUsers: _allUsers));
      } else {
        emit(
          UsersErrorNew(
            response.message ?? 'Kullanıcılar yüklenirken hata oluştu',
          ),
        );
      }
    } catch (e) {
      emit(UsersErrorNew('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Get users by company
  Future<void> getUsersByCompany(String companyId) async {
    try {
      emit(UsersLoadingNew());

      final response = await _userService.getUsersByCompany(companyId);

      if (response.isSuccess && response.data != null) {
        _allUsers = response.data!;
        emit(UsersLoadedNew(users: _allUsers, filteredUsers: _allUsers));
      } else {
        emit(
          UsersErrorNew(
            response.message ?? 'Kullanıcılar yüklenirken hata oluştu',
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

      final response = await _userService.getManagers();

      if (response.isSuccess && response.data != null) {
        _allUsers = response.data!;
        emit(UsersLoadedNew(users: _allUsers, filteredUsers: _allUsers));
      } else {
        emit(
          UsersErrorNew(
            response.message ?? 'Yöneticiler yüklenirken hata oluştu',
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

      final response = await _userService.getHRUsers();

      if (response.isSuccess && response.data != null) {
        _allUsers = response.data!;
        emit(UsersLoadedNew(users: _allUsers, filteredUsers: _allUsers));
      } else {
        emit(
          UsersErrorNew(
            response.message ?? 'İK kullanıcıları yüklenirken hata oluştu',
          ),
        );
      }
    } catch (e) {
      emit(UsersErrorNew('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Search users with filters
  void searchUsers({String? searchTerm, UserRole? role, String? companyId}) {
    if (state is UsersLoadedNew) {
      final currentState = state as UsersLoadedNew;
      List<UserModelNew> filtered = List.from(currentState.users);

      // Apply search term filter
      if (searchTerm != null && searchTerm.isNotEmpty) {
        filtered = filtered.where((user) {
          final searchLower = searchTerm.toLowerCase();
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
      if (companyId != null) {
        filtered = filtered
            .where((user) => user.companyId == companyId)
            .toList();
      }

      emit(currentState.copyWith(filteredUsers: filtered));
    }
  }

  /// Create new user
  Future<void> createUser(CreateUserDto dto) async {
    try {
      final response = await _userService.createUser(dto);

      if (response.isSuccess && response.data != null) {
        emit(UserCreatedNew(response.data!));
        // Refresh the list
        await fetchUsers();
      } else {
        emit(
          UsersErrorNew(
            response.message ?? 'Kullanıcı oluşturulurken hata oluştu',
          ),
        );
      }
    } catch (e) {
      emit(UsersErrorNew('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Update user
  Future<void> updateUser(String id, UpdateUserDto dto) async {
    try {
      final response = await _userService.updateUser(id, dto);

      if (response.isSuccess && response.data != null) {
        emit(UserUpdatedNew(response.data!));
        // Refresh the list
        await fetchUsers();
      } else {
        emit(
          UsersErrorNew(
            response.message ?? 'Kullanıcı güncellenirken hata oluştu',
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
      final response = await _userService.deleteUser(id);

      if (response.isSuccess) {
        emit(UserDeletedNew(id));
        // Refresh the list
        await fetchUsers();
      } else {
        emit(
          UsersErrorNew(response.message ?? 'Kullanıcı silinirken hata oluştu'),
        );
      }
    } catch (e) {
      emit(UsersErrorNew('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Refresh users list
  Future<void> refreshUsers() async {
    await fetchUsers();
  }
}
