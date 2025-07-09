import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/chart_card.dart';
import '../widgets/recent_activities.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);
    final themeTextStyles = AppThemeTextStyles.of(context);

    return Scaffold(
      backgroundColor: themeColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            Row(
              children: [
                // Company Logo (küçük)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    AppConstants.logoMiniPath,
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: themeColors.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.business,
                          color: Colors.white,
                          size: 16,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Text(AppStrings.dashboard, style: themeTextStyles.heading2),
                const Spacer(),
                Text(
                  'Hoş geldiniz, Admin',
                  style: themeTextStyles.subtitle1.copyWith(
                    color: themeColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Stats Cards
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 1200
                    ? 4
                    : constraints.maxWidth > 800
                    ? 3
                    : constraints.maxWidth > 600
                    ? 2
                    : 1;

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.5,
                  children: [
                    DashboardCard(
                      title: 'Toplam Çalışan',
                      value: '142',
                      icon: Icons.people,
                      color: themeColors.primaryColor,
                      trend: '+5%',
                      isPositive: true,
                    ),
                    DashboardCard(
                      title: 'Bugün Yoklama',
                      value: '138',
                      icon: Icons.access_time,
                      color: themeColors.successColor,
                      trend: '+2%',
                      isPositive: true,
                    ),
                    DashboardCard(
                      title: 'Bekleyen İzinler',
                      value: '12',
                      icon: Icons.event_note,
                      color: themeColors.warningColor,
                      trend: '-8%',
                      isPositive: false,
                    ),
                    DashboardCard(
                      title: 'Bu Ay Bordro',
                      value: '₺425,000',
                      icon: Icons.payments,
                      color: themeColors.infoColor,
                      trend: '+3%',
                      isPositive: true,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // Charts Section
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 1000) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ChartCard(
                          title: 'Aylık Yoklama Raporu',
                          child: _buildAttendanceChart(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ChartCard(
                          title: 'Departman Dağılımı',
                          child: _buildDepartmentChart(),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      ChartCard(
                        title: 'Aylık Yoklama Raporu',
                        child: _buildAttendanceChart(),
                      ),
                      const SizedBox(height: 16),
                      ChartCard(
                        title: 'Departman Dağılımı',
                        child: _buildDepartmentChart(),
                      ),
                    ],
                  );
                }
              },
            ),

            const SizedBox(height: 32),

            // Recent Activities
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Son Aktiviteler',
                            style: AppTextStyles.heading3,
                          ),
                          const SizedBox(height: 16),
                          const RecentActivities(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hızlı İşlemler', style: AppTextStyles.heading3),
                          const SizedBox(height: 16),
                          _buildQuickActions(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const months = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz'];
                  if (value.toInt() >= 0 && value.toInt() < months.length) {
                    return Text(months[value.toInt()]);
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 95),
                FlSpot(1, 92),
                FlSpot(2, 98),
                FlSpot(3, 89),
                FlSpot(4, 94),
                FlSpot(5, 97),
              ],
              isCurved: true,
              color: AppColors.primaryColor,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primaryColor.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentChart() {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 35,
              title: 'IT\n35%',
              color: AppColors.chartColors[0],
              radius: 60,
            ),
            PieChartSectionData(
              value: 25,
              title: 'Sales\n25%',
              color: AppColors.chartColors[1],
              radius: 60,
            ),
            PieChartSectionData(
              value: 20,
              title: 'HR\n20%',
              color: AppColors.chartColors[2],
              radius: 60,
            ),
            PieChartSectionData(
              value: 20,
              title: 'Other\n20%',
              color: AppColors.chartColors[3],
              radius: 60,
            ),
          ],
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        _buildActionButton(
          icon: Icons.person_add,
          title: 'Yeni Çalışan',
          onTap: () {
            // Navigate to add employee
          },
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          icon: Icons.event_note,
          title: 'İzin Talebi',
          onTap: () {
            // Navigate to leave request
          },
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          icon: Icons.assessment,
          title: 'Rapor Oluştur',
          onTap: () {
            // Navigate to reports
          },
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          icon: Icons.access_time,
          title: 'Yoklama Raporu',
          onTap: () {
            // Navigate to attendance
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryColor),
            const SizedBox(width: 12),
            Text(title, style: AppTextStyles.subtitle2),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
