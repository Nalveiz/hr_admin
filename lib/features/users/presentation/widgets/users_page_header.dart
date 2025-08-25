import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../shared/shared.dart';

class UsersPageHeader extends StatelessWidget {
  final TextEditingController searchController;
  final UserRoleEntity? selectedRoleFilter;
  final VoidCallback onAddUser;
  final Function(UserRoleEntity?) onRoleFilterChanged;
  final VoidCallback onFiltersChanged;

  const UsersPageHeader({
    super.key,
    required this.searchController,
    required this.selectedRoleFilter,
    required this.onAddUser,
    required this.onRoleFilterChanged,
    required this.onFiltersChanged,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppThemeColors.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context, responsive),
          const SizedBox(height: 16),
          _buildFilters(context, responsive),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ResponsiveUtils responsive) {
    return Row(
      children: [
        Icon(
          Icons.people,
          size: 28,
          color: AppThemeColors.of(context).primaryColor,
        ),
        const SizedBox(width: 12),
        Text(
          'Kullanıcı Yönetimi',
          style: AppThemeTextStyles.of(
            context,
          ).heading2.copyWith(color: AppThemeColors.of(context).primaryColor),
        ),
        const Spacer(),
        AppButton.primary(
          text: const Text('Yeni Kullanıcı'),
          icon: Icons.add,
          onPressed: onAddUser,
          size: responsive.isMobile ? ButtonSize.small : ButtonSize.medium,
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context, ResponsiveUtils responsive) {
    if (responsive.isDesktop) {
      return Row(
        children: [
          // Search Bar
          Expanded(
            flex: 2,
            child: AppTextFormField(
              controller: searchController,
              label: 'Kullanıcı ara...',
              prefixIcon: Icons.search,
              onChanged: (value) => onFiltersChanged(),
            ),
          ),
          const SizedBox(width: 16),
          // Role Filter
          Expanded(child: _buildRoleDropdown(context)),
        ],
      );
    } else {
      // Mobile Layout
      return Column(
        children: [
          AppTextFormField(
            controller: searchController,
            label: 'Kullanıcı ara...',
            prefixIcon: Icons.search,
            onChanged: (value) => onFiltersChanged(),
          ),
          const SizedBox(height: 12),
          _buildRoleDropdown(context),
        ],
      );
    }
  }

  Widget _buildRoleDropdown(BuildContext context) {
    return DropdownButtonFormField<UserRoleEntity>(
      value: selectedRoleFilter,
      decoration: const InputDecoration(
        labelText: 'Rol',
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem<UserRoleEntity>(
          value: null,
          child: Text('Tüm Roller'),
        ),
        ...UserRoleEntity.values.map(
          (role) => DropdownMenuItem<UserRoleEntity>(
            value: role,
            child: Text(_getRoleDisplayName(role)),
          ),
        ),
      ],
      onChanged: (value) {
        onRoleFilterChanged(value);
        onFiltersChanged();
      },
    );
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
}
