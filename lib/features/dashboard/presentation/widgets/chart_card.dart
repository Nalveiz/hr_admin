import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ChartCard extends StatelessWidget {
  final String title;
  final Widget child;

  const ChartCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.heading3),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
