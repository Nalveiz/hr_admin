import 'package:flutter/material.dart';
import 'package:hr_admin/features/companies/data/services/company_service.dart';
import 'package:hr_admin/features/companies/data/dtos/company_dtos.dart';
import 'package:hr_admin/injection_container.dart';
import '../../../../shared/shared.dart';

class AddCompanyDialog extends StatefulWidget {
  const AddCompanyDialog({super.key});

  @override
  State<AddCompanyDialog> createState() => _AddCompanyDialogState();
}

class _AddCompanyDialogState extends State<AddCompanyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  late final CompanyService _companyService;

  @override
  void initState() {
    super.initState();
    _companyService = sl<CompanyService>();
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

  Future<void> _saveCompany() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final dto = CreateCompanyDto(
        name: _nameController.text.trim(),
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

      final response = await _companyService.createCompany(dto);

      if (!mounted) return;

      if (response.isSuccess) {
        sl<SnackBarService>().showSuccess(context, 'Şirket başarıyla eklendi');
        Navigator.of(context).pop(true);
      } else {
        sl<SnackBarService>().showError(
          context,
          response.error ?? 'Şirket eklenirken bir hata oluştu',
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
                  Icon(Icons.business, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Yeni Şirket Ekle',
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
                      onPressed: _isLoading ? null : _saveCompany,
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
