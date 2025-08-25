
import 'package:flutter/material.dart';
import 'package:hr_admin/core/theme/app_theme.dart'; // Tema renkleri için
import 'package:hr_admin/features/leave/leave_request_model.dart';
import 'package:intl/intl.dart';

class PermissionRequestCard extends StatelessWidget {
  final PermissionRequest request;
  final Function(String, PermissionStatus) onUpdateStatus;
  final VoidCallback? onTap; // Yeni eklendi

  const PermissionRequestCard({
    super.key,
    required this.request,
    required this.onUpdateStatus,
    this.onTap, // Yeni eklendi
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0), // ListView için margin
      elevation: 4.0,
      child: InkWell( // onTap için InkWell ekledik
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Employee Mail: ${request.employeeMail}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Reason: ${request.reason}'),
              Text(
                'Duration: '
                '${request.startDate != null ? DateFormat('dd.MM.yyyy').format(request.startDate!) : 'N/A'}'
                ' - '
                '${request.endDate != null ? DateFormat('dd.MM.yyyy').format(request.endDate!) : 'N/A'}'
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(request.status!.toDisplayString()),
                    backgroundColor: _getStatusColor(request.status ?? PermissionStatus.pending).withValues(alpha: 0.2),
                    labelStyle: TextStyle(color: _getStatusColor(request.status ?? PermissionStatus.pending)),
                  ),
                  // Sadece "Pending Approval" durumundaki talepler için aksiyon butonları
                  if (request.status == PermissionStatus.pending)
                    Row(
                      children: [
                        // Onay butonu
                        IconButton(
                          icon: Icon(Icons.check_circle, color: AppColors.successColor),
                          onPressed: () => onUpdateStatus(request.id ?? '', PermissionStatus.approved),
                          tooltip: 'Approve',
                        ),
                        // Reddet butonu
                        IconButton(
                          icon: Icon(Icons.cancel, color: AppColors.errorColor),
                          onPressed: () => onUpdateStatus(request.id ?? '', PermissionStatus.rejected),
                          tooltip: 'Reject',
                        ),
                      ],
                    ),
                ],
              ),
              // Opsiyonel alanları göster
              if (request.approvedAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text('Approved At: ${DateFormat('dd.MM.yyyy HH:mm').format(request.approvedAt!)}', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                ),
              if (request.approverId != null && request.approverId!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text('Approver ID: ${request.approverId}', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                ),
              if (request.notes != null && request.notes!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text('Notes: ${request.notes}', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Duruma göre renk döndüren yardımcı metot
  Color _getStatusColor(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.pending:
        return AppColors.warningColor; // Sarı/Turuncu
      case PermissionStatus.approved:
        return AppColors.successColor; // Yeşil
      case PermissionStatus.rejected:
        return AppColors.errorColor; // Kırmızı
      case PermissionStatus.cancelled:
        return AppColors.textHint; }
  }
}
