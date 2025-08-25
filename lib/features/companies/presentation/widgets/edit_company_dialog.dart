import 'package:flutter/material.dart';
import 'package:hr_admin/features/companies/data/services/company_service.dart';
import 'package:hr_admin/features/companies/data/dtos/company_dtos.dart';
import 'package:hr_admin/injection_container.dart';
import '../../../../shared/shared.dart';

class EditCompanyDialog extends StatefulWidget {
  final CompanyModel company;

  const EditCompanyDialog({super.key, required this.company});

  @override
  State<EditCompanyDialog> createState() => _EditCompanyDialogState();
}

class _EditCompanyDialogState extends State<EditCompanyDialog> {
  final _formKey = GlobalKey<FormState>();
  late bool _isValid;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  bool _isLoading = false;
  late final CompanyService _companyService;

  @override
  void initState() {
    super.initState();
    _companyService = sl<CompanyService>();

    _nameController = TextEditingController(text: widget.company.name);
    _descriptionController = TextEditingController(text: '');
    _addressController = TextEditingController(text: '');
    _phoneController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _isValid = widget.company.valid ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateCompany() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final dto = UpdateCompanyDto(
        name: _nameController.text.trim(),
        valid: _isValid,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
      );

      final response = await _companyService.updateCompany(
        widget.company.id,
        dto,
      );

      if (!mounted) return;

      if (response.isSuccess) {
        sl<SnackBarService>().showSuccess(
          context,
          'Şirket başarıyla güncellendi',
        );
        Navigator.of(context).pop(true);
      } else {
        sl<SnackBarService>().showError(
          context,
          response.error ?? 'Şirket güncellenirken bir hata oluştu',
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
                    'Şirket Düzenle',
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
                      AppTextFormField(
                        controller: _nameController,
                        label: 'Şirket Adı *',
                        prefixIcon: Icons.business,
                        validator: AppValidators.required,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Switch(
                            value: _isValid,
                            onChanged: _isLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      _isValid = value;
                                    });
                                  },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isValid ? "Aktif" : "Pasif",
                            style: AppThemeTextStyles.of(context).body1,
                          ),
                        ],
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
                      onPressed: _isLoading ? null : _updateCompany,
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
