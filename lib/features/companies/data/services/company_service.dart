import '../../../../core/network/base_http_service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../models/company_model.dart';
import '../dtos/company_dtos.dart';

/// Company service for handling company operations
class CompanyService extends BaseHttpService {
  CompanyService(super.prefs);

  /// Get all companies with optional filtering
  Future<ApiResponse<List<CompanyModel>>> getCompanies([
    CompanyFilterParams? params,
  ]) async {
    final queryParams = params?.toQueryParameters() ?? {};

    final response = await get<List<CompanyModel>>(
      ApiEndpoints.companies,
      queryParameters: queryParams,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => CompanyModel.fromJson(item)).toList();
        }
        return <CompanyModel>[];
      },
    );

    return response;
  }

  /// Get company by ID
  Future<ApiResponse<CompanyModel>> getCompanyById(String id) async {
    return await get<CompanyModel>(
      ApiEndpoints.companyById(id),
      fromJson: (json) => CompanyModel.fromJson(json),
    );
  }

  /// Get company details by ID
  Future<ApiResponse<Map<String, dynamic>>> getCompanyDetails(String id) async {
    return await get<Map<String, dynamic>>(
      ApiEndpoints.companyDetails(id),
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Get all companies (simple list)
  Future<ApiResponse<List<CompanyModel>>> getAllCompanies() async {
    return await get<List<CompanyModel>>(
      ApiEndpoints.companiesAll,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => CompanyModel.fromJson(item)).toList();
        }
        return <CompanyModel>[];
      },
    );
  }

  /// Get paged companies
  Future<ApiResponse<Map<String, dynamic>>> getPagedCompanies([
    CompanyFilterParams? params,
  ]) async {
    final queryParams = params?.toQueryParameters() ?? {};

    return await get<Map<String, dynamic>>(
      ApiEndpoints.companiesPaged,
      queryParameters: queryParams,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Search companies by name
  Future<ApiResponse<List<CompanyModel>>> searchCompanies(String name) async {
    return await get<List<CompanyModel>>(
      ApiEndpoints.companySearch,
      queryParameters: {'name': name},
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => CompanyModel.fromJson(item)).toList();
        }
        return <CompanyModel>[];
      },
    );
  }

  /// Create a new company
  Future<ApiResponse<CompanyModel>> createCompany(CreateCompanyDto dto) async {
    return await post<CompanyModel>(
      ApiEndpoints.companies,
      data: dto.toJson(),
      fromJson: (json) => CompanyModel.fromJson(json),
    );
  }

  /// Update company
  Future<ApiResponse<CompanyModel>> updateCompany(
    String id,
    UpdateCompanyDto dto,
  ) async {
    return await put<CompanyModel>(
      ApiEndpoints.companyById(id),
      data: dto.toJson(),
      fromJson: (json) => CompanyModel.fromJson(json),
    );
  }

  /// Delete company
  Future<ApiResponse<void>> deleteCompany(String id) async {
    return await delete<void>(ApiEndpoints.companyById(id));
  }
}
