import 'package:get_it/get_it.dart';
import 'package:hr_admin/shared/utils/snackbar_service.dart';
import 'package:hr_admin/shared/utils/dialog_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/theme_cubit.dart';
import 'core/services/http_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/data/services/auth_service.dart';
import 'features/employees/data/services/employee_service.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Core Services
  sl.registerLazySingleton<HttpService>(() => HttpService(sl()));
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  sl.registerLazySingleton<SnackBarService>(() => SnackBarServiceImpl());
  sl.registerLazySingleton<DialogService>(() => DialogServiceImpl());

  // Feature Services
  sl.registerLazySingleton<AuthService>(() => AuthService(sl()));
  sl.registerLazySingleton<EmployeeService>(() => EmployeeService(sl()));

  // Auth
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(sl<SharedPreferences>(), sl<AuthService>()),
  );

  // Features will be added here as we create them
}
