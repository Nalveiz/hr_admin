// lib/features/permission_requests/presentation/widgets/permission_status_filter.dart
import 'package:flutter/material.dart';
import 'package:hr_admin/core/theme/app_theme.dart';
import 'package:hr_admin/features/leave/leave_request_model.dart'; // Or your theme/colors path

class PermissionStatusFilter extends StatelessWidget {
  final PermissionStatus? selectedStatus;
  final ValueChanged<PermissionStatus?> onStatusSelected;

  const PermissionStatusFilter({
    super.key,
    this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Example filter bar implementation
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          Text(
            'Filter by Status:',
            style: AppThemeTextStyles.of(context).body2,
          ),
          const SizedBox(width: 16),
          DropdownButton<PermissionStatus?>(
            value: selectedStatus,
            hint: const Text('All'),
            onChanged: onStatusSelected,
            items: [
              const DropdownMenuItem<PermissionStatus?>(
                value: null, // Represents 'All'
                child: Text('All'),
              ),
              ...PermissionStatus.values.map((status) {
                return DropdownMenuItem<PermissionStatus>(
                  value: status,
                  child: Text(
                    PermissionStatusExtension(status).toDisplayString(),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

// You might have this extension in your PermissionRequest model or a separate file
extension PermissionStatusExtension on PermissionStatus {
  String toDisplayString() {
    switch (this) {
      case PermissionStatus.pending:
        return 'Pending';
      case PermissionStatus.approved:
        return 'Approved';
      case PermissionStatus.rejected:
        return 'Rejected';
      case PermissionStatus.cancelled:
        return 'Cancelled';
    }
  }
}
