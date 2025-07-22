import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

class DepartmentsPage extends StatelessWidget {
  const DepartmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeColors.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  AppStrings.departments,
                  style: AppThemeTextStyles.of(context).heading2,
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    
                  },
                  icon: const Icon(Icons.add),
                  label: Text(AppStrings.add),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  final departments = [
                    {
                      'name': 'Bilgi İşlem',
                      'count': 15,
                      'color': AppColors.primaryColor,
                    },
                    {
                      'name': 'İnsan Kaynakları',
                      'count': 8,
                      'color': AppColors.successColor,
                    },
                    {
                      'name': 'Satış',
                      'count': 22,
                      'color': AppColors.warningColor,
                    },
                    {
                      'name': 'Pazarlama',
                      'count': 12,
                      'color': AppColors.infoColor,
                    },
                    {
                      'name': 'Finans',
                      'count': 6,
                      'color': AppColors.errorColor,
                    },
                    {
                      'name': 'Operasyon',
                      'count': 18,
                      'color': AppColors.secondaryColor,
                    },
                  ];

                  final dept = departments[index];

                  return Card(
                    child: InkWell(
                      onTap: () {
                        // Navigate to department detail
                      },
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
                                color: (dept['color'] as Color).withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                Icons.apartment,
                                color: dept['color'] as Color,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              dept['name'] as String,
                              style: AppThemeTextStyles.of(context).subtitle1,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${dept['count']} çalışan',
                              style: AppTextStyles.body2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
