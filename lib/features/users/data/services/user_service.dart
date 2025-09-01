import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/base_http_service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/services/error_handling_service.dart';
import '../models/user_model.dart';

/// User API service for handling user operations
class UserApiService extends BaseHttpService {
  UserApiService(SharedPreferences prefs, ErrorHandlingService errorHandler)
    : super(prefs, errorHandler);

  /// Get all users with optional filtering
  Future<ApiResponse<List<UserModel>>> getUsers([
    UserFilterParams? params,
  ]) async {
    print('🔍 UserApiService: getUsers called with params: $params');
    final queryParams = params?.toQueryParameters() ?? {};
    print('🔍 UserApiService: Query parameters: $queryParams');

    final response = await get<List<UserModel>>(
      ApiEndpoints.users,
      queryParameters: queryParams,
      fromJson: (json) {
        print('🔍 UserApiService: Received JSON: $json');

        // Handle paginated response format
        if (json is Map<String, dynamic> && json.containsKey('items')) {
          final items = json['items'];
          if (items is List) {
            final users = items
                .map((item) => UserModel.fromJson(item))
                .toList();
            print(
              '🔍 UserApiService: Parsed ${users.length} users from paginated response',
            );
            return users;
          }
        }

        // Handle direct array response
        if (json is List) {
          final users = json.map((item) => UserModel.fromJson(item)).toList();
          print(
            '🔍 UserApiService: Parsed ${users.length} users from direct array',
          );
          return users;
        }

        print(
          '🔍 UserApiService: Unexpected JSON format, returning empty list',
        );
        return <UserModel>[];
      },
    );

    print(
      '🔍 UserApiService: Response - isSuccess: ${response.isSuccess}, data length: ${response.data?.length}, message: ${response.message}',
    );
    return response;
  }

  /// Get user by ID
  Future<ApiResponse<UserModel>> getUserById(String id) async {
    return await get<UserModel>(
      ApiEndpoints.userById(id),
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  /// Get user by email
  Future<ApiResponse<UserModel>> getUserByEmail(String email) async {
    return await get<UserModel>(
      ApiEndpoints.userByEmail(email),
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  /// Get users by role
  Future<ApiResponse<List<UserModel>>> getUsersByRole(UserRole role) async {
    return await get<List<UserModel>>(
      ApiEndpoints.usersByRole(role.value.toString()),
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => UserModel.fromJson(item)).toList();
        }
        return <UserModel>[];
      },
    );
  }

  /// Get users by company
  Future<ApiResponse<List<UserModel>>> getUsersByCompany(
    String companyId,
  ) async {
    return await get<List<UserModel>>(
      ApiEndpoints.usersByCompany(companyId),
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => UserModel.fromJson(item)).toList();
        }
        return <UserModel>[];
      },
    );
  }

  /// Get managers
  Future<ApiResponse<List<UserModel>>> getManagers() async {
    return await get<List<UserModel>>(
      ApiEndpoints.managers,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => UserModel.fromJson(item)).toList();
        }
        return <UserModel>[];
      },
    );
  }

  /// Get HR users
  Future<ApiResponse<List<UserModel>>> getHRUsers() async {
    return await get<List<UserModel>>(
      ApiEndpoints.hrUsers,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => UserModel.fromJson(item)).toList();
        }
        return <UserModel>[];
      },
    );
  }

  /// Search users
  Future<ApiResponse<List<UserModel>>> searchUsers(String searchTerm) async {
    return await get<List<UserModel>>(
      ApiEndpoints.userSearch,
      queryParameters: {'searchTerm': searchTerm},
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => UserModel.fromJson(item)).toList();
        }
        return <UserModel>[];
      },
    );
  }

  /// Create a new user
  Future<ApiResponse<UserModel>> createUser(CreateUserDto dto) async {
    return await post<UserModel>(
      ApiEndpoints.users,
      data: dto.toJson(),
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  /// Update user
  Future<ApiResponse<UserModel>> updateUser(
    String id,
    UpdateUserDto dto,
  ) async {
    return await put<UserModel>(
      ApiEndpoints.userById(id),
      data: dto.toJson(),
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  /// Delete user
  Future<ApiResponse<void>> deleteUser(String id) async {
    return await delete<void>(ApiEndpoints.userById(id));
  }
}
