import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme_new.dart' as NewTheme;
import '../../domain/entities/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onTap;
  final VoidCallback? onEdit;

  const UserCard({
    super.key,
    required this.user,
    required this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = NewTheme.AppThemeColors.of(context);
    final themeTextStyles = NewTheme.AppThemeTextStyles.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Picture/Initials
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: themeColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: themeColors.primaryColor.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: _buildInitials(context),
              ),
              const SizedBox(height: 12),

              // Name
              Text(
                user.fullName,
                style: themeTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // User ID
              if (user.id != null)
                Text(
                  user.id!,
                  style: themeTextStyles.caption.copyWith(
                    color: themeColors.primaryColor,
                  ),
                ),
              const SizedBox(height: 8),

              // Email
              if (user.email != null)
                Text(
                  user.email!,
                  style: themeTextStyles.body2,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 4),

              // Role
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: themeColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user.roleText,
                  style: themeTextStyles.caption.copyWith(
                    color: themeColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Spacer(),

              // Status & Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Status
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: user.isActive
                              ? themeColors.successColor
                              : themeColors.errorColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        user.isActive ? 'Aktif' : 'Pasif',
                        style: themeTextStyles.caption.copyWith(
                          color: user.isActive
                              ? themeColors.successColor
                              : themeColors.errorColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  // Edit button
                  if (onEdit != null)
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: themeColors.primaryColor,
                        size: 20,
                      ),
                      onPressed: onEdit,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitials(BuildContext context) {
    final themeColors = NewTheme.AppThemeColors.of(context);
    final themeTextStyles = NewTheme.AppThemeTextStyles.of(context);

    final firstName = user.name ?? '';
    final lastName = user.surname ?? '';
    final initials =
        '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
            .toUpperCase();

    return Center(
      child: Text(
        initials.isNotEmpty ? initials : 'U',
        style: themeTextStyles.heading3.copyWith(
          color: themeColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
