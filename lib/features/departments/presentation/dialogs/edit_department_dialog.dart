import 'package:flutter/material.dart';
import '../../data/services/department_service.dart';
import '../../domain/entities/department.dart';
import '../../../companies/data/services/company_service.dart';
import '../../../../injection_container.dart';
import '../../../../shared/shared.dart';

/// Dialog for editing an existing department
class EditDepartmentDialog extends StatefulWidget {
  final Department department;

  const EditDepartmentDialog({super.key, required this.department});

  @override
  State<EditDepartmentDialog> createState() => _EditDepartmentDialogState();
}

class _EditDepartmentDialogState extends State<EditDepartmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool _isLoading = false;
  bool _isActive = true;
  String? _selectedCompanyId;
  List<CompanyModel> _companies = [];
  late final DepartmentService _departmentService;
  late final CompanyService _companyService;

  @override
  void initState() {
    super.initState();
    _departmentService = DepartmentService(sl(), sl());
    _companyService = CompanyService(sl(), sl());

    // Initialize form with department data
    _nameController.text = widget.department.name;
    _isActive = widget.department.isActive;
    _selectedCompanyId = widget.department.companyId;

    _loadCompanies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadCompanies() async {
    try {
      final response = await _companyService.getCompanies();
      if (response.success && response.data != null && mounted) {
        setState(() {
          _companies = response.data!;
        });
      }
    } catch (e) {
      print('Error loading companies: $e');
    }
  }

  Future<void> _updateDepartment() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCompanyId == null) {
      sl<SnackBarService>().showError(context, 'Lütfen bir şirket seçin');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // API spec'ine göre UpdateDepartmentDto - sadece gerekli alanları gönder
      final updateDto = <String, dynamic>{
        'name': _nameController.text.trim(),
        'companyId': _selectedCompanyId!,
        'valid': _isActive, // API'de 'valid' olarak bekleniyor
      };

      final response = await _departmentService.updateDepartmentFromDto(
        widget.department.id,
        updateDto,
      );

      if (!mounted) return;

      if (response.success) {
        sl<SnackBarService>().showSuccess(
          context,
          'Departman başarıyla güncellendi',
        );
        Navigator.of(context).pop(true);
      } else {
        sl<SnackBarService>().showError(
          context,
          response.error ?? 'Departman güncellenirken bir hata oluştu',
        );
      }
    } catch (e) {
      if (mounted) {
        sl<SnackBarService>().showError(
          context,
          'Beklenmeyen bir hata oluştu: ${e.toString()}',
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
    final responsive = ResponsiveUtils(context);

    return Dialog(
      child: Container(
        width: responsive.isMobile ? double.infinity : 500,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppThemeColors.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Departman Düzenle',
                    style: AppThemeTextStyles.of(
                      context,
                    ).heading3.copyWith(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company Selection
                      Text(
                        'Şirket *',
                        style: AppThemeTextStyles.of(context).body1,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedCompanyId,
                        decoration: const InputDecoration(
                          hintText: 'Şirket seçin',
                          prefixIcon: Icon(Icons.business),
                        ),
                        items: _companies
                            .map(
                              (company) => DropdownMenuItem(
                                value: company.id,
                                child: Text(company.name),
                              ),
                            )
                            .toList(),
                        onChanged: _isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedCompanyId = value;
                                });
                              },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Şirket seçimi zorunludur';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Department Name
                      AppTextFormField(
                        controller: _nameController,
                        label: 'Departman Adı *',
                        prefixIcon: Icons.apartment,
                        validator: AppValidators.required,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Active Status
                      SwitchListTile(
                        title: const Text('Aktif'),
                        subtitle: const Text('Departmanın aktif durumu'),
                        value: _isActive,
                        onChanged: _isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _isActive = value;
                                });
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppThemeColors.of(context).backgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton.secondary(
                      text: const Text('İptal'),
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton.primary(
                      text: Text(_isLoading ? 'Güncelleniyor...' : 'Güncelle'),
                      icon: _isLoading ? null : Icons.save,
                      onPressed: _isLoading ? null : _updateDepartment,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
