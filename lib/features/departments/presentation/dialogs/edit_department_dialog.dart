import 'package:flutter/material.dart';
import '../../data/services/department_service.dart';
import '../../data/models/department_model.dart' as dept_model;
import '../../domain/entities/department.dart';
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
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();

  bool _isLoading = false;
  bool _isActive = true;
  late final DepartmentService _departmentService;

  @override
  void initState() {
    super.initState();
    _departmentService = DepartmentService(sl());

    // Initialize form with department data
    _nameController.text = widget.department.name;
    _descriptionController.text = widget.department.description ?? '';
    _budgetController.text = widget.department.budget ?? '';
    _isActive = widget.department.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _updateDepartment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final departmentModel = dept_model.DepartmentModel(
        id: widget.department.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        managerId: widget.department.managerId,
        managerName: widget.department.managerName,
        employeeCount: widget.department.employeeCount, // Kullanici sayisi
        budget: _budgetController.text.trim().isEmpty
            ? null
            : _budgetController.text.trim(),
        isActive: _isActive,
        createdAt: widget.department.createdAt,
        updatedAt: DateTime.now(),
      );

      final response = await _departmentService.updateDepartment(
        widget.department.id,
        departmentModel,
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
                      AppTextFormField(
                        controller: _nameController,
                        label: 'Departman Adı *',
                        prefixIcon: Icons.apartment,
                        validator: AppValidators.required,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),
                      AppTextFormField(
                        controller: _descriptionController,
                        label: 'Açıklama',
                        prefixIcon: Icons.description,
                        maxLines: 3,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),
                      AppTextFormField(
                        controller: _budgetController,
                        label: 'Bütçe',
                        prefixIcon: Icons.attach_money,
                        keyboardType: TextInputType.number,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),
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
