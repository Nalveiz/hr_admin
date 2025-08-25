import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme_new.dart' as NewTheme;

class UserFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String? selectedRole;
  final bool? selectedStatus;
  final ValueChanged<String?> onRoleChanged;
  final ValueChanged<bool?> onStatusChanged;
  final ValueChanged<String> onSearchChanged;

  const UserFilterBar({
    super.key,
    required this.searchController,
    this.selectedRole,
    this.selectedStatus,
    required this.onRoleChanged,
    required this.onStatusChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = NewTheme.AppThemeColors.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: themeColors.dividerColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Kullanıcı ara...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        onSearchChanged('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: themeColors.backgroundColor,
            ),
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: 16),

          // Filters Row
          Row(
            children: [
              // Role Filter
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Rol',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: themeColors.backgroundColor,
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Tüm Roller')),
                    DropdownMenuItem(value: '0', child: Text('Personel')),
                    DropdownMenuItem(value: '1', child: Text('Manager')),
                    DropdownMenuItem(value: '2', child: Text('İK')),
                    DropdownMenuItem(
                      value: '3',
                      child: Text('Süper Kullanıcı'),
                    ),
                  ],
                  onChanged: onRoleChanged,
                ),
              ),
              const SizedBox(width: 16),

              // Status Filter
              Expanded(
                child: DropdownButtonFormField<bool>(
                  value: selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Durum',
                    prefixIcon: const Icon(Icons.toggle_on_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: themeColors.backgroundColor,
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Tümü')),
                    DropdownMenuItem(value: true, child: Text('Aktif')),
                    DropdownMenuItem(value: false, child: Text('Pasif')),
                  ],
                  onChanged: onStatusChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
