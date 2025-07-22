import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_admin/core/constants/app_constants.dart';
import 'package:hr_admin/core/theme/app_theme.dart';
import 'package:hr_admin/features/employees/data/services/employee_service.dart';
import 'package:hr_admin/injection_container.dart';
import '../../domain/entities/employee.dart';
import '../widgets/employee_card.dart';
import '../widgets/employee_filter_bar.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedDepartment = 'Tümü';
  int _selectedStatus = 0;
  bool _isGridView = true;

  late final EmployeeService _employeeService;
  List<Employee> _employees = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _employeeService = sl<EmployeeService>();
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final response = await _employeeService.getEmployees();
    if (response.isSuccess) {
      setState(() {
        _employees = response.data ?? [];
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = response.error?.message ?? 'Bilinmeyen hata';
        _isLoading = false;
      });
    }
  }

  List<Employee> get _filteredEmployees {
    return _employees.where((employee) {
      final matchesSearch =
          employee.fullName.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          employee.phone.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          employee.email.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );

      final matchesDepartment =
          _selectedDepartment == 'Tümü' ||
          employee.department == _selectedDepartment;

      final matchesStatus =
          _selectedStatus == 0 || employee.status == _selectedStatus;

      return matchesSearch && matchesDepartment && matchesStatus;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeColors.of(context).backgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  AppStrings.employees,
                  style: AppThemeTextStyles.of(context).heading2,
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
                  onPressed: () {
                    setState(() {
                      _isGridView = !_isGridView;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    context.go('/employees/add');
                  },
                  icon: const Icon(Icons.add),
                  label: Text(AppStrings.add),
                ),
              ],
            ),
          ),

          // Filter Bar
          EmployeeFilterBar(
            searchController: _searchController,
            selectedDepartment: _selectedDepartment,
            selectedStatus: _selectedStatus,
            onDepartmentChanged: (value) {
              setState(() {
                _selectedDepartment = value;
              });
            },
            onStatusChanged: (value) {
              setState(() {
                _selectedStatus = value == 'Tümü'
                    ? 0
                    : value == 'Aktif'
                    ? 1
                    : 2;
              });
            },
            onSearchChanged: (value) {
              setState(() {});
            },
          ),

          // Employee List/Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Text(_error!, style: TextStyle(color: Colors.red)),
                    )
                  : _filteredEmployees.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppStrings.noData,
                            style: AppTextStyles.subtitle1.copyWith(
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _isGridView
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.2,
                          ),
                      itemCount: _filteredEmployees.length,
                      itemBuilder: (context, index) {
                        return EmployeeCard(
                          employee: _filteredEmployees[index],
                          onTap: () {
                            context.go(
                              '/employees/${_filteredEmployees[index].id}',
                            );
                          },
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: _filteredEmployees.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primaryColor,
                              child: Text(
                                _filteredEmployees[index].name
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(_filteredEmployees[index].fullName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_filteredEmployees[index].position),
                                Text(_filteredEmployees[index].department),
                              ],
                            ),
                            trailing: Chip(
                              label: Text(
                                _filteredEmployees[index].status == 0
                                    ? 'Aktif'
                                    : 'Pasif',
                              ),
                              backgroundColor:
                                  _filteredEmployees[index].status == 0
                                  ? AppColors.successColor.withValues(
                                      alpha: 0.1,
                                    )
                                  : AppColors.errorColor.withValues(alpha: 0.1),
                            ),
                            onTap: () {
                              context.go(
                                '/employees/${_filteredEmployees[index].id}',
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
