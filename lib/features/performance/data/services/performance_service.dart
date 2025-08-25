// import '../../../../core/network/api_endpoints.dart';
// import '../../../../core/network/api_response.dart';
// import '../../../../core/network/base_http_service.dart';
// import '../models/performance_review_model.dart';

// /// Service for performance-related API operations
// class PerformanceService extends BaseHttpService {
//   PerformanceService(super.prefs);

//   /// Get all performance reviews
//   Future<ApiResponse<List<PerformanceReviewModel>>> getPerformanceReviews({
//     String? employeeId,
//     String? reviewerId,
//     String? reviewType,
//     String? status,
//     DateTime? startDate,
//     DateTime? endDate,
//     int? page,
//     int? limit,
//   }) async {
//     try {
//       final queryParams = <String, dynamic>{};
//       if (employeeId != null) queryParams['employeeId'] = employeeId;
//       if (reviewerId != null) queryParams['reviewerId'] = reviewerId;
//       if (reviewType != null) queryParams['reviewType'] = reviewType;
//       if (status != null) queryParams['status'] = status;
//       if (startDate != null)
//         queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
//       if (endDate != null)
//         queryParams['endDate'] = endDate.toIso8601String().split('T')[0];
//       if (page != null) queryParams['page'] = page;
//       if (limit != null) queryParams['limit'] = limit;

//       final response = await dio.get(
//         ApiEndpoints.performance,
//         queryParameters: queryParams,
//       );

//       final List<dynamic> data = response.data['data'] ?? [];
//       final reviews = data
//           .map((json) => PerformanceReviewModel.fromJson(json))
//           .toList();

//       return ApiResponse.success(
//         reviews,
//         message:
//             response.data['message'] ??
//             'Performance reviews fetched successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to fetch performance reviews');
//     }
//   }

//   /// Get performance review by ID
//   Future<ApiResponse<PerformanceReviewModel>> getPerformanceReviewById(
//     String id,
//   ) async {
//     try {
//       final response = await dio.get('${ApiEndpoints.performance}/$id');

//       final review = PerformanceReviewModel.fromJson(response.data['data']);

//       return ApiResponse.success(
//         review,
//         message:
//             response.data['message'] ??
//             'Performance review fetched successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to fetch performance review');
//     }
//   }

//   /// Create new performance review
//   Future<ApiResponse<PerformanceReviewModel>> createPerformanceReview(
//     PerformanceReviewModel review,
//   ) async {
//     try {
//       final requestData = review.toJson();
//       // Remove ID for creation
//       requestData.remove('id');
//       requestData.remove('createdAt');
//       requestData.remove('updatedAt');

//       final response = await dio.post(
//         ApiEndpoints.performance,
//         data: requestData,
//       );

//       final createdReview = PerformanceReviewModel.fromJson(
//         response.data['data'],
//       );

//       return ApiResponse.success(
//         createdReview,
//         message:
//             response.data['message'] ??
//             'Performance review created successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to create performance review');
//     }
//   }

//   /// Update performance review
//   Future<ApiResponse<PerformanceReviewModel>> updatePerformanceReview(
//     String id,
//     PerformanceReviewModel review,
//   ) async {
//     try {
//       final requestData = review.toJson();
//       // Remove read-only fields
//       requestData.remove('createdAt');

//       final response = await dio.put(
//         '${ApiEndpoints.performance}/$id',
//         data: requestData,
//       );

//       final updatedReview = PerformanceReviewModel.fromJson(
//         response.data['data'],
//       );

//       return ApiResponse.success(
//         updatedReview,
//         message:
//             response.data['message'] ??
//             'Performance review updated successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to update performance review');
//     }
//   }

//   /// Delete performance review
//   Future<ApiResponse<void>> deletePerformanceReview(String id) async {
//     try {
//       final response = await dio.delete('${ApiEndpoints.performance}/$id');

//       return ApiResponse.success(
//         null,
//         message:
//             response.data['message'] ??
//             'Performance review deleted successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to delete performance review');
//     }
//   }

//   /// Submit performance review
//   Future<ApiResponse<PerformanceReviewModel>> submitPerformanceReview(
//     String id,
//   ) async {
//     try {
//       final response = await dio.patch(
//         '${ApiEndpoints.performance}/$id/submit',
//         data: {
//           'status': 'completed',
//           'completedAt': DateTime.now().toIso8601String(),
//         },
//       );

//       final review = PerformanceReviewModel.fromJson(response.data['data']);

//       return ApiResponse.success(
//         review,
//         message:
//             response.data['message'] ??
//             'Performance review submitted successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to submit performance review');
//     }
//   }

//   /// Approve performance review
//   Future<ApiResponse<PerformanceReviewModel>> approvePerformanceReview(
//     String id,
//   ) async {
//     try {
//       final response = await dio.patch(
//         '${ApiEndpoints.performance}/$id/approve',
//         data: {
//           'status': 'approved',
//           'approvedAt': DateTime.now().toIso8601String(),
//         },
//       );

//       final review = PerformanceReviewModel.fromJson(response.data['data']);

//       return ApiResponse.success(
//         review,
//         message:
//             response.data['message'] ??
//             'Performance review approved successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to approve performance review');
//     }
//   }

//   /// Get employee performance summary
//   Future<ApiResponse<Map<String, dynamic>>> getEmployeePerformanceSummary({
//     required String employeeId,
//     DateTime? startDate,
//     DateTime? endDate,
//   }) async {
//     try {
//       final queryParams = <String, dynamic>{'employeeId': employeeId};
//       if (startDate != null)
//         queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
//       if (endDate != null)
//         queryParams['endDate'] = endDate.toIso8601String().split('T')[0];

//       final response = await dio.get(
//         '${ApiEndpoints.performance}/summary',
//         queryParameters: queryParams,
//       );

//       return ApiResponse.success(
//         response.data['data'] as Map<String, dynamic>,
//         message:
//             response.data['message'] ??
//             'Employee performance summary fetched successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to fetch employee performance summary');
//     }
//   }

//   /// Get department performance analytics
//   Future<ApiResponse<Map<String, dynamic>>> getDepartmentPerformanceAnalytics({
//     required String departmentId,
//     String? reviewPeriod,
//     String? reviewType,
//   }) async {
//     try {
//       final queryParams = <String, dynamic>{'departmentId': departmentId};
//       if (reviewPeriod != null) queryParams['reviewPeriod'] = reviewPeriod;
//       if (reviewType != null) queryParams['reviewType'] = reviewType;

//       final response = await dio.get(
//         '${ApiEndpoints.performance}/department-analytics',
//         queryParameters: queryParams,
//       );

//       return ApiResponse.success(
//         response.data['data'] as Map<String, dynamic>,
//         message:
//             response.data['message'] ??
//             'Department performance analytics fetched successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error(
//         'Failed to fetch department performance analytics',
//       );
//     }
//   }

//   /// Generate performance review template
//   Future<ApiResponse<PerformanceReviewModel>> generateReviewTemplate({
//     required String employeeId,
//     required String reviewType,
//     required DateTime startDate,
//     required DateTime endDate,
//     String? reviewerId,
//   }) async {
//     try {
//       final response = await dio.post(
//         '${ApiEndpoints.performance}/generate-template',
//         data: {
//           'employeeId': employeeId,
//           'reviewType': reviewType,
//           'startDate': startDate.toIso8601String().split('T')[0],
//           'endDate': endDate.toIso8601String().split('T')[0],
//           'reviewerId': reviewerId,
//         },
//       );

//       final review = PerformanceReviewModel.fromJson(response.data['data']);

//       return ApiResponse.success(
//         review,
//         message:
//             response.data['message'] ??
//             'Performance review template generated successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error(
//         'Failed to generate performance review template',
//       );
//     }
//   }

//   /// Get overdue performance reviews
//   Future<ApiResponse<List<PerformanceReviewModel>>> getOverdueReviews({
//     String? departmentId,
//     String? reviewerId,
//   }) async {
//     try {
//       final queryParams = <String, dynamic>{};
//       if (departmentId != null) queryParams['departmentId'] = departmentId;
//       if (reviewerId != null) queryParams['reviewerId'] = reviewerId;

//       final response = await dio.get(
//         '${ApiEndpoints.performance}/overdue',
//         queryParameters: queryParams,
//       );

//       final List<dynamic> data = response.data['data'] ?? [];
//       final reviews = data
//           .map((json) => PerformanceReviewModel.fromJson(json))
//           .toList();

//       return ApiResponse.success(
//         reviews,
//         message:
//             response.data['message'] ??
//             'Overdue performance reviews fetched successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to fetch overdue performance reviews');
//     }
//   }
// }
