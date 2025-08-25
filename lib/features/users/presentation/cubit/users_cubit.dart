import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/services/user_service.dart';
import '../../data/models/user_dto.dart';
import '../../domain/entities/user.dart';

// States
abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<User> users;
  final bool hasReachedMax;

  const UsersLoaded({this.users = const [], this.hasReachedMax = false});

  UsersLoaded copyWith({List<User>? users, bool? hasReachedMax}) {
    return UsersLoaded(
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [users, hasReachedMax];
}

class UsersError extends UsersState {
  final String message;

  const UsersError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserCreated extends UsersState {
  final User user;

  const UserCreated(this.user);

  @override
  List<Object?> get props => [user];
}

class UserUpdated extends UsersState {
  final User user;

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

// Events
abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends UsersEvent {
  final UserFilterParams? filters;

  const LoadUsers({this.filters});

  @override
  List<Object?> get props => [filters];
}

class RefreshUsers extends UsersEvent {
  final UserFilterParams? filters;

  const RefreshUsers({this.filters});

  @override
  List<Object?> get props => [filters];
}

class LoadUserById extends UsersEvent {
  final String id;

  const LoadUserById(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadUsersByRole extends UsersEvent {
  final int role;

  const LoadUsersByRole(this.role);

  @override
  List<Object?> get props => [role];
}

class LoadUsersByCompany extends UsersEvent {
  final String companyId;

  const LoadUsersByCompany(this.companyId);

  @override
  List<Object?> get props => [companyId];
}

class LoadManagers extends UsersEvent {}

class LoadHrUsers extends UsersEvent {}

class SearchUsers extends UsersEvent {
  final String searchTerm;

  const SearchUsers(this.searchTerm);

  @override
  List<Object?> get props => [searchTerm];
}

class CreateUser extends UsersEvent {
  final CreateUserDto dto;

  const CreateUser(this.dto);

  @override
  List<Object?> get props => [dto];
}

class UpdateUser extends UsersEvent {
  final String id;
  final UpdateUserDto dto;

  const UpdateUser(this.id, this.dto);

  @override
  List<Object?> get props => [id, dto];
}

class DeleteUser extends UsersEvent {
  final String id;

  const DeleteUser(this.id);

  @override
  List<Object?> get props => [id];
}

// Cubit
class UsersCubit extends Bloc<UsersEvent, UsersState> {
  final UserService _userService;

  UsersCubit(this._userService) : super(UsersInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<RefreshUsers>(_onRefreshUsers);
    on<LoadUserById>(_onLoadUserById);
    on<LoadUsersByRole>(_onLoadUsersByRole);
    on<LoadUsersByCompany>(_onLoadUsersByCompany);
    on<LoadManagers>(_onLoadManagers);
    on<LoadHrUsers>(_onLoadHrUsers);
    on<SearchUsers>(_onSearchUsers);
    on<CreateUser>(_onCreateUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UsersState> emit) async {
    try {
      emit(UsersLoading());
      final users = await _userService.getUsers(filters: event.filters);
      emit(UsersLoaded(users: users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onRefreshUsers(
    RefreshUsers event,
    Emitter<UsersState> emit,
  ) async {
    try {
      final users = await _userService.getUsers(filters: event.filters);
      emit(UsersLoaded(users: users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onLoadUserById(
    LoadUserById event,
    Emitter<UsersState> emit,
  ) async {
    try {
      emit(UsersLoading());
      final user = await _userService.getUserById(event.id);
      if (user != null) {
        emit(UsersLoaded(users: [user]));
      } else {
        emit(const UsersError('Kullanıcı bulunamadı'));
      }
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onLoadUsersByRole(
    LoadUsersByRole event,
    Emitter<UsersState> emit,
  ) async {
    try {
      emit(UsersLoading());
      final users = await _userService.getUsersByRole(event.role);
      emit(UsersLoaded(users: users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onLoadUsersByCompany(
    LoadUsersByCompany event,
    Emitter<UsersState> emit,
  ) async {
    try {
      emit(UsersLoading());
      final users = await _userService.getUsersByCompany(event.companyId);
      emit(UsersLoaded(users: users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onLoadManagers(
    LoadManagers event,
    Emitter<UsersState> emit,
  ) async {
    try {
      emit(UsersLoading());
      final users = await _userService.getManagers();
      emit(UsersLoaded(users: users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onLoadHrUsers(
    LoadHrUsers event,
    Emitter<UsersState> emit,
  ) async {
    try {
      emit(UsersLoading());
      final users = await _userService.getHrUsers();
      emit(UsersLoaded(users: users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onSearchUsers(
    SearchUsers event,
    Emitter<UsersState> emit,
  ) async {
    try {
      emit(UsersLoading());
      final users = await _userService.searchUsers(event.searchTerm);
      emit(UsersLoaded(users: users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onCreateUser(CreateUser event, Emitter<UsersState> emit) async {
    try {
      final user = await _userService.createUser(event.dto);
      emit(UserCreated(user));
      // Reload users after creation
      add(const LoadUsers());
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UsersState> emit) async {
    try {
      final user = await _userService.updateUser(event.id, event.dto);
      emit(UserUpdated(user));
      // Reload users after update
      add(const LoadUsers());
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<UsersState> emit) async {
    try {
      await _userService.deleteUser(event.id);
      emit(UserDeleted(event.id));
      // Reload users after deletion
      add(const LoadUsers());
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }
}
