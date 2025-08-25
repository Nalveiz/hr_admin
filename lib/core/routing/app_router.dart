import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/users/presentation/pages/users_page_new.dart';
import '../../features/departments/presentation/pages/departments_page.dart';
import '../../features/departments/presentation/pages/department_detail_page.dart';

// Import active core module pages
import '../../features/companies/presentation/pages/companies_page.dart';
import '../../features/teams/presentation/pages/teams_page.dart';

// Import placeholder pages
import '../../features/attendance/presentation/pages/attendance_page_placeholder.dart';
import '../../features/payroll/presentation/pages/payroll_page_placeholder.dart';
import '../../features/leave/presentation/pages/leave_page_placeholder.dart';
import '../../features/performance/presentation/pages/performance_page_placeholder.dart';
import '../../features/reports/presentation/pages/reports_page_placeholder.dart';
import '../../features/settings/presentation/pages/settings_page_placeholder.dart';
import '../../features/profile/presentation/pages/profile_page_placeholder.dart';

import '../../shared/presentation/pages/main_layout.dart';

/// Ana uygulama router yapılandırması
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: false,
    routes: [
      // Giriş sayfası (layout dışında)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Ana layout ile korumalı sayfalar
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          // Dashboard
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardPage(),
          ),

          // Kullanıcılar
          GoRoute(
            path: '/users',
            name: 'users',
            builder: (context, state) => const UsersPageNew(),
            routes: [
              GoRoute(
                path: '/add',
                name: 'add-user',
                builder: (context, state) => const UsersPageNew(),
              ),
              GoRoute(
                path: '/:id',
                name: 'user-detail',
                builder: (context, state) => const UsersPageNew(),
              ),
            ],
          ),

          // Departmanlar
          GoRoute(
            path: '/departments',
            name: 'departments',
            builder: (context, state) => const DepartmentsPage(),
            routes: [
              GoRoute(
                path: '/:id',
                name: 'department-detail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return DepartmentDetailPage(departmentId: id);
                },
              ),
            ],
          ),

          // Şirketler (Active)
          GoRoute(
            path: '/companies',
            name: 'companies',
            builder: (context, state) => const CompaniesPage(),
            routes: [
              GoRoute(
                path: '/add',
                name: 'add-company',
                builder: (context, state) => const CompaniesPage(),
              ),
              GoRoute(
                path: '/:id',
                name: 'company-detail',
                builder: (context, state) => const CompaniesPage(),
              ),
            ],
          ),

          // Takımlar (Active)
          GoRoute(
            path: '/teams',
            name: 'teams',
            builder: (context, state) => const TeamsPage(),
            routes: [
              GoRoute(
                path: '/add',
                name: 'add-team',
                builder: (context, state) => const TeamsPage(),
              ),
              GoRoute(
                path: '/:id',
                name: 'team-detail',
                builder: (context, state) => const TeamsPage(),
              ),
            ],
          ),

          // Devam durumu (Placeholder)
          GoRoute(
            path: '/attendance',
            name: 'attendance',
            builder: (context, state) => const AttendancePage(),
            routes: [
              GoRoute(
                path: '/report',
                name: 'attendance-report',
                builder: (context, state) => const AttendancePage(),
              ),
            ],
          ),

          // Bordro (Placeholder)
          GoRoute(
            path: '/payroll',
            name: 'payroll',
            builder: (context, state) => const PayrollPage(),
            routes: [
              GoRoute(
                path: '/:id',
                name: 'payroll-detail',
                builder: (context, state) => const PayrollPage(),
              ),
            ],
          ),

          // İzin talepleri (Placeholder)
          GoRoute(
            path: '/leave-requests',
            name: 'leave-requests',
            builder: (context, state) => const LeavePage(),
            routes: [
              GoRoute(
                path: '/add',
                name: 'add-leave-request',
                builder: (context, state) => const LeavePage(),
              ),
              GoRoute(
                path: '/:id',
                name: 'leave-request-detail',
                builder: (context, state) => const LeavePage(),
              ),
            ],
          ),

          // Performans (Placeholder)
          GoRoute(
            path: '/performance',
            name: 'performance',
            builder: (context, state) => const PerformancePage(),
            routes: [
              GoRoute(
                path: '/:id',
                name: 'performance-detail',
                builder: (context, state) => const PerformancePage(),
              ),
            ],
          ),

          // Raporlar (Placeholder)
          GoRoute(
            path: '/reports',
            name: 'reports',
            builder: (context, state) => const ReportsPage(),
          ),

          // Ayarlar (Placeholder)
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),

          // Profil (Placeholder)
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isLoginPage = location == '/login';

      // AuthBloc'tan mevcut durumu al
      final authBloc = context.read<AuthBloc>();
      final authState = authBloc.state;
      final isAuthenticated = authState is AuthAuthenticated;

      // Eğer kullanıcı giriş yapmamışsa ve login sayfasında değilse
      if (!isAuthenticated && !isLoginPage) {
        return '/login';
      }

      // Eğer kullanıcı giriş yapmışsa ve login sayfasındaysa
      if (isAuthenticated && isLoginPage) {
        return '/dashboard';
      }

      // Root'a giderse dashboard'a yönlendir
      if (isAuthenticated && location == '/') {
        return '/dashboard';
      }

      return null; // Hiçbir yönlendirme yapma
    },
  );
}

/// Route yolları ve isimleri
class AppRoutes {
  // Route yolları
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String departments = '/departments';

  // Core active modules
  static const String companies = '/companies';
  static const String addCompany = '/companies/add';
  static const String teams = '/teams';
  static const String addTeam = '/teams/add';
  static const String users = '/users';
  static const String addUser = '/users/add';

  // Placeholder modules
  static const String attendance = '/attendance';
  static const String attendanceReport = '/attendance/report';
  static const String payroll = '/payroll';
  static const String leaveRequests = '/leave-requests';
  static const String addLeaveRequest = '/leave-requests/add';
  static const String performance = '/performance';
  static const String reports = '/reports';
  static const String settings = '/settings';
  static const String profile = '/profile';

  // Dinamik route'lar
  static String departmentDetail(String id) => '/departments/$id';
  static String companyDetail(String id) => '/companies/$id';
  static String teamDetail(String id) => '/teams/$id';
  static String userDetail(String id) => '/users/$id';
  static String payrollDetail(String id) => '/payroll/$id';
  static String leaveRequestDetail(String id) => '/leave-requests/$id';
  static String performanceDetail(String id) => '/performance/$id';
}
