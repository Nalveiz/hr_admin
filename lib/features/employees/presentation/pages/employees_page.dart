import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
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
  String _selectedStatus = 'Tümü';
  bool _isGridView = true;

  // Mock data - In real app, this would come from BLoC
  final List<Employee> _employees = [
    Employee(
      id: '1',
      employeeId: 'EMP001',
      firstName: 'Ahmet',
      lastName: 'Yılmaz',
      email: 'ahmet.yilmaz@company.com',
      phone: '+90 532 123 4567',
      position: 'Senior Developer',
      department: 'IT',
      hireDate: DateTime(2022, 1, 15),
      salary: 15000,
      status: 'active',
      birthDate: DateTime(1990, 5, 20),
    ),
    Employee(
      id: '2',
      employeeId: 'EMP002',
      firstName: 'Fatma',
      lastName: 'Kaya',
      email: 'fatma.kaya@company.com',
      phone: '+90 533 456 7890',
      position: 'HR Specialist',
      department: 'HR',
      hireDate: DateTime(2021, 3, 10),
      salary: 12000,
      status: 'active',
      birthDate: DateTime(1988, 8, 15),
    ),
    Employee(
      id: '3',
      employeeId: 'EMP003',
      firstName: 'Mehmet',
      lastName: 'Demir',
      email: 'mehmet.demir@company.com',
      phone: '+90 534 789 0123',
      position: 'Sales Manager',
      department: 'Sales',
      hireDate: DateTime(2020, 6, 5),
      salary: 18000,
      status: 'active',
      birthDate: DateTime(1985, 12, 3),
    ),
    Employee(
      id: '4',
      employeeId: 'EMP004',
      firstName: 'Ayşe',
      lastName: 'Öztürk',
      email: 'ayse.ozturk@company.com',
      phone: '+90 535 012 3456',
      position: 'Marketing Specialist',
      department: 'Marketing',
      hireDate: DateTime(2023, 2, 20),
      salary: 11000,
      status: 'active',
      birthDate: DateTime(1992, 4, 10),
    ),
  ];

  List<Employee> get _filteredEmployees {
    return _employees.where((employee) {
      final matchesSearch =
          employee.fullName.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          employee.employeeId.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          employee.email.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );

      final matchesDepartment =
          _selectedDepartment == 'Tümü' ||
          employee.department == _selectedDepartment;

      final matchesStatus =
          _selectedStatus == 'Tümü' || employee.status == _selectedStatus;

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
      backgroundColor: AppColors.backgroundColor,
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
                Text(AppStrings.employees, style: AppTextStyles.heading2),
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
                _selectedStatus = value;
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
              child: _filteredEmployees.isEmpty
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
                            crossAxisCount: 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
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
                                _filteredEmployees[index].firstName
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
                                _filteredEmployees[index].status == 'active'
                                    ? 'Aktif'
                                    : 'Pasif',
                              ),
                              backgroundColor:
                                  _filteredEmployees[index].status == 'active'
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
