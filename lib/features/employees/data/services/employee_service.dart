import '../../../../core/services/http_service.dart';
import '../../domain/entities/employee.dart';

/// Employee API işlemleri için service
class EmployeeService {
  final HttpService _httpService;

  EmployeeService(this._httpService);

  /// Tüm çalışanları getirir
  Future<HttpResponse<List<Employee>>> getEmployees({
    int? page,
    int? pageSize,
    String? search,
    String? department,
    String? status,
  }) async {
    final queryParams = <String, String>{};

    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['pageSize'] = pageSize.toString();
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (department != null && department.isNotEmpty) {
      queryParams['department'] = department;
    }
    if (status != null && status.isNotEmpty) queryParams['status'] = status;

    final response = await _httpService.get<List<Employee>>(
      '/employees',
      queryParameters: queryParams,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => Employee.fromJson(item)).toList();
        }
        // .NET API pagination response format
        if (json is Map<String, dynamic> && json.containsKey('data')) {
          final List<dynamic> data = json['data'];
          return data.map((item) => Employee.fromJson(item)).toList();
        }
        throw Exception('Invalid response format');
      },
    );

    return response;
  }

  /// ID'ye göre çalışan getirir
  Future<HttpResponse<Employee>> getEmployeeById(String id) async {
    final response = await _httpService.get<Employee>(
      '/employees/$id',
      fromJson: (json) => Employee.fromJson(json),
    );

    return response;
  }

  /// Yeni çalışan oluşturur
  Future<HttpResponse<Employee>> createEmployee({
    required String name,
    required String surname,
    required String email,
    String? role,
    required String department,
    required String company,
    required String position,
    required DateTime employmentStartDate,
    required String phone,
    String? address,
    String? signature,
    String? attachment,
    String? note,
  }) async {
    final body = {
      'name': name,
      'surname': surname,
      'email': email,
      if (role != null) 'role': role,
      'department': department,
      'company': company,
      'position': position,
      'employmentStartDate': employmentStartDate.toUtc().toIso8601String(),
      'phone': phone,
      if (address != null) 'address': address,
      if (signature != null) 'signature': signature,
      if (attachment != null) 'attachment': attachment,
      if (note != null) 'note': note,
    };

    final response = await _httpService.post<Employee>(
      '/employees',
      body: body,
      fromJson: (json) => Employee.fromJson(json),
    );
    print('Created Employee: ${response.data}');

    return response;
  }

  /// Çalışan bilgilerini günceller
  Future<HttpResponse<Employee>> updateEmployee({
    required String id,
    required String name,
    required String surname,
    required String email,
    required String phone,
    required String position,
    required String department,
    required String company,
    required DateTime employmentStartDate,
    required String status,
    String? role,
    String? address,
    String? signature,
    String? attachment,
    String? note,
  }) async {
    final body = {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'phone': phone,
      'position': position,
      'department': department,
      'company': company,
      'employmentStartDate': employmentStartDate.toIso8601String(),
      'status': status,
      if (role != null) 'role': role,
      if (address != null) 'address': address,
      if (signature != null) 'signature': signature,
      if (attachment != null) 'attachment': attachment,
      if (note != null) 'note': note,
    };

    final response = await _httpService.put<Employee>(
      '/employees/$id',
      body: body,
      fromJson: (json) => Employee.fromJson(json),
    );

    return response;
  }

  /// Çalışanı siler
  Future<HttpResponse<void>> deleteEmployee(String id) async {
    final response = await _httpService.delete<void>('/employees/$id');
    return response;
  }

  /// Çalışan durumunu günceller
  Future<HttpResponse<Employee>> updateEmployeeStatus(
    String id,
    String status,
  ) async {
    final body = {'status': status};

    final response = await _httpService.put<Employee>(
      '/employees/$id/status',
      body: body,
      fromJson: (json) => Employee.fromJson(json),
    );

    return response;
  }

  /// Departmana göre çalışanları getirir
  Future<HttpResponse<List<Employee>>> getEmployeesByDepartment(
    String department,
  ) async {
    final response = await _httpService.get<List<Employee>>(
      '/employees/by-department/$department',
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => Employee.fromJson(item)).toList();
        }
        throw Exception('Invalid response format');
      },
    );

    return response;
  }

  /// Çalışan istatistiklerini getirir
  Future<HttpResponse<Map<String, dynamic>>> getEmployeeStats() async {
    final response = await _httpService.get<Map<String, dynamic>>(
      '/employees/stats',
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return response;
  }

  /// Çalışan arama
  Future<HttpResponse<List<Employee>>> searchEmployees(String query) async {
    final response = await _httpService.get<List<Employee>>(
      '/employees/search',
      queryParameters: {'q': query},
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => Employee.fromJson(item)).toList();
        }
        throw Exception('Invalid response format');
      },
    );

    return response;
  }

  /// Çalışan fotoğrafı upload
  Future<HttpResponse<String>> uploadEmployeePhoto(
    String employeeId,
    String filePath,
  ) async {
    // Multipart request için ayrı implementation gerekecek
    // Şimdilik placeholder
    throw UnimplementedError('Photo upload not implemented yet');
  }
}
