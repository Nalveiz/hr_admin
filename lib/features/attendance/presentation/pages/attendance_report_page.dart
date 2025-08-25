import 'package:flutter/material.dart';
import '../../../../shared/shared.dart';

class AttendanceReportPage extends StatefulWidget {
  const AttendanceReportPage({super.key});

  @override
  State<AttendanceReportPage> createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedDepartment = 'Tümü';
  String _selectedEmployee = 'Tümü';

  final List<String> _departments = [
    'Tümü',
    'IT',
    'İnsan Kaynakları',
    'Satış',
    'Pazarlama',
    'Finans',
    'Operasyon',
  ];

  final List<Map<String, dynamic>> _mockAttendanceData = [
    {
      'employee': 'Ahmet Yılmaz',
      'department': 'IT',
      'date': '2024-01-15',
      'checkIn': '09:00',
      'checkOut': '18:30',
      'workingHours': '8.5',
      'status': 'Tam Gün',
    },
    {
      'employee': 'Fatma Kaya',
      'department': 'İnsan Kaynakları',
      'date': '2024-01-15',
      'checkIn': '08:45',
      'checkOut': '17:45',
      'workingHours': '8.0',
      'status': 'Tam Gün',
    },
    {
      'employee': 'Mehmet Demir',
      'department': 'Satış',
      'date': '2024-01-15',
      'checkIn': '10:00',
      'checkOut': '16:00',
      'workingHours': '5.0',
      'status': 'Yarım Gün',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoklama Raporu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
            tooltip: 'Raporu İndir',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: responsive.paddingAll(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtreler
            _buildFiltersSection(responsive),
            SizedBox(height: responsive.spacing(24)),

            // İstatistikler
            _buildStatsSection(responsive),
            SizedBox(height: responsive.spacing(24)),

            // Rapor Tablosu
            _buildReportTable(responsive),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection(ResponsiveUtils responsive) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filtreler', style: AppTextStyles.heading3),
            SizedBox(height: responsive.spacing(16)),
            responsive.isMobile
                ? Column(
                    children: [
                      _buildDateRangeFields(responsive),
                      SizedBox(height: responsive.formFieldSpacing),
                      _buildDropdownFields(responsive),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildDateRangeFields(responsive),
                      ),
                      SizedBox(width: responsive.formFieldSpacing),
                      Expanded(
                        flex: 2,
                        child: _buildDropdownFields(responsive),
                      ),
                    ],
                  ),
            SizedBox(height: responsive.spacing(16)),
            Row(
              children: [
                AppButton.primary(
                  text: Text('Rapor Oluştur'),
                  onPressed: _generateReport,
                  icon: Icons.search,
                ),
                const SizedBox(width: 12),
                AppButton.secondary(
                  text: Text('Temizle'),
                  onPressed: _clearFilters,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeFields(ResponsiveUtils responsive) {
    return Row(
      children: [
        Expanded(
          child: AppDateField(
            label: 'Başlangıç Tarihi',
            selectedDate: _startDate,
            onChanged: (date) => setState(() => _startDate = date),
            prefixIcon: Icons.calendar_today,
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now(),
          ),
        ),
        SizedBox(width: responsive.formFieldSpacing),
        Expanded(
          child: AppDateField(
            label: 'Bitiş Tarihi',
            selectedDate: _endDate,
            onChanged: (date) => setState(() => _endDate = date),
            prefixIcon: Icons.event,
            firstDate:
                _startDate ??
                DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownFields(ResponsiveUtils responsive) {
    return Row(
      children: [
        Expanded(
          child: AppDropdownField<String>(
            label: 'Departman',
            value: _selectedDepartment,
            prefixIcon: Icons.apartment,
            items: _departments.map((dept) {
              return DropdownMenuItem(value: dept, child: Text(dept));
            }).toList(),
            onChanged: (value) => setState(() => _selectedDepartment = value!),
          ),
        ),
        SizedBox(width: responsive.formFieldSpacing),
        Expanded(
          child: AppDropdownField<String>(
            label: 'Çalışan',
            value: _selectedEmployee,
            prefixIcon: Icons.person,
            items: const [
              DropdownMenuItem(value: 'Tümü', child: Text('Tümü')),
              DropdownMenuItem(
                value: 'Ahmet Yılmaz',
                child: Text('Ahmet Yılmaz'),
              ),
              DropdownMenuItem(value: 'Fatma Kaya', child: Text('Fatma Kaya')),
              DropdownMenuItem(
                value: 'Mehmet Demir',
                child: Text('Mehmet Demir'),
              ),
            ],
            onChanged: (value) => setState(() => _selectedEmployee = value!),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(ResponsiveUtils responsive) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Toplam Çalışan',
            '25',
            Icons.people,
            AppColors.primaryColor,
          ),
        ),
        SizedBox(width: responsive.spacing(16)),
        Expanded(
          child: _buildStatCard(
            'Bugün Gelen',
            '23',
            Icons.check_circle,
            AppColors.successColor,
          ),
        ),
        SizedBox(width: responsive.spacing(16)),
        Expanded(
          child: _buildStatCard(
            'Geç Kalan',
            '2',
            Icons.access_time,
            AppColors.warningColor,
          ),
        ),
        SizedBox(width: responsive.spacing(16)),
        Expanded(
          child: _buildStatCard(
            'İzinli',
            '1',
            Icons.event_note,
            AppColors.infoColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(value, style: AppTextStyles.heading2.copyWith(color: color)),
            Text(
              title,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTable(ResponsiveUtils responsive) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Yoklama Detayları', style: AppTextStyles.heading3),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Çalışan')),
                  DataColumn(label: Text('Departman')),
                  DataColumn(label: Text('Tarih')),
                  DataColumn(label: Text('Giriş')),
                  DataColumn(label: Text('Çıkış')),
                  DataColumn(label: Text('Çalışma Saati')),
                  DataColumn(label: Text('Durum')),
                ],
                rows: _mockAttendanceData.map((data) {
                  return DataRow(
                    cells: [
                      DataCell(Text(data['employee'])),
                      DataCell(Text(data['department'])),
                      DataCell(Text(data['date'])),
                      DataCell(Text(data['checkIn'])),
                      DataCell(Text(data['checkOut'])),
                      DataCell(Text('${data['workingHours']} saat')),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: data['status'] == 'Tam Gün'
                                ? AppColors.successColor.withValues(alpha: 0.1)
                                : AppColors.warningColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            data['status'],
                            style: TextStyle(
                              color: data['status'] == 'Tam Gün'
                                  ? AppColors.successColor
                                  : AppColors.warningColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateReport() {
    // Validate date range
    if (_startDate != null &&
        _endDate != null &&
        _startDate!.isAfter(_endDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Başlangıç tarihi bitiş tarihinden büyük olamaz'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Apply filters and generate report
    final filteredData = _mockAttendanceData.where((data) {
      bool matchesDepartment =
          _selectedDepartment == 'Tümü' ||
          data['department'] == _selectedDepartment;
      bool matchesEmployee =
          _selectedEmployee == 'Tümü' || data['employee'] == _selectedEmployee;

      // Date filtering would be implemented when real API is available
      // For now, just use department and employee filters
      return matchesDepartment && matchesEmployee;
    }).toList();

    // Show result
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${filteredData.length} kayıt bulundu'),
        backgroundColor: Colors.blue,
      ),
    );

    // In a real implementation, this would call an API endpoint like:
    // final attendanceService = sl<AttendanceService>();
    // final response = await attendanceService.generateReport(
    //   startDate: _startDate,
    //   endDate: _endDate,
    //   department: _selectedDepartment == 'Tümü' ? null : _selectedDepartment,
    //   employee: _selectedEmployee == 'Tümü' ? null : _selectedEmployee,
    // );
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedDepartment = 'Tümü';
      _selectedEmployee = 'Tümü';
    });
  }

  void _exportReport() {
    // Apply current filters to get the data to export
    final filteredData = _mockAttendanceData.where((data) {
      bool matchesDepartment =
          _selectedDepartment == 'Tümü' ||
          data['department'] == _selectedDepartment;
      bool matchesEmployee =
          _selectedEmployee == 'Tümü' || data['employee'] == _selectedEmployee;
      return matchesDepartment && matchesEmployee;
    }).toList();

    if (filteredData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dışa aktarılacak veri bulunamadı'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show export success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${filteredData.length} kayıt Excel formatında dışa aktarıldı',
        ),
        backgroundColor: Colors.green,
      ),
    );

    // In a real implementation, this would export the data to Excel/PDF:
    // final exportService = sl<ExportService>();
    // await exportService.exportToExcel(
    //   data: filteredData,
    //   fileName: 'attendance_report_${DateTime.now().millisecondsSinceEpoch}.xlsx',
    //   headers: ['Çalışan', 'Departman', 'Tarih', 'Giriş', 'Çıkış', 'Çalışma Saati', 'Durum'],
    // );
  }
}
