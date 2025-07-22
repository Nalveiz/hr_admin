import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/employee.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback onTap;
  final VoidCallback? onEdit;

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);
    final themeTextStyles = AppThemeTextStyles.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: themeColors.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: employee.attachment != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          employee.attachment!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildInitials(context),
                        ),
                      )
                    : _buildInitials(context),
              ),
              const SizedBox(height: 12),

              // Name
              Text(
                employee.fullName,
                style: themeTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Phone
              Text(
                employee.phone,
                style: themeTextStyles.caption.copyWith(
                  color: themeColors.primaryColor,
                ),
              ),
              const SizedBox(height: 8),

              // Position
              Text(
                employee.position,
                style: themeTextStyles.body2,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Department
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: themeColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  employee.department,
                  style: themeTextStyles.caption.copyWith(
                    color: themeColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Spacer(),

              // Status
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: employee.status == 0
                          ? themeColors.successColor
                          : themeColors.errorColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    employee.status == 0 ? 'Aktif' : 'Pasif',
                    style: themeTextStyles.caption.copyWith(
                      color: employee.status == 0
                          ? themeColors.successColor
                          : themeColors.errorColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              // Düzenle Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Düzenle'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    textStyle: themeTextStyles.caption,
                  ),
                  onPressed: onEdit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitials(BuildContext context) {
    final themeTextStyles = AppThemeTextStyles.of(context);

    return Center(
      child: Text(
        '${employee.name.substring(0, 1)}${employee.surname.substring(0, 1)}',
        style: themeTextStyles.subtitle1.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
