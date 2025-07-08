import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class EmployeeFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedDepartment;
  final String selectedStatus;
  final ValueChanged<String> onDepartmentChanged;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onSearchChanged;

  const EmployeeFilterBar({
    super.key,
    required this.searchController,
    required this.selectedDepartment,
    required this.selectedStatus,
    required this.onDepartmentChanged,
    required this.onStatusChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.dividerColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Çalışan ara...',
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
            ),
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: 16),

          // Filters Row
          Row(
            children: [
              // Department Filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedDepartment,
                  decoration: const InputDecoration(
                    labelText: 'Departman',
                    prefixIcon: Icon(Icons.apartment),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Tümü', child: Text('Tümü')),
                    DropdownMenuItem(value: 'IT', child: Text('IT')),
                    DropdownMenuItem(
                      value: 'HR',
                      child: Text('İnsan Kaynakları'),
                    ),
                    DropdownMenuItem(value: 'Sales', child: Text('Satış')),
                    DropdownMenuItem(
                      value: 'Marketing',
                      child: Text('Pazarlama'),
                    ),
                    DropdownMenuItem(value: 'Finance', child: Text('Finans')),
                    DropdownMenuItem(
                      value: 'Operations',
                      child: Text('Operasyon'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onDepartmentChanged(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),

              // Status Filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Durum',
                    prefixIcon: Icon(Icons.info),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Tümü', child: Text('Tümü')),
                    DropdownMenuItem(value: 'active', child: Text('Aktif')),
                    DropdownMenuItem(value: 'inactive', child: Text('Pasif')),
                    DropdownMenuItem(
                      value: 'terminated',
                      child: Text('İşten Çıkış'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onStatusChanged(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),

              // Reset Filters Button
              ElevatedButton.icon(
                onPressed: () {
                  searchController.clear();
                  onDepartmentChanged('Tümü');
                  onStatusChanged('Tümü');
                  onSearchChanged('');
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Sıfırla'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
