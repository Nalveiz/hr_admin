import 'package:flutter/material.dart';
import '../../../core/debug/bloc_debug_helper.dart';
import '../../../injection_container.dart';
import '../../../shared/shared.dart';

/// Demo page to showcase BLoC monitoring capabilities
class BlocMonitoringDemo extends StatelessWidget {
  const BlocMonitoringDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLoC Monitoring Demo'),
        backgroundColor: AppThemeColors.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'BLoC Debug Tools',
              style: AppThemeTextStyles.of(context).heading2,
            ),

            const SizedBox(height: 16),

            // Debug mode status
            _buildDebugStatusCard(context),

            const SizedBox(height: 16),

            // Action buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppButton.primary(
                  text: const Text('Print Debug Summary'),
                  onPressed: () {
                    BlocDebugHelper.printDebugSummary();
                    sl<SnackBarService>().showSuccess(
                      context,
                      'Debug summary printed to console',
                    );
                  },
                  icon: Icons.summarize,
                ),

                AppButton.secondary(
                  text: const Text('Check Memory Leaks'),
                  onPressed: () {
                    BlocDebugHelper.checkForMemoryLeaks();
                    sl<SnackBarService>().showInfo(
                      context,
                      'Memory leak check completed',
                    );
                  },
                  icon: Icons.memory,
                ),

                AppButton.secondary(
                  text: const Text('Clear Statistics'),
                  onPressed: () {
                    BlocDebugHelper.clearTransitionStats();
                    sl<SnackBarService>().showInfo(
                      context,
                      'Statistics cleared',
                    );
                  },
                  icon: Icons.clear_all,
                ),

                AppButton.danger(
                  text: const Text('Toggle Debug Mode'),
                  onPressed: () {
                    final currentMode = BlocDebugHelper.isDebugMode;
                    BlocDebugHelper.setDebugMode(!currentMode);
                    sl<SnackBarService>().showSuccess(
                      context,
                      'Debug mode ${!currentMode ? 'enabled' : 'disabled'}',
                    );
                  },
                  icon: Icons.bug_report,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Transition statistics
            _buildTransitionStatsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugStatusCard(BuildContext context) {
    final themeTextStyles = AppThemeTextStyles.of(context);

    return Card(
      color: BlocDebugHelper.isDebugMode
          ? Colors.green.shade50
          : Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              BlocDebugHelper.isDebugMode
                  ? Icons.bug_report
                  : Icons.production_quantity_limits,
              color: BlocDebugHelper.isDebugMode ? Colors.green : Colors.orange,
              size: 32,
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Debug Mode Status',
                    style: themeTextStyles.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    BlocDebugHelper.isDebugMode
                        ? 'Enabled - All BLoC activities are being logged'
                        : 'Disabled - Minimal logging for production',
                    style: themeTextStyles.body2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransitionStatsCard(BuildContext context) {
    final themeTextStyles = AppThemeTextStyles.of(context);
    final stats = BlocDebugHelper.getTransitionStats();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transition Statistics',
              style: themeTextStyles.subtitle1.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (stats.isEmpty)
              Text(
                'No transitions recorded yet',
                style: themeTextStyles.body2.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              ...stats.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key, style: themeTextStyles.body2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppThemeColors.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${entry.value}',
                          style: themeTextStyles.caption.copyWith(
                            color: AppThemeColors.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
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
}
