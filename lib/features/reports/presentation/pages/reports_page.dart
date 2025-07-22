import 'package:flutter/material.dart';
import '../../../../shared/shared.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: responsive.paddingAll(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text('Raporlar', style: AppThemeTextStyles.of(context).heading2),
            SizedBox(height: responsive.spacing(8)),
            Text(
              'Çeşitli raporları görüntüleyin ve indirin',
              style: AppThemeTextStyles.of(context).body1,
            ),
            SizedBox(height: responsive.spacing(32)),

            // Rapor Kategorileri
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: responsive.isMobile ? 1 : 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: responsive.isMobile ? 4 : 1.2,
              children: [
                _buildReportCard(
                  context,
                  'Çalışan Raporları',
                  'Çalışan listesi ve detayları',
                  Icons.people,
                  AppColors.primaryColor,
                  () => _generateEmployeeReport(context),
                ),
                _buildReportCard(
                  context,
                  'Yoklama Raporları',
                  'Devam durumu ve mesai saatleri',
                  Icons.access_time,
                  AppColors.infoColor,
                  () => _generateAttendanceReport(context),
                ),
                _buildReportCard(
                  context,
                  'İzin Raporları',
                  'İzin talepleri ve kullanımları',
                  Icons.event_note,
                  AppColors.warningColor,
                  () => _generateLeaveReport(context),
                ),
                _buildReportCard(
                  context,
                  'Bordro Raporları',
                  'Maaş ve ödeme raporları',
                  Icons.account_balance_wallet,
                  AppColors.successColor,
                  () => _generatePayrollReport(context),
                ),
                _buildReportCard(
                  context,
                  'Performans Raporları',
                  'Çalışan performans değerlendirmeleri',
                  Icons.assessment,
                  AppColors.errorColor,
                  () => _generatePerformanceReport(context),
                ),
                _buildReportCard(
                  context,
                  'Departman Raporları',
                  'Departman bazlı analiz ve istatistikler',
                  Icons.apartment,
                  AppColors.primaryColor.withValues(alpha: 0.7),
                  () => _generateDepartmentReport(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: AppThemeTextStyles.of(context).subtitle1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _generateEmployeeReport(BuildContext context) {
    _showComingSoonDialog(context, 'Çalışan Raporu');
  }

  void _generateAttendanceReport(BuildContext context) {
    _showComingSoonDialog(context, 'Yoklama Raporu');
  }

  void _generateLeaveReport(BuildContext context) {
    _showComingSoonDialog(context, 'İzin Raporu');
  }

  void _generatePayrollReport(BuildContext context) {
    _showComingSoonDialog(context, 'Bordro Raporu');
  }

  void _generatePerformanceReport(BuildContext context) {
    _showComingSoonDialog(context, 'Performans Raporu');
  }

  void _generateDepartmentReport(BuildContext context) {
    _showComingSoonDialog(context, 'Departman Raporu');
  }

  void _showComingSoonDialog(BuildContext context, String reportType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(reportType),
        content: Text('$reportType özelliği yakında eklenecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}
