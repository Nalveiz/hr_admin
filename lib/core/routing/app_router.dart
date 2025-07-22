import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/employees/presentation/pages/employees_page.dart';
import '../../features/employees/presentation/pages/employee_detail_page.dart';
import '../../features/employees/presentation/pages/add_employee_page.dart';
import '../../features/departments/presentation/pages/departments_page.dart';
import '../../features/departments/presentation/pages/department_detail_page.dart';
import '../../features/attendance/presentation/pages/attendance_page.dart';
import '../../features/attendance/presentation/pages/attendance_report_page.dart';
import '../../features/payroll/presentation/pages/payroll_page.dart';
import '../../features/payroll/presentation/pages/payroll_detail_page.dart'
    as payroll_detail;
import '../../features/leave/presentation/pages/leave_request_detail_page.dart'
    as leave_detail;
import '../../features/leave/presentation/pages/add_leave_request_page.dart'
    as add_leave;
import '../../features/performance/presentation/pages/performance_page.dart';
import '../../features/performance/presentation/pages/performance_detail_page.dart'
    as performance_detail;
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
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

          // Çalışanlar
          GoRoute(
            path: '/employees',
            name: 'employees',
            builder: (context, state) => const EmployeesPage(),
            routes: [
              GoRoute(
                path: '/add',
                name: 'add-employee',
                builder: (context, state) => const AddEmployeePage(),
              ),
              GoRoute(
                path: '/:id',
                name: 'employee-detail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return EmployeeDetailPage(employeeId: id);
                },
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

          // Devam durumu
          GoRoute(
            path: '/attendance',
            name: 'attendance',
            builder: (context, state) => const AttendancePage(),
            routes: [
              GoRoute(
                path: '/report',
                name: 'attendance-report',
                builder: (context, state) => const AttendanceReportPage(),
              ),
            ],
          ),

          // Bordro
          GoRoute(
            path: '/payroll',
            name: 'payroll',
            builder: (context, state) => const PayrollPage(),
            routes: [
              GoRoute(
                path: '/:id',
                name: 'payroll-detail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return payroll_detail.PayrollDetailPage(payrollId: id);
                },
              ),
            ],
          ),

          // İzin talepleri
          GoRoute(
            path: '/leave-requests',
            name: 'leave-requests',
            builder: (context, state) => const add_leave.AddLeaveRequestPage(),
            routes: [
              GoRoute(
                path: '/add',
                name: 'add-leave-request',
                builder: (context, state) =>
                    const add_leave.AddLeaveRequestPage(),
              ),
              GoRoute(
                path: '/:id',
                name: 'leave-request-detail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return leave_detail.LeaveRequestDetailPage(requestId: id);
                },
              ),
            ],
          ),

          // Performans
          GoRoute(
            path: '/performance',
            name: 'performance',
            builder: (context, state) => const PerformancePage(),
            routes: [
              GoRoute(
                path: '/:id',
                name: 'performance-detail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return performance_detail.PerformanceDetailPage(
                    performanceId: id,
                  );
                },
              ),
            ],
          ),

          // Raporlar
          GoRoute(
            path: '/reports',
            name: 'reports',
            builder: (context, state) => const ReportsPage(),
          ),

          // Ayarlar
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),

          // Profil
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
  static const String employees = '/employees';
  static const String addEmployee = '/employees/add';
  static const String departments = '/departments';
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
  static String employeeDetail(String id) => '/employees/$id';
  static String departmentDetail(String id) => '/departments/$id';
  static String payrollDetail(String id) => '/payroll/$id';
  static String leaveRequestDetail(String id) => '/leave-requests/$id';
  static String performanceDetail(String id) => '/performance/$id';
}
