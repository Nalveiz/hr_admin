import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(AppStrings.attendance, style: AppTextStyles.heading2),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to attendance report
                  },
                  icon: const Icon(Icons.assessment),
                  label: const Text('Rapor'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Today's attendance summary cards
            Row(
              children: [
                Expanded(
                  child: _buildAttendanceCard(
                    'Toplam Çalışan',
                    '142',
                    Icons.people,
                    AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAttendanceCard(
                    'Giriş Yapan',
                    '138',
                    Icons.login,
                    AppColors.successColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAttendanceCard(
                    'Geç Gelen',
                    '4',
                    Icons.schedule,
                    AppColors.warningColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAttendanceCard(
                    'Devamsız',
                    '4',
                    Icons.person_off,
                    AppColors.errorColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Attendance list
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(
                            'Bugün Yoklama Listesi',
                            style: AppTextStyles.heading3,
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              // Filter attendance
                            },
                            icon: const Icon(Icons.filter_list),
                            label: const Text('Filtrele'),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          final statuses = [
                            'Geldi',
                            'Geç Geldi',
                            'Gelmedi',
                            'İzinli',
                          ];
                          final colors = [
                            AppColors.successColor,
                            AppColors.warningColor,
                            AppColors.errorColor,
                            AppColors.infoColor,
                          ];

                          final status = statuses[index % statuses.length];
                          final color = colors[index % colors.length];

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primaryColor,
                              child: Text('${index + 1}'),
                            ),
                            title: Text('Çalışan ${index + 1}'),
                            subtitle: const Text('IT Departmanı'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '09:${15 + index}',
                                  style: AppTextStyles.body2,
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    status,
                                    style: AppTextStyles.caption.copyWith(
                                      color: color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: AppTextStyles.heading2.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.body2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
