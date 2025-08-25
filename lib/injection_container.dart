import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'core/services/http_service.dart';
import 'core/utils/logger.dart';
import 'core/theme/theme_cubit.dart';

// Features
import 'features/companies/presentation/bloc/companies_cubit.dart';
import 'features/companies/data/services/company_service.dart';

import 'features/departments/presentation/bloc/departments_cubit.dart';
import 'features/departments/data/services/department_service_new.dart';

import 'features/teams/presentation/bloc/teams_cubit.dart';
import 'features/teams/data/services/team_service.dart';

import 'features/users/presentation/cubit/users_cubit.dart';
import 'features/users/data/services/user_service.dart' as old_user_service;
import 'features/users/presentation/cubit/users_cubit_new.dart';
import 'features/users/data/services/user_service_new.dart';
import 'features/users/domain/repositories/user_repository.dart';
import 'features/users/data/repositories/user_repository_impl.dart';
import 'features/users/domain/services/user_service.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/data/services/auth_service_new.dart';

import 'features/leave/presentation/bloc/permission_requests_cubit.dart';
import 'features/leave/data/services/leave_service_new.dart';

import 'features/permits/data/services/permit_service.dart';

// Shared
import 'shared/utils/snackbar_service.dart';
import 'shared/utils/dialog_service.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Core Services
  sl.registerLazySingleton<AppLogger>(() => AppLogger());
  sl.registerLazySingleton<HttpService>(() => HttpService(sl()));
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  sl.registerLazySingleton<SnackBarService>(() => SnackBarServiceImpl());
  sl.registerLazySingleton<DialogService>(() => DialogServiceImpl());

  // Data Services
  sl.registerLazySingleton<AuthService>(() => AuthService(sl()));
  sl.registerLazySingleton<CompanyService>(() => CompanyService(sl()));
  sl.registerLazySingleton<DepartmentServiceNew>(
    () => DepartmentServiceNew(sl()),
  );
  sl.registerLazySingleton<TeamService>(() => TeamService(sl()));
  sl.registerLazySingleton<old_user_service.UserService>(
    () => old_user_service.UserService(sl()),
  );
  sl.registerLazySingleton<UserServiceNew>(() => UserServiceNew(sl()));
  sl.registerLazySingleton<LeaveServiceNew>(() => LeaveServiceNew(sl()));
  sl.registerLazySingleton<PermitService>(() => PermitService(sl()));

  // Domain Services and Repositories
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));
  sl.registerLazySingleton<UserService>(() => UserServiceImpl(sl()));

  // Presentation Layer (BLoCs/Cubits)
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl(), sl()));
  sl.registerFactory<UsersCubit>(() => UsersCubit(sl()));
  sl.registerFactory<UsersCubitNew>(() => UsersCubitNew(sl<UserService>()));
  sl.registerFactory<PermissionRequestsCubit>(() => PermissionRequestsCubit());
  sl.registerFactory<CompaniesCubit>(() => CompaniesCubit(sl()));
  sl.registerFactory<TeamsCubit>(() => TeamsCubit(sl()));
  sl.registerFactory<DepartmentsCubit>(() => DepartmentsCubit(prefs: sl()));
}
