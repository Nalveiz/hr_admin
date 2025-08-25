// import '../../../../core/network/api_endpoints.dart';
// import '../../../../core/network/api_response.dart';
// import '../../../../core/network/base_http_service.dart';
// import '../models/payroll_model.dart';

// /// Service for payroll-related API operations
// class PayrollService extends BaseHttpService {
//   PayrollService(super.prefs);

//   /// Get all payroll records
//   Future<ApiResponse<List<PayrollModel>>> getPayrolls({
//     String? employeeId,
//     String? payPeriod,
//     String? status,
//     DateTime? startDate,
//     DateTime? endDate,
//     int? page,
//     int? limit,
//   }) async {
//     try {
//       final queryParams = <String, dynamic>{};
//       if (employeeId != null) queryParams['employeeId'] = employeeId;
//       if (payPeriod != null) queryParams['payPeriod'] = payPeriod;
//       if (status != null) queryParams['status'] = status;
//       if (startDate != null)
//         queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
//       if (endDate != null)
//         queryParams['endDate'] = endDate.toIso8601String().split('T')[0];
//       if (page != null) queryParams['page'] = page;
//       if (limit != null) queryParams['limit'] = limit;

//       final response = await dio.get(
//         ApiEndpoints.payroll,
//         queryParameters: queryParams,
//       );

//       final List<dynamic> data = response.data['data'] ?? [];
//       final payrolls = data.map((json) => PayrollModel.fromJson(json)).toList();

//       return ApiResponse.success(
//         payrolls,
//         message: response.data['message'] ?? 'Payrolls fetched successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to fetch payrolls');
//     }
//   }

//   /// Get payroll by ID
//   Future<ApiResponse<PayrollModel>> getPayrollById(String id) async {
//     try {
//       final response = await dio.get('${ApiEndpoints.payroll}/$id');

//       final payroll = PayrollModel.fromJson(response.data['data']);

//       return ApiResponse.success(
//         payroll,
//         message: response.data['message'] ?? 'Payroll fetched successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to fetch payroll');
//     }
//   }

//   /// Create new payroll
//   Future<ApiResponse<PayrollModel>> createPayroll(PayrollModel payroll) async {
//     try {
//       final requestData = payroll.toJson();
//       // Remove ID for creation
//       requestData.remove('id');
//       requestData.remove('createdAt');
//       requestData.remove('updatedAt');

//       final response = await dio.post(ApiEndpoints.payroll, data: requestData);

//       final createdPayroll = PayrollModel.fromJson(response.data['data']);

//       return ApiResponse.success(
//         createdPayroll,
//         message: response.data['message'] ?? 'Payroll created successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to create payroll');
//     }
//   }

//   /// Update payroll
//   Future<ApiResponse<PayrollModel>> updatePayroll(
//     String id,
//     PayrollModel payroll,
//   ) async {
//     try {
//       final requestData = payroll.toJson();
//       // Remove read-only fields
//       requestData.remove('createdAt');

//       final response = await dio.put(
//         '${ApiEndpoints.payroll}/$id',
//         data: requestData,
//       );

//       final updatedPayroll = PayrollModel.fromJson(response.data['data']);

//       return ApiResponse.success(
//         updatedPayroll,
//         message: response.data['message'] ?? 'Payroll updated successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to update payroll');
//     }
//   }

//   /// Delete payroll
//   Future<ApiResponse<void>> deletePayroll(String id) async {
//     try {
//       final response = await dio.delete('${ApiEndpoints.payroll}/$id');

//       return ApiResponse.success(
//         null,
//         message: response.data['message'] ?? 'Payroll deleted successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to delete payroll');
//     }
//   }

//   /// Calculate payroll for employee
//   Future<ApiResponse<PayrollModel>> calculatePayroll({
//     required String employeeId,
//     required String payPeriod,
//     double? overtimeHours,
//     double? bonusAmount,
//     double? additionalAllowances,
//     double? additionalDeductions,
//   }) async {
//     try {
//       final response = await dio.post(
//         '${ApiEndpoints.payroll}/calculate',
//         data: {
//           'employeeId': employeeId,
//           'payPeriod': payPeriod,
//           'overtimeHours': overtimeHours,
//           'bonusAmount': bonusAmount,
//           'additionalAllowances': additionalAllowances,
//           'additionalDeductions': additionalDeductions,
//         },
//       );

//       final payroll = PayrollModel.fromJson(response.data['data']);

//       return ApiResponse.success(
//         payroll,
//         message: response.data['message'] ?? 'Payroll calculated successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to calculate payroll');
//     }
//   }

//   /// Approve payroll
//   Future<ApiResponse<PayrollModel>> approvePayroll(String id) async {
//     try {
//       final response = await dio.patch(
//         '${ApiEndpoints.payroll}/$id/approve',
//         data: {
//           'status': 'approved',
//           'approvedAt': DateTime.now().toIso8601String(),
//         },
//       );

//       final payroll = PayrollModel.fromJson(response.data['data']);

//       return ApiResponse.success(
//         payroll,
//         message: response.data['message'] ?? 'Payroll approved successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to approve payroll');
//     }
//   }

//   /// Mark payroll as paid
//   Future<ApiResponse<PayrollModel>> markAsPaid(
//     String id,
//     String paymentMethod,
//   ) async {
//     try {
//       final response = await dio.patch(
//         '${ApiEndpoints.payroll}/$id/pay',
//         data: {
//           'status': 'paid',
//           'paymentMethod': paymentMethod,
//           'paidAt': DateTime.now().toIso8601String(),
//         },
//       );

//       final payroll = PayrollModel.fromJson(response.data['data']);

//       return ApiResponse.success(
//         payroll,
//         message:
//             response.data['message'] ?? 'Payroll marked as paid successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to mark payroll as paid');
//     }
//   }

//   /// Generate payroll for all employees in a department
//   Future<ApiResponse<List<PayrollModel>>> generateDepartmentPayroll({
//     required String departmentId,
//     required String payPeriod,
//     DateTime? payDate,
//   }) async {
//     try {
//       final response = await dio.post(
//         '${ApiEndpoints.payroll}/generate-department',
//         data: {
//           'departmentId': departmentId,
//           'payPeriod': payPeriod,
//           'payDate':
//               payDate?.toIso8601String().split('T')[0] ??
//               DateTime.now().toIso8601String().split('T')[0],
//         },
//       );

//       final List<dynamic> data = response.data['data'] ?? [];
//       final payrolls = data.map((json) => PayrollModel.fromJson(json)).toList();

//       return ApiResponse.success(
//         payrolls,
//         message:
//             response.data['message'] ??
//             'Department payroll generated successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to generate department payroll');
//     }
//   }

//   /// Get payroll summary report
//   Future<ApiResponse<Map<String, dynamic>>> getPayrollSummary({
//     required String payPeriod,
//     String? departmentId,
//   }) async {
//     try {
//       final queryParams = <String, dynamic>{'payPeriod': payPeriod};
//       if (departmentId != null) queryParams['departmentId'] = departmentId;

//       final response = await dio.get(
//         '${ApiEndpoints.payroll}/summary',
//         queryParameters: queryParams,
//       );

//       return ApiResponse.success(
//         response.data['data'] as Map<String, dynamic>,
//         message:
//             response.data['message'] ?? 'Payroll summary fetched successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to fetch payroll summary');
//     }
//   }

//   /// Export payroll data
//   Future<ApiResponse<Map<String, dynamic>>> exportPayroll({
//     required String payPeriod,
//     String? format, // 'csv', 'excel', 'pdf'
//     String? departmentId,
//   }) async {
//     try {
//       final response = await dio.get(
//         '${ApiEndpoints.payroll}/export',
//         queryParameters: {
//           'payPeriod': payPeriod,
//           'format': format ?? 'csv',
//           if (departmentId != null) 'departmentId': departmentId,
//         },
//       );

//       return ApiResponse.success(
//         response.data['data'] as Map<String, dynamic>,
//         message: response.data['message'] ?? 'Payroll exported successfully',
//       );
//     } catch (e) {
//       return ApiResponse.error('Failed to export payroll');
//     }
//   }
// }
