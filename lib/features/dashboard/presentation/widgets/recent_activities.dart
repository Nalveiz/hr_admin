import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class RecentActivities extends StatelessWidget {
  const RecentActivities({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'icon': Icons.person_add,
        'title': 'Yeni çalışan eklendi',
        'subtitle': 'Ahmet Yılmaz - IT Departmanı',
        'time': '5 dakika önce',
        'color': AppColors.successColor,
      },
      {
        'icon': Icons.event_note,
        'title': 'İzin talebi onaylandı',
        'subtitle': 'Fatma Kaya - 3 gün yıllık izin',
        'time': '15 dakika önce',
        'color': AppColors.infoColor,
      },
      {
        'icon': Icons.access_time,
        'title': 'Geç giriş kaydı',
        'subtitle': 'Mehmet Demir - 09:15 giriş',
        'time': '30 dakika önce',
        'color': AppColors.warningColor,
      },
      {
        'icon': Icons.payments,
        'title': 'Bordro hesaplandı',
        'subtitle': 'Mayıs 2024 bordrosu hazır',
        'time': '1 saat önce',
        'color': AppColors.primaryColor,
      },
      {
        'icon': Icons.trending_up,
        'title': 'Performans değerlendirmesi',
        'subtitle': 'Q1 2024 değerlendirmeleri tamamlandı',
        'time': '2 saat önce',
        'color': AppColors.successColor,
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final activity = activities[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (activity['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              activity['icon'] as IconData,
              color: activity['color'] as Color,
              size: 20,
            ),
          ),
          title: Text(
            activity['title'] as String,
            style: AppTextStyles.subtitle2,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(activity['subtitle'] as String, style: AppTextStyles.body2),
              const SizedBox(height: 4),
              Text(activity['time'] as String, style: AppTextStyles.caption),
            ],
          ),
        );
      },
    );
  }
}
