import 'package:flutter/material.dart';
import 'package:hr_admin/features/teams/data/services/team_service.dart';
import 'package:hr_admin/features/teams/data/dtos/team_dtos.dart';
import 'package:hr_admin/injection_container.dart';
import '../../../../shared/shared.dart';

class AddTeamDialog extends StatefulWidget {
  const AddTeamDialog({super.key});

  @override
  State<AddTeamDialog> createState() => _AddTeamDialogState();
}

class _AddTeamDialogState extends State<AddTeamDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _departmentIdController = TextEditingController();

  bool _isLoading = false;
  late final TeamService _teamService;

  @override
  void initState() {
    super.initState();
    _teamService = sl<TeamService>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _departmentIdController.dispose();
    super.dispose();
  }

  Future<void> _saveTeam() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final dto = CreateTeamDto(
        name: _nameController.text.trim(),
        departmentId: _departmentIdController.text.trim(),
      );

      final response = await _teamService.createTeam(dto);

      if (!mounted) return;

      if (response.isSuccess) {
        sl<SnackBarService>().showSuccess(context, 'Takım başarıyla eklendi');
        Navigator.of(context).pop(true);
      } else {
        sl<SnackBarService>().showError(
          context,
          response.error ?? 'Takım eklenirken bir hata oluştu',
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
                  Icon(Icons.groups, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Yeni Takım Ekle',
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
                        label: 'Takım Adı *',
                        prefixIcon: Icons.groups,
                        validator: AppValidators.required,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),
                      AppTextFormField(
                        controller: _departmentIdController,
                        label: 'Departman ID *',
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
                      onPressed: _isLoading ? null : _saveTeam,
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
