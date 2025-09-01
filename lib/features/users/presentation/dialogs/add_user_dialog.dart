import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/users_cubit.dart';
import '../../../companies/data/models/company_model.dart';
import '../../../companies/data/services/company_service.dart';
import '../../../departments/data/models/department_model.dart' as dept;
import '../../../departments/data/services/department_service.dart';
import '../../../teams/data/models/team_model.dart';
import '../../../../shared/shared.dart';
import '../../../../injection_container.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();

  UserRoleEntity _selectedRole = UserRoleEntity.personel;
  DateTime? _employmentStartDate;
  String? _selectedCompanyId;
  String? _selectedManagerId;
  List<String> _selectedDepartmentIds = [];
  List<String> _selectedTeamIds = [];

  bool _isLoading = false;
  List<CompanyModel> _companies = [];
  List<dept.DepartmentModel> _departments = [];
  List<TeamModel> _teams = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      print('Loading initial data...');
      // Load companies
      final companyService = sl<CompanyService>();
      final companiesResponse = await companyService.getCompanies();
      print(
        'Companies response: ${companiesResponse.success}, data length: ${companiesResponse.data?.length}',
      );
      if (companiesResponse.success &&
          companiesResponse.data != null &&
          mounted) {
        setState(() {
          _companies = companiesResponse.data!;
          if (_companies.isNotEmpty) {
            // Try to find a company with departments first
            final companyWithDepartments = _companies.firstWhere(
              (company) => company.departmentCount > 0,
              orElse: () => _companies.first,
            );
            _selectedCompanyId = companyWithDepartments.id;
            print(
              'Selected company ID: $_selectedCompanyId (${companyWithDepartments.name}, departments: ${companyWithDepartments.departmentCount})',
            );
            _loadDepartmentsByCompany(_selectedCompanyId!);
          }
        });
      }
    } catch (e) {
      print('Error loading initial data: $e');
    }
  }

  Future<void> _loadDepartmentsByCompany(String companyId) async {
    try {
      print('Loading company details for: $companyId');
      final companyService = sl<CompanyService>();
      final response = await companyService.getCompanyDetails(companyId);
      print('Company details response: ${response.success}');

      if (mounted) {
        if (response.success && response.data != null) {
          // Company details'dan departments listesini al
          final departmentsData =
              response.data!['departments'] as List<dynamic>?;
          if (departmentsData != null && departmentsData.isNotEmpty) {
            final departments = departmentsData
                .map((json) => dept.DepartmentModel.fromJson(json))
                .toList();

            setState(() {
              _departments = departments;
              _selectedDepartmentIds.clear();
              _teams.clear();
              _selectedTeamIds.clear();
            });

            print(
              'Departments loaded from company details: ${_departments.length}',
            );

            // Department'ların geçerli olup olmadığını kontrol et
            await _validateDepartments();
          } else {
            setState(() {
              _departments = []; // No departments found
              _selectedDepartmentIds.clear();
              _teams.clear();
              _selectedTeamIds.clear();
            });
            print('No departments found in company details');
          }
        } else {
          setState(() {
            _departments = []; // API call failed
            _selectedDepartmentIds.clear();
            _teams.clear();
            _selectedTeamIds.clear();
          });
          print('Failed to load company details');
        }
      }
    } catch (e) {
      print('Error loading company details: $e');
      // On error, clear departments
      if (mounted) {
        setState(() {
          _departments = [];
          _selectedDepartmentIds.clear();
          _teams.clear();
          _selectedTeamIds.clear();
        });
      }
    }
  }

  Future<void> _loadTeamsByDepartment(String departmentId) async {
    try {
      print('Loading department details for: $departmentId');
      final departmentService = sl<DepartmentService>();
      final response = await departmentService.getDepartmentDetails(
        departmentId,
      );
      print('Department details response: ${response.success}');

      if (response.success && response.data != null && mounted) {
        final teamsData = response.data!['teams'] as List<dynamic>?;
        setState(() {
          if (teamsData != null && teamsData.isNotEmpty) {
            // Mevcut teams listesinden bu department'ın teamlerini kaldır
            _teams.removeWhere((team) => team.departmentId == departmentId);
            // Yeni teamleri ekle
            final newTeams = teamsData
                .map((json) => TeamModel.fromJson(json))
                .toList();
            _teams.addAll(newTeams);
            print('Teams loaded from department details: ${newTeams.length}');
          } else {
            // Bu department'ın teamlerini kaldır
            _teams.removeWhere((team) => team.departmentId == departmentId);
            print('No teams found in department details for $departmentId');
          }
        });
      } else {
        print('Failed to load department details for $departmentId');
        // Department bulunamazsa seçimden kaldır
        if (mounted) {
          setState(() {
            _teams.removeWhere((team) => team.departmentId == departmentId);
            _selectedDepartmentIds.remove(departmentId);
            _selectedTeamIds.removeWhere(
              (teamId) => _teams.any(
                (team) =>
                    team.id == teamId && team.departmentId == departmentId,
              ),
            );
          });
        }
      }
    } catch (e) {
      print('Error loading department details: $e');
      // Hata durumunda da department'ı seçimden kaldır
      if (mounted) {
        setState(() {
          _teams.removeWhere((team) => team.departmentId == departmentId);
          _selectedDepartmentIds.remove(departmentId);
          _selectedTeamIds.removeWhere(
            (teamId) => _teams.any(
              (team) => team.id == teamId && team.departmentId == departmentId,
            ),
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _validateDepartments() async {
    final validDepartments = <dept.DepartmentModel>[];
    final invalidDepartmentIds = <String>[];

    for (final department in _departments) {
      try {
        final details = await sl<DepartmentService>().getDepartmentDetails(
          department.id,
        );
        if (details.success && details.data != null) {
          validDepartments.add(department);
        } else {
          invalidDepartmentIds.add(department.id);
          print(
            'Department ${department.name} (${department.id}) is invalid - removing from UI',
          );
        }
      } catch (e) {
        invalidDepartmentIds.add(department.id);
        print(
          'Error validating department ${department.name} (${department.id}): $e - removing from UI',
        );
      }
    }

    if (mounted) {
      setState(() {
        _departments = validDepartments;
        // Geçersiz department'larla ilişkili seçimleri temizle
        _selectedDepartmentIds.removeWhere(
          (id) => invalidDepartmentIds.contains(id),
        );
        _teams.removeWhere(
          (team) => invalidDepartmentIds.contains(team.departmentId),
        );
        _selectedTeamIds.removeWhere(
          (teamId) => _teams.every((team) => team.id != teamId),
        );
      });
    }
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

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCompanyId == null) {
      sl<SnackBarService>().showError(context, 'Lütfen bir şirket seçin');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Sadece var olan departmentlerin ID'lerini gönder
      final validDepartmentIds = _selectedDepartmentIds
          .where((id) => _departments.any((dept) => dept.id == id))
          .toList();

      // Sadece var olan teamlerin ID'lerini gönder
      final validTeamIds = _selectedTeamIds
          .where((id) => _teams.any((team) => team.id == id))
          .toList();

      print('🔍 Sending user creation request with:');
      print(
        '  Valid departments: ${validDepartmentIds.length}/${_selectedDepartmentIds.length}',
      );
      print('  Valid teams: ${validTeamIds.length}/${_selectedTeamIds.length}');

      await sl<UsersCubit>().createUser(
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        email: _emailController.text.trim(),
        role: _selectedRole,
        companyId: _selectedCompanyId!,
        employmentStartDate: _employmentStartDate,
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        managerId: _selectedManagerId,
        departmentIds: validDepartmentIds,
        teamIds: validTeamIds,
      );

      if (mounted) {
        sl<SnackBarService>().showSuccess(
          context,
          'Kullanıcı başarıyla eklendi',
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        sl<SnackBarService>().showError(
          context,
          'Kullanıcı eklenirken hata oluştu: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Yeni Kullanıcı Ekle',
                style: AppThemeTextStyles.of(context).heading3,
              ),
              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Information
                      Text(
                        'Temel Bilgiler',
                        style: AppThemeTextStyles.of(context).subtitle1,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              controller: _nameController,
                              label: 'Ad*',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Ad zorunludur';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppTextFormField(
                              controller: _surnameController,
                              label: 'Soyad*',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Soyad zorunludur';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      AppTextFormField(
                        controller: _emailController,
                        label: 'E-posta*',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'E-posta zorunludur';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Geçerli bir e-posta adresi girin';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              controller: _phoneController,
                              label: 'Telefon',
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<UserRoleEntity>(
                              value: _selectedRole,
                              decoration: InputDecoration(
                                labelText: 'Rol*',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: UserRoleEntity.values
                                  .map(
                                    (role) => DropdownMenuItem(
                                      value: role,
                                      child: Text(_getRoleDisplayName(role)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedRole = value);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Employment Date
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _employmentStartDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) {
                            setState(() => _employmentStartDate = date);
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'İşe Başlama Tarihi',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _employmentStartDate != null
                                ? '${_employmentStartDate!.day}/${_employmentStartDate!.month}/${_employmentStartDate!.year}'
                                : 'Tarih seçin',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Organization Information
                      Text(
                        'Organizasyon Bilgileri',
                        style: AppThemeTextStyles.of(context).subtitle1,
                      ),
                      const SizedBox(height: 16),

                      // Company Selection
                      DropdownButtonFormField<String>(
                        value: _selectedCompanyId,
                        decoration: InputDecoration(
                          labelText: 'Şirket*',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: _companies
                            .map(
                              (company) => DropdownMenuItem(
                                value: company.id,
                                child: Text(company.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCompanyId = value;
                              _selectedDepartmentIds.clear();
                              _selectedTeamIds.clear();
                              _departments.clear();
                              _teams.clear();
                            });
                            _loadDepartmentsByCompany(value);
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Şirket seçimi zorunludur';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Department Selection (Multi-select Dropdown)
                      Text(
                        'Departmanlar',
                        style: AppThemeTextStyles.of(context).body1,
                      ),
                      const SizedBox(height: 8),
                      _buildMultiSelectDropdown(
                        items: _departments,
                        selectedIds: _selectedDepartmentIds,
                        onSelectionChanged: (selectedIds) {
                          setState(() {
                            // Kaldırılan departmanlar için teamleri temizle
                            final removedDepartments = _selectedDepartmentIds
                                .where((id) => !selectedIds.contains(id))
                                .toList();

                            for (final deptId in removedDepartments) {
                              _teams.removeWhere(
                                (team) => team.departmentId == deptId,
                              );
                              _selectedTeamIds.removeWhere(
                                (teamId) => _teams.any(
                                  (team) =>
                                      team.id == teamId &&
                                      team.departmentId == deptId,
                                ),
                              );
                            }

                            // Yeni eklenen departmanlar için teamleri yükle
                            final addedDepartments = selectedIds
                                .where(
                                  (id) => !_selectedDepartmentIds.contains(id),
                                )
                                .toList();

                            _selectedDepartmentIds = selectedIds;

                            for (final deptId in addedDepartments) {
                              _loadTeamsByDepartment(deptId);
                            }
                          });
                        },
                        emptyText: 'Bu şirkette henüz departman bulunmuyor.',
                        hintText: 'Departman seçin',
                      ),
                      const SizedBox(height: 16),

                      // Team Selection (Multi-select Dropdown)
                      Text(
                        'Takımlar',
                        style: AppThemeTextStyles.of(context).body1,
                      ),
                      const SizedBox(height: 8),
                      _buildMultiSelectDropdown(
                        items: _teams,
                        selectedIds: _selectedTeamIds,
                        onSelectionChanged: (selectedIds) {
                          setState(() {
                            _selectedTeamIds = selectedIds;
                          });
                        },
                        emptyText: _selectedDepartmentIds.isNotEmpty
                            ? 'Seçilen departmanlarda henüz takım tanımlanmamış.'
                            : 'Takım görüntülemek için önce departman seçin.',
                        hintText: 'Takım seçin',
                      ),
                      const SizedBox(height: 24),

                      // Additional Information
                      Text(
                        'Ek Bilgiler',
                        style: AppThemeTextStyles.of(context).subtitle1,
                      ),
                      const SizedBox(height: 16),

                      AppTextFormField(
                        controller: _addressController,
                        label: 'Adres',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      AppTextFormField(
                        controller: _noteController,
                        label: 'Not',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton.secondary(
                    text: const Text('İptal'),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  const SizedBox(width: 16),
                  AppButton.primary(
                    text: Text(_isLoading ? 'Ekleniyor...' : 'Ekle'),
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _submit,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultiSelectDropdown<T>({
    required List<T> items,
    required List<String> selectedIds,
    required Function(List<String>) onSelectionChanged,
    required String emptyText,
    required String hintText,
  }) {
    String getId(T item) {
      if (item is dept.DepartmentModel) return item.id;
      if (item is TeamModel) return item.id;
      return '';
    }

    String getName(T item) {
      if (item is dept.DepartmentModel) return item.name;
      if (item is TeamModel) return item.name;
      return '';
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: items.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                emptyText,
                style: const TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          : ExpansionTile(
              title: Text(
                selectedIds.isEmpty
                    ? hintText
                    : '${selectedIds.length} seçildi',
                style: TextStyle(
                  color: selectedIds.isEmpty ? Colors.grey : Colors.black,
                ),
              ),
              children: items.map((item) {
                final id = getId(item);
                final name = getName(item);
                final isSelected = selectedIds.contains(id);

                return CheckboxListTile(
                  title: Text(name),
                  value: isSelected,
                  onChanged: (value) {
                    final newSelection = List<String>.from(selectedIds);
                    if (value == true) {
                      newSelection.add(id);
                    } else {
                      newSelection.remove(id);
                    }
                    onSelectionChanged(newSelection);
                  },
                );
              }).toList(),
            ),
    );
  }
}
