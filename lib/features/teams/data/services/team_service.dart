import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/base_http_service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/services/error_handling_service.dart';
import '../models/team_model.dart';
import '../dtos/team_dtos.dart';

/// Team service for handling team operations
class TeamService extends BaseHttpService {
  TeamService(SharedPreferences prefs, ErrorHandlingService errorHandler)
    : super(prefs, errorHandler);

  /// Get all teams with optional filtering
  Future<ApiResponse<List<TeamModel>>> getTeams([
    TeamFilterParams? params,
  ]) async {
    final queryParams = params?.toQueryParameters() ?? {};

    final response = await get<List<TeamModel>>(
      ApiEndpoints.teams,
      queryParameters: queryParams,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => TeamModel.fromJson(item)).toList();
        }
        return <TeamModel>[];
      },
    );

    return response;
  }

  /// Get team by ID
  Future<ApiResponse<TeamModel>> getTeamById(String id) async {
    return await get<TeamModel>(
      ApiEndpoints.teamById(id),
      fromJson: (json) => TeamModel.fromJson(json),
    );
  }

  /// Get team details by ID
  Future<ApiResponse<Map<String, dynamic>>> getTeamDetails(String id) async {
    return await get<Map<String, dynamic>>(
      ApiEndpoints.teamDetails(id),
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Get all teams (simple list)
  Future<ApiResponse<List<TeamModel>>> getAllTeams() async {
    return await get<List<TeamModel>>(
      ApiEndpoints.teamsAll,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => TeamModel.fromJson(item)).toList();
        }
        return <TeamModel>[];
      },
    );
  }

  /// Get paged teams
  Future<ApiResponse<Map<String, dynamic>>> getPagedTeams([
    TeamFilterParams? params,
  ]) async {
    final queryParams = params?.toQueryParameters() ?? {};

    return await get<Map<String, dynamic>>(
      ApiEndpoints.teamsPaged,
      queryParameters: queryParams,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Search teams by name
  Future<ApiResponse<List<TeamModel>>> searchTeams(String name) async {
    return await get<List<TeamModel>>(
      ApiEndpoints.teamSearch,
      queryParameters: {'name': name},
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => TeamModel.fromJson(item)).toList();
        }
        return <TeamModel>[];
      },
    );
  }

  /// Get teams by department ID
  Future<ApiResponse<List<TeamModel>>> getTeamsByDepartment(
    String departmentId,
  ) async {
    return await get<List<TeamModel>>(
      ApiEndpoints.teamsByDepartment(departmentId),
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => TeamModel.fromJson(item)).toList();
        }
        return <TeamModel>[];
      },
    );
  }

  /// Create a new team
  Future<ApiResponse<TeamModel>> createTeam(CreateTeamDto dto) async {
    return await post<TeamModel>(
      ApiEndpoints.teams,
      data: dto.toJson(),
      fromJson: (json) => TeamModel.fromJson(json),
    );
  }

  /// Update team
  Future<ApiResponse<TeamModel>> updateTeam(
    String id,
    UpdateTeamDto dto,
  ) async {
    return await put<TeamModel>(
      ApiEndpoints.teamById(id),
      data: dto.toJson(),
      fromJson: (json) => TeamModel.fromJson(json),
    );
  }

  /// Delete team
  Future<ApiResponse<void>> deleteTeam(String id) async {
    return await delete<void>(ApiEndpoints.teamById(id));
  }
}
