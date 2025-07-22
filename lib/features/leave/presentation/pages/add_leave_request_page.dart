import 'package:flutter/material.dart';
import '../../../../shared/shared.dart';

class AddLeaveRequestPage extends StatefulWidget {
  const AddLeaveRequestPage({super.key});

  @override
  State<AddLeaveRequestPage> createState() => _AddLeaveRequestPageState();
}

class _AddLeaveRequestPageState extends State<AddLeaveRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  String _selectedLeaveType = 'Yıllık İzin';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  final List<String> _leaveTypes = [
    'Yıllık İzin',
    'Hastalık İzni',
    'Mazeret İzni',
    'Doğum İzni',
    'Babalık İzni',
    'Ücretsiz İzin',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni İzin Talebi'),
        actions: [
          Padding(
            padding: responsive.paddingAll(8.0),
            child: AppButton.primary(
              text: Text('Gönder'),
              onPressed: _isLoading ? null : _submitRequest,
              icon: _isLoading ? null : Icons.send,
              size: ButtonSize.small,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: responsive.paddingAll(responsive.isMobile ? 16 : 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: responsive.isMobile ? double.infinity : 600,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'İzin Talebi Bilgileri',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: responsive.spacing(24)),

                      // İzin Türü
                      AppDropdownField<String>(
                        label: 'İzin Türü',
                        value: _selectedLeaveType,
                        prefixIcon: Icons.category,
                        items: _leaveTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLeaveType = value!;
                          });
                        },
                      ),
                      SizedBox(height: responsive.formFieldSpacing),

                      // Başlangıç Tarihi
                      AppDateField(
                        label: 'Başlangıç Tarihi',
                        selectedDate: _startDate,
                        onChanged: (date) => setState(() => _startDate = date),
                        prefixIcon: Icons.calendar_today,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        validator: (date) =>
                            date == null ? 'Başlangıç tarihi gerekli' : null,
                      ),
                      SizedBox(height: responsive.formFieldSpacing),

                      // Bitiş Tarihi
                      AppDateField(
                        label: 'Bitiş Tarihi',
                        selectedDate: _endDate,
                        onChanged: (date) => setState(() => _endDate = date),
                        prefixIcon: Icons.event,
                        firstDate: _startDate ?? DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        validator: (date) =>
                            date == null ? 'Bitiş tarihi gerekli' : null,
                      ),
                      SizedBox(height: responsive.formFieldSpacing),

                      // İzin Süresi Bilgisi
                      if (_startDate != null && _endDate != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'İzin Süresi: ${_calculateLeaveDays()} gün',
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: responsive.formFieldSpacing),

                      // Açıklama
                      AppTextFormField(
                        label: 'Açıklama/Gerekçe',
                        controller: _reasonController,
                        prefixIcon: Icons.description,
                        maxLines: 4,
                        validator: AppValidators.required,
                      ),
                      SizedBox(height: responsive.spacing(32)),

                      // Butonlar
                      _buildActionButtons(responsive),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildActionButtons(ResponsiveUtils responsive) {
    return responsive.isMobile
        ? Column(
            children: [
              AppButton.secondary(
                text: Text('İptal'),
                onPressed: _isLoading
                    ? null
                    : () => Navigator.of(context).pop(),
              ),
              SizedBox(height: responsive.formFieldSpacing),
              AppButton.primary(
                text: Text('Gönder'),
                onPressed: _isLoading ? null : _submitRequest,
                icon: _isLoading ? null : Icons.send,
              ),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: AppButton.secondary(
                  text: Text('İptal'),
                  onPressed: _isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                ),
              ),
              SizedBox(width: responsive.formFieldSpacing),
              Expanded(
                child: AppButton.primary(
                  text: Text('Gönder'),
                  onPressed: _isLoading ? null : _submitRequest,
                  icon: _isLoading ? null : Icons.send,
                ),
              ),
            ],
          );
  }

  int _calculateLeaveDays() {
    if (_startDate == null || _endDate == null) return 0;
    return _endDate!.difference(_startDate!).inDays + 1;
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen başlangıç ve bitiş tarihlerini seçin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitiş tarihi başlangıç tarihinden önce olamaz'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: API çağrısı yapılacak
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('İzin talebiniz başarıyla gönderildi'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
