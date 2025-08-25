import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/users_cubit_new.dart';
import '../../../../shared/shared.dart';
import '../../../../injection_container.dart';

class EditUserDialogNew extends StatefulWidget {
  final UserEntity user;

  const EditUserDialogNew({super.key, required this.user});

  @override
  State<EditUserDialogNew> createState() => _EditUserDialogNewState();
}

class _EditUserDialogNewState extends State<EditUserDialogNew> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  final _companyIdController = TextEditingController();
  final _managerIdController = TextEditingController();

  late UserRoleEntity _selectedRole;
  DateTime? _employmentStartDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _nameController.text = widget.user.name;
    _surnameController.text = widget.user.surname;
    _emailController.text = widget.user.email;
    _phoneController.text = widget.user.phone ?? '';
    _addressController.text = widget.user.address ?? '';
    _noteController.text = widget.user.note ?? '';
    _companyIdController.text = widget.user.companyId;
    _managerIdController.text = widget.user.managerId ?? '';
    _selectedRole = widget.user.role;
    _employmentStartDate = widget.user.employmentStartDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    _companyIdController.dispose();
    _managerIdController.dispose();
    super.dispose();
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

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _employmentStartDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _employmentStartDate = date;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await sl<UsersCubitNew>().updateUser(
        id: widget.user.id,
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        email: _emailController.text.trim(),
        role: _selectedRole,
        companyId: _companyIdController.text.trim(),
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
        managerId: _managerIdController.text.trim().isEmpty
            ? null
            : _managerIdController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop(true);
        sl<SnackBarService>().showSuccess(
          context,
          'Kullanıcı başarıyla güncellendi',
        );
      }
    } catch (e) {
      if (mounted) {
        sl<SnackBarService>().showError(
          context,
          'Kullanıcı güncellenirken hata oluştu: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Dialog(
      child: Container(
        width: responsive.isMobile ? double.infinity : 600,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.edit,
                  color: AppThemeColors.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Kullanıcıyı Düzenle',
                    style: AppThemeTextStyles.of(context).heading3,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Form
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Name and Surname
                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              controller: _nameController,
                              label: 'Ad *',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Ad gerekli';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppTextFormField(
                              controller: _surnameController,
                              label: 'Soyad *',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Soyad gerekli';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email
                      AppTextFormField(
                        controller: _emailController,
                        label: 'E-posta *',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'E-posta gerekli';
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

                      // Role and Company ID
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<UserRoleEntity>(
                              value: _selectedRole,
                              decoration: const InputDecoration(
                                labelText: 'Rol *',
                                border: OutlineInputBorder(),
                              ),
                              items: UserRoleEntity.values
                                  .map(
                                    (role) => DropdownMenuItem<UserRoleEntity>(
                                      value: role,
                                      child: Text(_getRoleDisplayName(role)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedRole = value;
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Rol seçiniz';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppTextFormField(
                              controller: _companyIdController,
                              label: 'Şirket ID *',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Şirket ID gerekli';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Phone and Employment Start Date
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
                            child: InkWell(
                              onTap: _selectDate,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'İşe Başlama Tarihi',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                child: Text(
                                  _employmentStartDate != null
                                      ? '${_employmentStartDate!.day}/${_employmentStartDate!.month}/${_employmentStartDate!.year}'
                                      : 'Tarih seçin',
                                  style: _employmentStartDate != null
                                      ? null
                                      : TextStyle(
                                          color: AppThemeColors.of(
                                            context,
                                          ).textSecondary,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Manager ID
                      AppTextFormField(
                        controller: _managerIdController,
                        label: 'Yönetici ID',
                      ),
                      const SizedBox(height: 16),

                      // Address
                      AppTextFormField(
                        controller: _addressController,
                        label: 'Adres',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // Note
                      AppTextFormField(
                        controller: _noteController,
                        label: 'Not',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton.secondary(
                  text: const Text('İptal'),
                  onPressed: _isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                AppButton.primary(
                  text: Text(_isLoading ? 'Güncelleniyor...' : 'Güncelle'),
                  onPressed: _isLoading ? null : _submit,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
