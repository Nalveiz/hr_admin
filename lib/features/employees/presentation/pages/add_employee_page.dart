import 'package:flutter/material.dart';
import '../../../../shared/shared.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _positionController = TextEditingController();
  final _salaryController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyContactController = TextEditingController();

  String _selectedDepartment = 'IT';
  DateTime? _hireDate;
  DateTime? _birthDate;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    _salaryController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Çalışan Ekle'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppButton.primary(
              text: AppStrings.save,
              onPressed: _saveEmployee,
              icon: Icons.save,
              size: ButtonSize.small,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Information Section
              _buildSectionHeader('Kişisel Bilgiler'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppTextFormField(
                      label: AppStrings.firstName,
                      controller: _firstNameController,
                      prefixIcon: Icons.person,
                      validator: AppValidators.required,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppTextFormField(
                      label: AppStrings.lastName,
                      controller: _lastNameController,
                      prefixIcon: Icons.person,
                      validator: AppValidators.required,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                label: AppStrings.email,
                controller: _emailController,
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: AppValidators.email,
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                label: AppStrings.phone,
                controller: _phoneController,
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: AppValidators.required,
              ),
              const SizedBox(height: 16),
              AppDateField(
                label: AppStrings.birthDate,
                selectedDate: _birthDate,
                onChanged: (date) => setState(() => _birthDate = date),
                prefixIcon: Icons.calendar_today,
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                label: AppStrings.address,
                controller: _addressController,
                prefixIcon: Icons.location_on,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                label: AppStrings.emergencyContact,
                controller: _emergencyContactController,
                prefixIcon: Icons.emergency,
              ),

              const SizedBox(height: 32),

              // Work Information Section
              _buildSectionHeader('İş Bilgileri'),
              const SizedBox(height: 16),
              AppTextFormField(
                label: AppStrings.position,
                controller: _positionController,
                prefixIcon: Icons.work,
                validator: AppValidators.required,
              ),
              const SizedBox(height: 16),
              AppDropdownField<String>(
                label: AppStrings.department,
                value: _selectedDepartment,
                prefixIcon: Icons.apartment,
                items: const [
                  DropdownMenuItem(value: 'IT', child: Text('IT')),
                  DropdownMenuItem(
                    value: 'HR',
                    child: Text('İnsan Kaynakları'),
                  ),
                  DropdownMenuItem(value: 'Sales', child: Text('Satış')),
                  DropdownMenuItem(
                    value: 'Marketing',
                    child: Text('Pazarlama'),
                  ),
                  DropdownMenuItem(value: 'Finance', child: Text('Finans')),
                  DropdownMenuItem(
                    value: 'Operations',
                    child: Text('Operasyon'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              AppDateField(
                label: AppStrings.hireDate,
                selectedDate: _hireDate,
                onChanged: (date) => setState(() => _hireDate = date),
                prefixIcon: Icons.work_history,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                label: AppStrings.salary,
                controller: _salaryController,
                prefixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: AppValidators.positiveNumber,
                hint: '₺',
              ),

              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton.secondary(
                      text: AppStrings.cancel,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton.primary(
                      text: AppStrings.save,
                      onPressed: _saveEmployee,
                      icon: Icons.save,
                    ),
                  ),
                ],
              ),
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

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      if (_hireDate == null) {
        AppSnackBar.showError(context, 'Lütfen işe başlama tarihini seçin');
        return;
      }

      AppSnackBar.showSuccess(context, 'Çalışan başarıyla eklendi');
      Navigator.of(context).pop();
    }
  }
}
