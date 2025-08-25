// import '../../../../core/network/base_http_service.dart';
// import '../../../../core/network/api_endpoints.dart';
// import '../../../../core/network/api_response.dart';
// import '../models/leave_request_model.dart';

// /// Leave request service for handling leave request operations
// class LeaveRequestService extends BaseHttpService {
//   LeaveRequestService(super.prefs);

//   /// Get all leave requests with optional filtering
//   Future<ApiResponse<List<LeaveRequestModel>>> getLeaveRequests({
//     int? page,
//     int? pageSize,
//     String? employeeId,
//     String? status,
//     String? type,
//     DateTime? startDate,
//     DateTime? endDate,
//   }) async {
//     final queryParams = <String, dynamic>{};

//     if (page != null) queryParams['page'] = page;
//     if (pageSize != null) queryParams['pageSize'] = pageSize;
//     if (employeeId != null) queryParams['employeeId'] = employeeId;
//     if (status != null) queryParams['status'] = status;
//     if (type != null) queryParams['type'] = type;
//     if (startDate != null) {
//       queryParams['startDate'] = startDate.toIso8601String();
//     }
//     if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

//     final response = await get<List<LeaveRequestModel>>(
//       ApiEndpoints.leaveRequests,
//       queryParameters: queryParams,
//       fromJson: (json) {
//         if (json is List) {
//           return json.map((item) => LeaveRequestModel.fromJson(item)).toList();
//         }
//         return <LeaveRequestModel>[];
//       },
//     );

//     return response;
//   }

//   /// Get leave request by ID
//   Future<ApiResponse<LeaveRequestModel>> getLeaveRequestById(String id) async {
//     return await get<LeaveRequestModel>(
//       ApiEndpoints.leaveRequestById(id),
//       fromJson: (json) => LeaveRequestModel.fromJson(json),
//     );
//   }

//   /// Create new leave request
//   Future<ApiResponse<LeaveRequestModel>> createLeaveRequest({
//     required String employeeId,
//     required String employeeMail,
//     required String employeeName,
//     required String type,
//     required DateTime startDate,
//     required DateTime endDate,
//     required String reason,
//     String? notes,
//   }) async {
//     final totalDays = endDate.difference(startDate).inDays + 1;

//     final data = {
//       'employeeId': employeeId,
//       'employeeMail': employeeMail,
//       'employeeName': employeeName,
//       'type': type,
//       'startDate': startDate.toIso8601String(),
//       'endDate': endDate.toIso8601String(),
//       'totalDays': totalDays,
//       'reason': reason,
//       'notes': notes,
//       'status': 'Pending',
//     };

//     return await post<LeaveRequestModel>(
//       ApiEndpoints.leaveRequests,
//       data: data,
//       fromJson: (json) => LeaveRequestModel.fromJson(json),
//     );
//   }

//   /// Update existing leave request
//   Future<ApiResponse<LeaveRequestModel>> updateLeaveRequest({
//     required String id,
//     String? type,
//     DateTime? startDate,
//     DateTime? endDate,
//     String? reason,
//     String? notes,
//   }) async {
//     final data = <String, dynamic>{};

//     if (type != null) data['type'] = type;
//     if (startDate != null) data['startDate'] = startDate.toIso8601String();
//     if (endDate != null) data['endDate'] = endDate.toIso8601String();
//     if (reason != null) data['reason'] = reason;
//     if (notes != null) data['notes'] = notes;

//     // Recalculate total days if dates are updated
//     if (startDate != null && endDate != null) {
//       data['totalDays'] = endDate.difference(startDate).inDays + 1;
//     }

//     return await put<LeaveRequestModel>(
//       ApiEndpoints.leaveRequestById(id),
//       data: data,
//       fromJson: (json) => LeaveRequestModel.fromJson(json),
//     );
//   }

//   /// Delete leave request
//   Future<ApiResponse<void>> deleteLeaveRequest(String id) async {
//     return await delete<void>(ApiEndpoints.leaveRequestById(id));
//   }

//   /// Approve leave request
//   Future<ApiResponse<LeaveRequestModel>> approveLeaveRequest({
//     required String id,
//     String? notes,
//   }) async {
//     final data = <String, dynamic>{
//       'status': 'Approved',
//       'approvedAt': DateTime.now().toIso8601String(),
//     };

//     if (notes != null) data['notes'] = notes;

//     return await post<LeaveRequestModel>(
//       ApiEndpoints.approveLeaveRequest(id),
//       data: data,
//       fromJson: (json) => LeaveRequestModel.fromJson(json),
//     );
//   }

//   /// Reject leave request
//   Future<ApiResponse<LeaveRequestModel>> rejectLeaveRequest({
//     required String id,
//     required String rejectionReason,
//     String? notes,
//   }) async {
//     final data = {
//       'status': 'Rejected',
//       'rejectionReason': rejectionReason,
//       'notes': notes,
//     };

//     return await post<LeaveRequestModel>(
//       ApiEndpoints.rejectLeaveRequest(id),
//       data: data,
//       fromJson: (json) => LeaveRequestModel.fromJson(json),
//     );
//   }

//   /// Get leave requests by employee
//   Future<ApiResponse<List<LeaveRequestModel>>> getLeaveRequestsByEmployee(
//     String employeeId,
//   ) async {
//     return await get<List<LeaveRequestModel>>(
//       ApiEndpoints.leaveRequestsByEmployee,
//       queryParameters: {'employeeId': employeeId},
//       fromJson: (json) {
//         if (json is List) {
//           return json.map((item) => LeaveRequestModel.fromJson(item)).toList();
//         }
//         return <LeaveRequestModel>[];
//       },
//     );
//   }

//   /// Get leave requests by status
//   Future<ApiResponse<List<LeaveRequestModel>>> getLeaveRequestsByStatus(
//     String status,
//   ) async {
//     return await get<List<LeaveRequestModel>>(
//       ApiEndpoints.leaveRequestsByStatus,
//       queryParameters: {'status': status},
//       fromJson: (json) {
//         if (json is List) {
//           return json.map((item) => LeaveRequestModel.fromJson(item)).toList();
//         }
//         return <LeaveRequestModel>[];
//       },
//     );
//   }

//   /// Get leave request statistics
//   Future<ApiResponse<Map<String, dynamic>>> getLeaveRequestStats() async {
//     return await get<Map<String, dynamic>>(
//       '${ApiEndpoints.leaveRequests}/stats',
//       fromJson: (json) => json as Map<String, dynamic>,
//     );
//   }

//   /// Cancel leave request (by employee)
//   Future<ApiResponse<LeaveRequestModel>> cancelLeaveRequest(String id) async {
//     return await patch<LeaveRequestModel>(
//       ApiEndpoints.leaveRequestById(id),
//       data: {'status': 'Cancelled'},
//       fromJson: (json) => LeaveRequestModel.fromJson(json),
//     );
//   }
// }
