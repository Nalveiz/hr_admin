import 'package:equatable/equatable.dart';
import 'package:hr_admin/features/leave/leave_request_model.dart';

class PermissionRequestsState extends Equatable {
  final List<PermissionRequest> allPermissionRequests;
  final bool isLoading;
  final String? error;
  final PermissionStatus? selectedStatusFilter; // Filtering by status

  const PermissionRequestsState({
    required this.allPermissionRequests,
    required this.isLoading,
    this.error,
    this.selectedStatusFilter,
  });

  // Initial state for the Cubit
  factory PermissionRequestsState.initial() {
    return const PermissionRequestsState(
      allPermissionRequests: [],
      isLoading: false,
      error: null,
      selectedStatusFilter: null, // No initial filter
    );
  }

  // Helper method to create a new state with updated values
  PermissionRequestsState copyWith({
    List<PermissionRequest>? allPermissionRequests,
    bool? isLoading,
    String? error,
    PermissionStatus? selectedStatusFilter,
  }) {
    return PermissionRequestsState(
      allPermissionRequests: allPermissionRequests ?? this.allPermissionRequests,
      isLoading: isLoading ?? this.isLoading,
      error: error, // Error can be set to null explicitly
      selectedStatusFilter: selectedStatusFilter, // Filter can be set to null explicitly
    );
  }

  @override
  List<Object?> get props => [
        allPermissionRequests,
        isLoading,
        error,
        selectedStatusFilter,
      ];
}
