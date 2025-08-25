import '../../../../core/services/http_service.dart';
import '../models/user_dto.dart';
import '../../domain/entities/user.dart';

class UserService {
  final HttpService _httpService;

  UserService(this._httpService);

  // Helper method to handle response and extract data
  T _handleResponse<T>(dynamic response, T Function(dynamic) mapper) {
    if (!response.isSuccess || response.data == null) {
      throw Exception(
        'API isteği başarısız: ${response.error?.message ?? "Bilinmeyen hata"}',
      );
    }
    return mapper(response.data);
  }

  List<User> _parseUserList(dynamic data) {
    if (data['items'] != null) {
      final List<dynamic> items = data['items'];
      return items.map((json) => User.fromJson(json)).toList();
    } else if (data is List) {
      final List<dynamic> items = data;
      return items.map((json) => User.fromJson(json)).toList();
    }
    return [];
  }

  // Kullanıcıları listeleme
  Future<List<User>> getUsers({UserFilterParams? filters}) async {
    try {
      final queryParams = filters?.toQueryParameters() ?? {};
      final stringParams = queryParams.map(
        (key, value) => MapEntry(key, value.toString()),
      );

      final response = await _httpService.get(
        '/user',
        queryParameters: stringParams,
      );
      return _handleResponse(response, _parseUserList);
    } catch (e) {
      throw Exception('Kullanıcılar yüklenirken hata oluştu: $e');
    }
  }

  // ID ile kullanıcı getirme
  Future<User?> getUserById(String id) async {
    try {
      final response = await _httpService.get('/user/$id');
      return _handleResponse(response, (data) => User.fromJson(data));
    } catch (e) {
      throw Exception('Kullanıcı bilgileri yüklenirken hata oluştu: $e');
    }
  }

  // Email ile kullanıcı getirme
  Future<User?> getUserByEmail(String email) async {
    try {
      final response = await _httpService.get('/user/email/$email');
      return _handleResponse(response, (data) => User.fromJson(data));
    } catch (e) {
      throw Exception('Kullanıcı bulunamadı: $e');
    }
  }

  // Role göre kullanıcılar
  Future<List<User>> getUsersByRole(int role) async {
    try {
      final response = await _httpService.get('/user/role/$role');
      return _handleResponse(response, _parseUserList);
    } catch (e) {
      throw Exception('Kullanıcılar yüklenirken hata oluştu: $e');
    }
  }

  // Şirkete göre kullanıcılar
  Future<List<User>> getUsersByCompany(String companyId) async {
    try {
      final response = await _httpService.get('/user/company/$companyId');
      return _handleResponse(response, _parseUserList);
    } catch (e) {
      throw Exception('Kullanıcılar yüklenirken hata oluştu: $e');
    }
  }

  // Yöneticileri getirme
  Future<List<User>> getManagers() async {
    try {
      final response = await _httpService.get('/user/managers');
      return _handleResponse(response, _parseUserList);
    } catch (e) {
      throw Exception('Yöneticiler yüklenirken hata oluştu: $e');
    }
  }

  // İK personelini getirme
  Future<List<User>> getHrUsers() async {
    try {
      final response = await _httpService.get('/user/hr');
      return _handleResponse(response, _parseUserList);
    } catch (e) {
      throw Exception('İK personelleri yüklenirken hata oluştu: $e');
    }
  }

  // Kullanıcı arama
  Future<List<User>> searchUsers(String searchTerm) async {
    try {
      final response = await _httpService.get(
        '/user/search',
        queryParameters: {'searchTerm': searchTerm},
      );
      return _handleResponse(response, _parseUserList);
    } catch (e) {
      throw Exception('Arama yapılırken hata oluştu: $e');
    }
  }

  // Kullanıcı oluşturma
  Future<User> createUser(CreateUserDto dto) async {
    try {
      final response = await _httpService.post('/user', body: dto.toJson());
      return _handleResponse(response, (data) => User.fromJson(data));
    } catch (e) {
      throw Exception('Kullanıcı oluşturulurken hata oluştu: $e');
    }
  }

  // Kullanıcı güncelleme
  Future<User> updateUser(String id, UpdateUserDto dto) async {
    try {
      final response = await _httpService.put('/user/$id', body: dto.toJson());
      return _handleResponse(response, (data) => User.fromJson(data));
    } catch (e) {
      throw Exception('Kullanıcı güncellenirken hata oluştu: $e');
    }
  }

  // Kullanıcı silme
  Future<void> deleteUser(String id) async {
    try {
      final response = await _httpService.delete('/user/$id');
      if (!response.isSuccess) {
        throw Exception(
          'API isteği başarısız: ${response.error?.message ?? "Bilinmeyen hata"}',
        );
      }
    } catch (e) {
      throw Exception('Kullanıcı silinirken hata oluştu: $e');
    }
  }
}
