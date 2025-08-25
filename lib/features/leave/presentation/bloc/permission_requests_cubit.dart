
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_admin/features/leave/leave_request_model.dart';
import 'package:hr_admin/features/leave/leave_service.dart';
import 'package:hr_admin/features/leave/presentation/bloc/permission_requests_state.dart';
import 'package:hr_admin/injection_container.dart';

class PermissionRequestsCubit extends Cubit<PermissionRequestsState> {
  // Service Locator kullanarak LeaveRequestService'i alıyoruz
  final LeaveRequestService _leaveRequestService = sl<LeaveRequestService>();

  PermissionRequestsCubit() : super(PermissionRequestsState.initial());

  /// Fetches all permission requests from the API.
  Future<void> fetchPermissionRequests() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final response = await _leaveRequestService.getLeaveRequests();
      if (response.isSuccess) {
        emit(
          state.copyWith(
            allPermissionRequests: response.data ?? [],
            isLoading: false,
            error: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: response.error?.message ?? 'Unknown error occurred while fetching requests.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  /// Sets the selected status filter and updates the filtered list.
  void setStatusFilter(PermissionStatus? status) {
    emit(state.copyWith(selectedStatusFilter: status));
  }

  /// Updates the status of a specific permission request via API.
  Future<void> updatePermissionRequestStatus(String requestId, PermissionStatus newStatus) async {
    emit(state.copyWith(isLoading: true, error: null)); // Show loading for the update

    try {
      // API call to update the status. We send the integer index of the enum.
      final response = await _leaveRequestService.updateLeaveRequestStatus(
        requestId,
        newStatus.index, // Sending the enum's integer index
        null, // approverId: if you have an approver ID, pass it here
        null, // notes: if you have notes for the approval/rejection, pass them here
      );

      if (response.isSuccess) {
        // Find the updated request in the allPermissionRequests list and replace it
        final updatedRequests = state.allPermissionRequests.map((request) {
          return request.id == requestId ? response.data! : request;
        }).toList();

        emit(
          state.copyWith(
            allPermissionRequests: updatedRequests,
            isLoading: false,
            error: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: response.error?.message ?? 'Failed to update request status.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  /// Returns a filtered list of permission requests based on the selected status.
  List<PermissionRequest> get filteredPermissionRequests {
    if (state.selectedStatusFilter == null) {
      return state.allPermissionRequests;
    } else {
      return state.allPermissionRequests
          .where((request) => request.status == state.selectedStatusFilter)
          .toList();
    }
  }
}
