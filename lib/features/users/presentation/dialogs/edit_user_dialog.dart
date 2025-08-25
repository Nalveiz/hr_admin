import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_role.dart';
import '../../data/models/user_dto.dart';
import '../cubit/users_cubit.dart';
import '../../../../shared/shared.dart'
    hide UserRole, CreateUserDto, UpdateUserDto;

class EditUserDialog extends StatefulWidget {
  final User user;

  const EditUserDialog({super.key, required this.user});

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _noteController;
  late UserRole _selectedRole;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name ?? '');
    _surnameController = TextEditingController(text: widget.user.surname ?? '');
    _emailController = TextEditingController(text: widget.user.email ?? '');
    _phoneController = TextEditingController(text: widget.user.phone ?? '');
    _addressController = TextEditingController(text: widget.user.address ?? '');
    _noteController = TextEditingController(text: widget.user.note ?? '');
    _selectedRole = UserRoleExtension.fromInt(widget.user.role ?? 0);
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

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.personel:
        return 'Personel';
      case UserRole.manager:
        return 'Müdür';
      case UserRole.hr:
        return 'İK';
      case UserRole.superUser:
        return 'Süper Kullanıcı';
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final dto = UpdateUserDto(
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        email: _emailController.text.trim(),
        role: _selectedRole,
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        companyId: widget.user.companyId ?? 'default-company',
        managerId: widget.user.managerId,
        departmentIds: widget.user.departmentIds ?? [],
        teamIds: widget.user.teamIds ?? [],
      );

      context.read<UsersCubit>().add(UpdateUser(widget.user.id!, dto));
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      // Hata mesajı cubit'te handle edilecek
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
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kullanıcıyı Düzenle',
                style: AppThemeTextStyles.of(context).heading3,
              ),
              const SizedBox(height: 24),

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
                    child: DropdownButtonFormField<UserRole>(
                      value: _selectedRole,
                      decoration: InputDecoration(
                        labelText: 'Rol*',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: UserRole.values
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
                    text: Text(_isLoading ? 'Güncelleniyor...' : 'Güncelle'),
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
}
