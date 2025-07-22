import 'package:flutter/material.dart';
import 'package:hr_admin/features/employees/domain/entities/employee.dart';
import '../../../../shared/shared.dart';

enum EmployeeFormMode { create, edit }

class EmployeeForm extends StatefulWidget {
  final EmployeeFormMode mode;
  final Employee? initialData;
  final void Function(Map<String, dynamic> values) onSubmit;
  final bool isLoading;

  const EmployeeForm({
    super.key,
    required this.mode,
    this.initialData,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _companyController;
  late final TextEditingController _addressController;
  late final TextEditingController _noteController;

  String _selectedDepartment = 'IT';
  String _selectedRole = 'Employee';
  String _selectedPosition = 'IT';
  DateTime? _employmentStartDate;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    _firstNameController = TextEditingController(text: d?.name ?? '');
    _lastNameController = TextEditingController(text: d?.surname ?? '');
    _emailController = TextEditingController(text: d?.email ?? '');
    _phoneController = TextEditingController(text: d?.phone ?? '');
    _companyController = TextEditingController(text: d?.company ?? '');
    _addressController = TextEditingController(text: d?.address ?? '');
    _noteController = TextEditingController(text: d?.note ?? '');
    _selectedDepartment = d?.department ?? 'IT';
    _selectedRole = d?.role ?? 'Employee';
    _selectedPosition = d?.position ?? 'IT';
    _employmentStartDate = d?.employmentStartDate;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: responsive.paddingAll(responsive.isMobile ? 16 : 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: responsive.isMobile ? double.infinity : 800,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Info
              _buildSectionHeader('Kişisel Bilgiler'),
              SizedBox(height: responsive.spacing(16)),
              _buildPersonalInfoSection(responsive),
              SizedBox(height: responsive.spacing(32)),
              // Work Info
              _buildSectionHeader('İş Bilgileri'),
              SizedBox(height: responsive.spacing(16)),
              _buildWorkInfoSection(responsive),
              SizedBox(height: responsive.spacing(32)),
              // Action Button
              _buildActionButton(responsive),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.heading3.copyWith(color: AppColors.primaryColor),
    );
  }

  Widget _buildPersonalInfoSection(ResponsiveUtils responsive) {
    return Column(
      children: [
        responsive.isMobile
            ? Column(
                children: [
                  AppTextFormField(
                    label: AppStrings.name,
                    controller: _firstNameController,
                    prefixIcon: Icons.person,
                    validator: AppValidators.required,
                  ),
                  SizedBox(height: responsive.formFieldSpacing),
                  AppTextFormField(
                    label: AppStrings.surname,
                    controller: _lastNameController,
                    prefixIcon: Icons.person,
                    validator: AppValidators.required,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: AppTextFormField(
                      label: AppStrings.name,
                      controller: _firstNameController,
                      prefixIcon: Icons.person,
                      validator: AppValidators.required,
                    ),
                  ),
                  SizedBox(width: responsive.formFieldSpacing),
                  Expanded(
                    child: AppTextFormField(
                      label: AppStrings.surname,
                      controller: _lastNameController,
                      prefixIcon: Icons.person,
                      validator: AppValidators.required,
                    ),
                  ),
                ],
              ),
        SizedBox(height: responsive.formFieldSpacing),
        AppTextFormField(
          label: AppStrings.email,
          controller: _emailController,
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: AppValidators.email,
        ),
        SizedBox(height: responsive.formFieldSpacing),
        AppTextFormField(
          label: AppStrings.phone,
          controller: _phoneController,
          prefixIcon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: AppValidators.required,
        ),
        SizedBox(height: responsive.formFieldSpacing),
        AppTextFormField(
          label: AppStrings.address,
          controller: _addressController,
          prefixIcon: Icons.location_on,
          maxLines: 3,
        ),
        SizedBox(height: responsive.formFieldSpacing),
        AppTextFormField(
          label: 'Not',
          controller: _noteController,
          prefixIcon: Icons.note,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildWorkInfoSection(ResponsiveUtils responsive) {
    return Column(
      children: [
        AppTextFormField(
          label: 'Şirket',
          controller: _companyController,
          prefixIcon: Icons.business,
          validator: AppValidators.required,
        ),
        SizedBox(height: responsive.formFieldSpacing),
        AppDropdownField<String>(
          label: 'Pozisyon',
          value: _selectedPosition,
          prefixIcon: Icons.person_outline,
          items: const [
            DropdownMenuItem(
              value: 'Operations',
              child: Text('Yazılım Geliştirici'),
            ),
            DropdownMenuItem(value: 'Sales', child: Text('Satış Temsilcisi')),
            DropdownMenuItem(value: 'Finance', child: Text('Muhasebe Uzmanı')),
            DropdownMenuItem(value: 'IT', child: Text('Teknik Destek Uzmanı')),
            DropdownMenuItem(
              value: 'Marketing',
              child: Text('Pazarlama Asistanı'),
            ),
            DropdownMenuItem(
              value: 'HR',
              child: Text('İnsan Kaynakları Asistanı'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedPosition = value!;
            });
          },
        ),
        SizedBox(height: responsive.formFieldSpacing),
        AppDropdownField<String>(
          label: 'Rol',
          value: _selectedRole,
          prefixIcon: Icons.person_outline,
          items: const [
            DropdownMenuItem(value: 'Employee', child: Text('Çalışan')),
            DropdownMenuItem(value: 'Manager', child: Text('Yönetici')),
            DropdownMenuItem(value: 'Admin', child: Text('Admin')),
            DropdownMenuItem(value: 'HR', child: Text('İK Uzmanı')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedRole = value!;
            });
          },
        ),
        SizedBox(height: responsive.formFieldSpacing),
        AppDropdownField<String>(
          label: AppStrings.department,
          value: _selectedDepartment,
          prefixIcon: Icons.apartment,
          items: const [
            DropdownMenuItem(value: 'IT', child: Text('IT')),
            DropdownMenuItem(value: 'HR', child: Text('İnsan Kaynakları')),
            DropdownMenuItem(value: 'Sales', child: Text('Satış')),
            DropdownMenuItem(value: 'Marketing', child: Text('Pazarlama')),
            DropdownMenuItem(value: 'Finance', child: Text('Finans')),
            DropdownMenuItem(value: 'Operations', child: Text('Operasyon')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedDepartment = value!;
            });
          },
        ),
        SizedBox(height: responsive.formFieldSpacing),
        AppDateField(
          label: 'İşe Başlama Tarihi',
          selectedDate: _employmentStartDate,
          onChanged: (date) => setState(() => _employmentStartDate = date),
          prefixIcon: Icons.work_history,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          validator: (date) =>
              date == null ? 'Lütfen işe başlama tarihini seçin' : null,
        ),
      ],
    );
  }

  Widget _buildActionButton(ResponsiveUtils responsive) {
    return AppButton.primary(
      text: Text(widget.mode == EmployeeFormMode.create ? 'Ekle' : 'Güncelle'),
      icon: widget.mode == EmployeeFormMode.create ? Icons.save : Icons.edit,
      onPressed: widget.isLoading
          ? null
          : () {
              if (!_formKey.currentState!.validate()) return;
              widget.onSubmit({
                'name': _firstNameController.text.trim(),
                'surname': _lastNameController.text.trim(),
                'email': _emailController.text.trim(),
                'role': _selectedRole,
                'department': _selectedDepartment,
                'company': _companyController.text.trim(),
                'position': _selectedPosition,
                'employmentStartDate': _employmentStartDate,
                'phone': _phoneController.text.trim(),
                'address': _addressController.text.trim().isEmpty
                    ? null
                    : _addressController.text.trim(),
                'note': _noteController.text.trim().isEmpty
                    ? null
                    : _noteController.text.trim(),
              });
            },
    );
  }
}
