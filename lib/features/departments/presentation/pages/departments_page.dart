import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/departments_cubit.dart';
import '../bloc/departments_state.dart';
import '../dialogs/add_department_dialog.dart';
import '../dialogs/edit_department_dialog.dart';
import '../../domain/entities/department.dart';
import '../../../../injection_container.dart';
import '../../../../shared/shared.dart';

/// Page for managing departments with listing, adding, editing, and deleting functionality
class DepartmentsPage extends StatefulWidget {
  const DepartmentsPage({super.key});

  @override
  State<DepartmentsPage> createState() => _DepartmentsPageState();
}

class _DepartmentsPageState extends State<DepartmentsPage> {
  final _searchController = TextEditingController();
  bool _showActiveOnly = true;
  String _viewType = 'grid'; // 'grid' or 'list'

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadDepartments() {
    context.read<DepartmentsCubit>().loadDepartments(
      search: _searchController.text.trim().isEmpty
          ? null
          : _searchController.text.trim(),
      isActive: _showActiveOnly ? true : null,
    );
  }

  void _onSearchChanged() {
    _loadDepartments();
  }

  Future<void> _showAddDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => BlocProvider.value(
        value: context.read<DepartmentsCubit>(),
        child: const AddDepartmentDialog(),
      ),
    );

    if (result == true) {
      _loadDepartments();
    }
  }

  Future<void> _showEditDialog(Department department) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => BlocProvider.value(
        value: context.read<DepartmentsCubit>(),
        child: EditDepartmentDialog(department: department),
      ),
    );

    if (result == true) {
      _loadDepartments();
    }
  }

  Future<void> _deleteDepartment(Department department) async {
    final confirmed = await sl<DialogService>().showConfirmation(
      context,
      title: 'Departmanı Sil',
      message:
          '${department.name} departmanını silmek istediğinizden emin misiniz?',
      isDanger: true,
    );

    if (confirmed == true) {
      context.read<DepartmentsCubit>().deleteDepartment(department.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return BlocListener<DepartmentsCubit, DepartmentsState>(
      listener: (context, state) {
        if (state is DepartmentDeleted) {
          sl<SnackBarService>().showSuccess(context, state.message);
          _loadDepartments();
        } else if (state is DepartmentsError) {
          sl<SnackBarService>().showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppThemeColors.of(context).backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.apartment,
                    size: 32,
                    color: AppThemeColors.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Departmanlar',
                    style: AppThemeTextStyles.of(context).heading2,
                  ),
                  const Spacer(),
                  AppButton.primary(
                    text: const Text('Departman Ekle'),
                    icon: Icons.add,
                    onPressed: _showAddDialog,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search and Filters
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: AppTextFormField(
                      controller: _searchController,
                      label: 'Departman ara...',
                      prefixIcon: Icons.search,
                      onChanged: (_) => _onSearchChanged(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilterChip(
                      label: const Text('Sadece Aktif'),
                      selected: _showActiveOnly,
                      onSelected: (value) {
                        setState(() {
                          _showActiveOnly = value;
                        });
                        _loadDepartments();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // View Toggle
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'grid',
                        icon: Icon(Icons.grid_view),
                        label: Text('Grid'),
                      ),
                      ButtonSegment(
                        value: 'list',
                        icon: Icon(Icons.list),
                        label: Text('Liste'),
                      ),
                    ],
                    selected: {_viewType},
                    onSelectionChanged: (Set<String> selection) {
                      setState(() {
                        _viewType = selection.first;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Content
              Expanded(
                child: BlocBuilder<DepartmentsCubit, DepartmentsState>(
                  builder: (context, state) {
                    if (state is DepartmentsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is DepartmentsError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error,
                              size: 64,
                              color: AppThemeColors.of(context).errorColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Bir hata oluştu',
                              style: AppThemeTextStyles.of(context).heading3,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: AppThemeTextStyles.of(context).body1,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            AppButton.primary(
                              text: const Text('Tekrar Dene'),
                              icon: Icons.refresh,
                              onPressed: _loadDepartments,
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is DepartmentsLoaded) {
                      final departments = state.departments;

                      if (departments.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.apartment,
                                size: 64,
                                color: AppThemeColors.of(
                                  context,
                                ).secondaryColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Departman bulunamadı',
                                style: AppThemeTextStyles.of(context).heading3,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Henüz hiç departman eklenmemiş',
                                style: AppThemeTextStyles.of(context).body1,
                              ),
                              const SizedBox(height: 16),
                              AppButton.primary(
                                text: const Text('İlk Departmanı Ekle'),
                                icon: Icons.add,
                                onPressed: _showAddDialog,
                              ),
                            ],
                          ),
                        );
                      }

                      return _viewType == 'grid'
                          ? _buildGridView(departments, responsive)
                          : _buildListView(departments);
                    }

                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridView(
    List<Department> departments,
    ResponsiveUtils responsive,
  ) {
    int crossAxisCount = 4;
    if (responsive.isMobile)
      crossAxisCount = 1;
    else if (responsive.isTablet)
      crossAxisCount = 2;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: departments.length,
      itemBuilder: (context, index) {
        final department = departments[index];
        return _buildDepartmentCard(department);
      },
    );
  }

  Widget _buildListView(List<Department> departments) {
    return ListView.builder(
      itemCount: departments.length,
      itemBuilder: (context, index) {
        final department = departments[index];
        return _buildDepartmentListTile(department);
      },
    );
  }

  Widget _buildDepartmentCard(Department department) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showEditDialog(department),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status and menu
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: department.isActive
                          ? AppThemeColors.of(
                              context,
                            ).successColor.withValues(alpha: 0.1)
                          : AppThemeColors.of(
                              context,
                            ).errorColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      department.isActive ? 'Aktif' : 'Pasif',
                      style: AppThemeTextStyles.of(context).caption.copyWith(
                        color: department.isActive
                            ? AppThemeColors.of(context).successColor
                            : AppThemeColors.of(context).errorColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          _showEditDialog(department);
                          break;
                        case 'delete':
                          _deleteDepartment(department);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Düzenle'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Sil', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Department Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppThemeColors.of(
                    context,
                  ).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.apartment,
                  color: AppThemeColors.of(context).primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),

              // Department Name
              Text(
                department.name,
                style: AppThemeTextStyles.of(context).subtitle1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Description
              if (department.description != null) ...[
                Text(
                  department.description!,
                  style: AppThemeTextStyles.of(context).body2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],

              const Spacer(),

              // Employee Count
              Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 16,
                    color: AppThemeColors.of(context).secondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${department.employeeCount} kullanici',
                    style: AppThemeTextStyles.of(context).caption,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDepartmentListTile(Department department) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppThemeColors.of(
              context,
            ).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            Icons.apartment,
            color: AppThemeColors.of(context).primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          department.name,
          style: AppThemeTextStyles.of(context).subtitle1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (department.description != null)
              Text(
                department.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 14,
                  color: AppThemeColors.of(context).secondaryColor,
                ),
                const SizedBox(width: 4),
                Text('${department.employeeCount} kullanici'),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: department.isActive
                        ? AppThemeColors.of(
                            context,
                          ).successColor.withValues(alpha: 0.1)
                        : AppThemeColors.of(
                            context,
                          ).errorColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    department.isActive ? 'Aktif' : 'Pasif',
                    style: AppThemeTextStyles.of(context).caption.copyWith(
                      color: department.isActive
                          ? AppThemeColors.of(context).successColor
                          : AppThemeColors.of(context).errorColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEditDialog(department);
                break;
              case 'delete':
                _deleteDepartment(department);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Düzenle'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Sil', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _showEditDialog(department),
      ),
    );
  }
}
