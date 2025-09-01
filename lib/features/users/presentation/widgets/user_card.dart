import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../shared/shared.dart';

class UserCard extends StatelessWidget {
  final UserEntity user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserCard({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return responsive.isMobile
        ? _buildMobileCard(context)
        : _buildDesktopCard(context);
  }

  Widget _buildMobileCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppThemeColors.of(
            context,
          ).primaryColor.withValues(alpha: 0.1),
          child: Text(
            _getRoleIcon(user.role),
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          user.fullName,
          style: AppThemeTextStyles.of(context).subtitle1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            Text(
              _getRoleDisplayName(user.role),
              style: TextStyle(
                color: AppThemeColors.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onEdit();
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Düzenle'),
                dense: true,
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Sil'),
                dense: true,
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildDesktopCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with actions
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppThemeColors.of(
                    context,
                  ).primaryColor.withValues(alpha: 0.1),
                  child: Text(
                    _getRoleIcon(user.role),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: AppThemeTextStyles.of(context).subtitle1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _getRoleDisplayName(user.role),
                        style: TextStyle(
                          color: AppThemeColors.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Düzenle'),
                        dense: true,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('Sil'),
                        dense: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),

            // User Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(context, Icons.email, user.email),
                  if (user.phone != null) ...[
                    const SizedBox(height: 4),
                    _buildInfoRow(context, Icons.phone, user.phone!),
                  ],
                  if (user.employmentStartDate != null) ...[
                    const SizedBox(height: 4),
                    _buildInfoRow(
                      context,
                      Icons.work,
                      'İşe Başlama: ${_formatDate(user.employmentStartDate!)}',
                    ),
                  ],
                ],
              ),
            ),

            // Quick Actions
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppButton.secondary(
                    text: const Text('Düzenle'),
                    icon: Icons.edit,
                    onPressed: onEdit,
                    size: ButtonSize.small,
                  ),
                ),
                const SizedBox(width: 8),
                AppButton.danger(
                  text: const Text('Sil'),
                  icon: Icons.delete,
                  onPressed: onDelete,
                  size: ButtonSize.small,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppThemeColors.of(context).textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppThemeTextStyles.of(context).caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getRoleDisplayName(UserRoleEntity role) {
    switch (role) {
      case UserRoleEntity.personel:
        return 'Personel';
      case UserRoleEntity.manager:
        return 'Müdür';
      case UserRoleEntity.hr:
        return 'İK';
      case UserRoleEntity.superUser:
        return 'Süper Kullanıcı';
    }
  }

  String _getRoleIcon(UserRoleEntity role) {
    switch (role) {
      case UserRoleEntity.personel:
        return '👤';
      case UserRoleEntity.manager:
        return '👔';
      case UserRoleEntity.hr:
        return '👥';
      case UserRoleEntity.superUser:
        return '⭐';
    }
  }
}
