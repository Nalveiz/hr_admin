/// API endpoints constants - Updated for NewLdapApi v1
class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'https://localhost:7200';

  // Auth endpoints (LDAP)
  static const String login = '/auth/login';
  static const String refreshToken = '/Auth/refresh-token';
  static const String logout = '/Auth/logout';
  static const String profile = '/auth/me';

  // Company endpoints
  static const String companies = '/company';
  static String companyById(String id) => '/company/$id';
  static String companyDetails(String id) => '/company/$id/details';
  static const String companiesAll = '/company/all';
  static const String companiesPaged = '/company/paged';
  static const String companySearch = '/company/search';

  // Department endpoints
  static const String departments = '/department';
  static String departmentById(String id) => '/department/$id';
  static String departmentDetails(String id) => '/department/$id/details';
  static const String departmentsAll = '/department/all';
  static const String departmentsPaged = '/department/paged';
  static const String departmentSearch = '/department/search';

  // Team endpoints
  static const String teams = '/team';
  static String teamById(String id) => '/team/$id';
  static String teamDetails(String id) => '/team/$id/details';
  static const String teamsAll = '/team/all';
  static const String teamsPaged = '/team/paged';
  static const String teamSearch = '/team/search';
  static String teamsByDepartment(String departmentId) =>
      '/team/department/$departmentId';

  // Employee endpoints
  static const String employees = '/employees';

  // User endpoints
  static const String users = '/user';
  static String userById(String id) => '/user/$id';
  static String userByEmail(String email) => '/user/email/$email';
  static String usersByRole(String role) => '/user/role/$role';
  static String usersByCompany(String companyId) => '/user/company/$companyId';
  static const String managers = '/user/managers';
  static const String hrUsers = '/user/hr';
  static const String userSearch = '/user/search';

  // Leave endpoints
  static const String leaves = '/api/Leave';
  static String leaveById(String id) => '/api/Leave/$id';
  static String leaveHistory(String id) => '/api/Leave/$id/history';
  static String leavesByOwner(String ownerId) => '/api/Leave/owner/$ownerId';
  static String leavesByStatus(String status) => '/api/Leave/status/$status';
  static const String pendingApprovals = '/api/Leave/pending-approvals';
  static String leavesByCompany(String companyId) =>
      '/api/Leave/company/$companyId';
  static String updateLeaveStatus(String id) => '/api/Leave/$id/status';
  static const String validateLeavePeriod = '/api/Leave/validate-period';

  // Leave Request endpoints (permits)
  static const String permits = '/permits';
  static const String permitsByEmployee = '/permits/employee';
  static const String permitsByStatus = '/permits/by-status';
  static const String permitDelete = '/permits/permit-delete';

  // Attendance endpoints (legacy support)
  static const String attendance = '/api/attendance';
  static String attendanceById(String id) => '/api/attendance/$id';
  static const String attendanceCheckIn = '/api/attendance/check-in';
  static const String attendanceCheckOut = '/api/attendance/check-out';
  static const String attendanceManual = '/api/attendance/manual';
  static const String attendanceSummary = '/api/attendance/summary';
  static const String attendanceDepartmentReport =
      '/api/attendance/department-report';
  static String attendanceApprove(String id) => '/api/attendance/$id/approve';
  static String attendanceReject(String id) => '/api/attendance/$id/reject';

  // Reports endpoints (deprecated in new API)
  // Keeping for backward compatibility
  static const String reports = '/api/reports';
  static const String departmentReport = '/api/reports/department';
  static const String employeeReport = '/api/reports/employee';
  static const String attendanceReportEndpoint = '/api/reports/attendance';
  static const String leaveReport = '/api/reports/leave';
  static const String performanceReportEndpoint = '/api/reports/performance';
  static const String payrollReport = '/api/reports/payroll';
}
