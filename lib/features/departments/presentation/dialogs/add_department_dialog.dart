import 'package:flutter/material.dart';
import '../../data/services/department_service.dart';
import '../../../companies/data/models/company_model.dart';
import '../../../companies/data/services/company_service.dart';
import '../../../../injection_container.dart';
import '../../../../shared/shared.dart';

/// Dialog for adding a new department
class AddDepartmentDialog extends StatefulWidget {
  const AddDepartmentDialog({super.key});

  @override
  State<AddDepartmentDialog> createState() => _AddDepartmentDialogState();
}

class _AddDepartmentDialogState extends State<AddDepartmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool _isLoading = false;
  String? _selectedCompanyId;
  List<CompanyModel> _companies = [];
  late final DepartmentService _departmentService;
  late final CompanyService _companyService;

  @override
  void initState() {
    super.initState();
    _departmentService = DepartmentService(sl(), sl());
    _companyService = CompanyService(sl(), sl());
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

  Future<void> _saveDepartment() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCompanyId == null) {
      sl<SnackBarService>().showError(context, 'Lütfen bir şirket seçin');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // API spec'ine göre CreateDepartmentDto
      final createDto = {
        'name': _nameController.text.trim(),
        'companyId': _selectedCompanyId!,
      };

      final response = await _departmentService.createDepartmentFromDto(
        createDto,
      );

      if (!mounted) return;

      if (response.success) {
        sl<SnackBarService>().showSuccess(
          context,
          'Departman başarıyla eklendi',
        );
        Navigator.of(context).pop(true);
      } else {
        sl<SnackBarService>().showError(
          context,
          response.error ?? 'Departman eklenirken bir hata oluştu',
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
                  Icon(Icons.apartment, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Yeni Departman Ekle',
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
                      text: Text(_isLoading ? 'Kaydediliyor...' : 'Kaydet'),
                      icon: _isLoading ? null : Icons.save,
                      onPressed: _isLoading ? null : _saveDepartment,
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
