import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:hr_admin/features/leave/presentation/bloc/permission_requests_cubit.dart';
import 'package:hr_admin/features/companies/presentation/bloc/companies_cubit.dart';
import 'package:hr_admin/features/teams/presentation/bloc/teams_cubit.dart';
import 'package:hr_admin/features/departments/presentation/bloc/departments_cubit.dart';
import 'package:hr_admin/features/users/presentation/cubit/users_cubit.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/routing/app_router.dart';
import 'core/observers/app_bloc_observer.dart';
import 'core/debug/bloc_debug_helper.dart';
import 'core/utils/logger.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setUrlStrategy(PathUrlStrategy());

  // Setup logging level based on build mode
  if (kDebugMode) {
    AppLogger.setLevel(LogLevel.debug);
    BlocDebugHelper.setDebugMode(true);
  } else {
    AppLogger.setLevel(LogLevel.info);
    BlocDebugHelper.setDebugMode(false);
  }

  // Initialize enhanced BloC observer for debug mode or regular observer for production
  if (kDebugMode) {
    Bloc.observer = DebugBlocObserver();
    AppLogger.info('🔧 Debug mode: Enhanced BLoC observer enabled');
  } else {
    Bloc.observer = AppBlocObserver();
    AppLogger.info('🚀 Production mode: Standard BLoC observer enabled');
  }

  await di.initializeDependencies();

  runApp(const HRAdminApp());
}

class HRAdminApp extends StatelessWidget {
  const HRAdminApp({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<ThemeCubit>(create: (context) => di.sl<ThemeCubit>()),
      BlocProvider<AuthBloc>(
        create: (context) => di.sl<AuthBloc>()..add(const AuthCheckStatus()),
      ),
      BlocProvider(create: (_) => di.sl<UsersCubit>()),
      BlocProvider(create: (_) => di.sl<PermissionRequestsCubit>()),
      BlocProvider(create: (_) => di.sl<CompaniesCubit>()),
      BlocProvider(create: (_) => di.sl<TeamsCubit>()),
      BlocProvider(create: (_) => di.sl<DepartmentsCubit>()),
    ],
    child: BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          title: AppConstants.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
        );
      },
    ),
  );
}
