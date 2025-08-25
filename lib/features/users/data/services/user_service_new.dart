import '../../../../core/network/base_http_service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../models/user_model_new.dart';

/// User service for handling user operations
class UserServiceNew extends BaseHttpService {
  UserServiceNew(super.prefs);

  /// Get all users with optional filtering
  Future<ApiResponse<List<UserModelNew>>> getUsers([
    UserFilterParams? params,
  ]) async {
    print('🔍 UserServiceNew: getUsers called with params: $params');
    final queryParams = params?.toQueryParameters() ?? {};
    print('🔍 UserServiceNew: Query parameters: $queryParams');

    final response = await get<List<UserModelNew>>(
      ApiEndpoints.users,
      queryParameters: queryParams,
      fromJson: (json) {
        print('🔍 UserServiceNew: Received JSON: $json');

        // Handle paginated response format
        if (json is Map<String, dynamic> && json.containsKey('items')) {
          final items = json['items'];
          if (items is List) {
            final users = items
                .map((item) => UserModelNew.fromJson(item))
                .toList();
            print(
              '🔍 UserServiceNew: Parsed ${users.length} users from paginated response',
            );
            return users;
          }
        }

        // Handle direct array response
        if (json is List) {
          final users = json
              .map((item) => UserModelNew.fromJson(item))
              .toList();
          print(
            '🔍 UserServiceNew: Parsed ${users.length} users from direct array',
          );
          return users;
        }

        print(
          '🔍 UserServiceNew: Unexpected JSON format, returning empty list',
        );
        return <UserModelNew>[];
      },
    );

    print(
      '🔍 UserServiceNew: Response - isSuccess: ${response.isSuccess}, data length: ${response.data?.length}, message: ${response.message}',
    );
    return response;
  }

  /// Get user by ID
  Future<ApiResponse<UserModelNew>> getUserById(String id) async {
    return await get<UserModelNew>(
      ApiEndpoints.userById(id),
      fromJson: (json) => UserModelNew.fromJson(json),
    );
  }

  /// Get user by email
  Future<ApiResponse<UserModelNew>> getUserByEmail(String email) async {
    return await get<UserModelNew>(
      ApiEndpoints.userByEmail(email),
      fromJson: (json) => UserModelNew.fromJson(json),
    );
  }

  /// Get users by role
  Future<ApiResponse<List<UserModelNew>>> getUsersByRole(UserRole role) async {
    return await get<List<UserModelNew>>(
      ApiEndpoints.usersByRole(role.value.toString()),
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => UserModelNew.fromJson(item)).toList();
        }
        return <UserModelNew>[];
      },
    );
  }

  /// Get users by company
  Future<ApiResponse<List<UserModelNew>>> getUsersByCompany(
    String companyId,
  ) async {
    return await get<List<UserModelNew>>(
      ApiEndpoints.usersByCompany(companyId),
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => UserModelNew.fromJson(item)).toList();
        }
        return <UserModelNew>[];
      },
    );
  }

  /// Get managers
  Future<ApiResponse<List<UserModelNew>>> getManagers() async {
    return await get<List<UserModelNew>>(
      ApiEndpoints.managers,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => UserModelNew.fromJson(item)).toList();
        }
        return <UserModelNew>[];
      },
    );
  }

  /// Get HR users
  Future<ApiResponse<List<UserModelNew>>> getHRUsers() async {
    return await get<List<UserModelNew>>(
      ApiEndpoints.hrUsers,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => UserModelNew.fromJson(item)).toList();
        }
        return <UserModelNew>[];
      },
    );
  }

  /// Search users
  Future<ApiResponse<List<UserModelNew>>> searchUsers(String searchTerm) async {
    return await get<List<UserModelNew>>(
      ApiEndpoints.userSearch,
      queryParameters: {'searchTerm': searchTerm},
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => UserModelNew.fromJson(item)).toList();
        }
        return <UserModelNew>[];
      },
    );
  }

  /// Create a new user
  Future<ApiResponse<UserModelNew>> createUser(CreateUserDto dto) async {
    return await post<UserModelNew>(
      ApiEndpoints.users,
      data: dto.toJson(),
      fromJson: (json) => UserModelNew.fromJson(json),
    );
  }

  /// Update user
  Future<ApiResponse<UserModelNew>> updateUser(
    String id,
    UpdateUserDto dto,
  ) async {
    return await put<UserModelNew>(
      ApiEndpoints.userById(id),
      data: dto.toJson(),
      fromJson: (json) => UserModelNew.fromJson(json),
    );
  }

  /// Delete user
  Future<ApiResponse<void>> deleteUser(String id) async {
    return await delete<void>(ApiEndpoints.userById(id));
  }
}
