import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/services/user_service.dart';

// States
abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<UserEntity> users;
  final List<UserEntity> filteredUsers;

  const UsersLoaded({required this.users, required this.filteredUsers});

  UsersLoaded copyWith({
    List<UserEntity>? users,
    List<UserEntity>? filteredUsers,
  }) {
    return UsersLoaded(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
    );
  }

  @override
  List<Object?> get props => [users, filteredUsers];
}

class UsersError extends UsersState {
  final String message;

  const UsersError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserCreated extends UsersState {
  final UserEntity user;

  const UserCreated(this.user);

  @override
  List<Object?> get props => [user];
}

class UserUpdated extends UsersState {
  final UserEntity user;

  const UserUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class UserDeleted extends UsersState {
  final String userId;

  const UserDeleted(this.userId);

  @override
  List<Object?> get props => [userId];
}

// Cubit
class UsersCubit extends Cubit<UsersState> {
  final UserService _userService;
  List<UserEntity> _allUsers = [];

  UsersCubit(this._userService) : super(UsersInitial());

  /// Fetch all users
  Future<void> fetchUsers({
    String? searchTerm,
    UserRoleEntity? role,
    String? companyId,
    int? pageNumber,
    int? pageSize,
  }) async {
    print(
      '🔍 UsersCubit: fetchUsers called with searchTerm: $searchTerm, role: $role, companyId: $companyId',
    );
    try {
      print('🔍 UsersCubit: Emitting UsersLoading state');
      emit(UsersLoading());

      print('🔍 UsersCubit: Calling _userService.getUsers');
      final result = await _userService.getUsers(
        searchTerm: searchTerm,
        role: role,
        companyId: companyId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      print(
        '🔍 UsersCubit: Service result - isSuccess: ${result.isSuccess}, data length: ${result.isSuccess ? result.data?.length : 'N/A'}, errorMessage: ${result.exception?.message}',
      );

      if (result.isSuccess && result.data != null) {
        _allUsers = result.data!;
        print(
          '🔍 UsersCubit: Emitting UsersLoaded with ${_allUsers.length} users',
        );
        emit(UsersLoaded(users: _allUsers, filteredUsers: _allUsers));
      } else {
        print(
          '🔍 UsersCubit: Emitting UsersError - ${result.exception?.message}',
        );
        emit(
          UsersError(
            result.exception?.message ?? 'Kullanıcılar yüklenirken hata oluştu',
          ),
        );
      }
    } catch (e) {
      print('🔍 UsersCubit: Exception caught: $e');
      emit(UsersError('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Get user by ID
  Future<void> getUserById(String id) async {
    try {
      emit(UsersLoading());

      final result = await _userService.getUserById(id);

      if (result.isSuccess && result.data != null) {
        emit(UsersLoaded(users: [result.data!], filteredUsers: [result.data!]));
      } else {
        emit(UsersError(result.exception?.message ?? 'Kullanıcı bulunamadı'));
      }
    } catch (e) {
      emit(UsersError('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Get users by role
  Future<void> getUsersByRole(UserRoleEntity role) async {
    try {
      emit(UsersLoading());

      final result = await _userService.getUsersByRole(role);

      if (result.isSuccess && result.data != null) {
        _allUsers = result.data!;
        emit(UsersLoaded(users: _allUsers, filteredUsers: _allUsers));
      } else {
        emit(
          UsersError(
            result.exception?.message ??
                'Rol bazlı kullanıcılar yüklenirken hata oluştu',
          ),
        );
      }
    } catch (e) {
      emit(UsersError('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Get managers
  Future<void> getManagers() async {
    try {
      emit(UsersLoading());

      final result = await _userService.getManagers();

      if (result.isSuccess && result.data != null) {
        _allUsers = result.data!;
        emit(UsersLoaded(users: _allUsers, filteredUsers: _allUsers));
      } else {
        emit(
          UsersError(
            result.exception?.message ?? 'Yöneticiler yüklenirken hata oluştu',
          ),
        );
      }
    } catch (e) {
      emit(UsersError('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Get HR users
  Future<void> getHRUsers() async {
    try {
      emit(UsersLoading());

      final result = await _userService.getHRUsers();

      if (result.isSuccess && result.data != null) {
        _allUsers = result.data!;
        emit(UsersLoaded(users: _allUsers, filteredUsers: _allUsers));
      } else {
        emit(
          UsersError(
            result.exception?.message ??
                'İK kullanıcıları yüklenirken hata oluştu',
          ),
        );
      }
    } catch (e) {
      emit(UsersError('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Search users
  void searchUsers({
    String? searchTerm,
    UserRoleEntity? role,
    String? companyId,
  }) {
    final currentState = state;
    if (currentState is UsersLoaded) {
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
    List<String> departmentIds = const [],
    List<String> teamIds = const [],
  }) async {
    try {
      emit(UsersLoading());

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
        emit(UserCreated(result.data!));
        // Refresh the list
        await fetchUsers();
      } else {
        emit(
          UsersError(result.exception?.message ?? 'Kullanıcı oluşturulamadı'),
        );
      }
    } catch (e) {
      emit(UsersError('Beklenmeyen bir hata oluştu: $e'));
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
      emit(UsersLoading());

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
        emit(UserUpdated(result.data!));
        // Refresh the list
        await fetchUsers();
      } else {
        emit(
          UsersError(result.exception?.message ?? 'Kullanıcı güncellenemedi'),
        );
      }
    } catch (e) {
      emit(UsersError('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Delete user
  Future<void> deleteUser(String id) async {
    try {
      emit(UsersLoading());

      final result = await _userService.deleteUser(id);

      if (result.isSuccess) {
        emit(UserDeleted(id));
        // Refresh the list
        await fetchUsers();
      } else {
        emit(UsersError(result.exception?.message ?? 'Kullanıcı silinemedi'));
      }
    } catch (e) {
      emit(UsersError('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  /// Clear search and show all users
  void clearSearch() {
    final currentState = state;
    if (currentState is UsersLoaded) {
      emit(currentState.copyWith(filteredUsers: currentState.users));
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    await fetchUsers();
  }
}
