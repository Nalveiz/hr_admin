import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/shared.dart';

/// Demo credentials information widget
class DemoCredentials extends StatelessWidget {
  final VoidCallback? onUsernamePressed;
  final VoidCallback? onPasswordPressed;

  const DemoCredentials({
    super.key,
    this.onUsernamePressed,
    this.onPasswordPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);
    final themeTextStyles = AppThemeTextStyles.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: themeColors.infoColor.withValues(alpha: 0.1),
        border: Border.all(
          color: themeColors.infoColor.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: themeColors.infoColor,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Demo Bilgileri',
                style: themeTextStyles.subtitle2.copyWith(
                  color: themeColors.infoColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Credentials
          _buildCredentialRow(
            context,
            label: 'Kullanıcı Adı:',
            value: 'admin',
            onTap: onUsernamePressed,
          ),

          const SizedBox(height: AppSpacing.sm),

          _buildCredentialRow(
            context,
            label: 'Şifre:',
            value: 'admin',
            onTap: onPasswordPressed,
          ),

          const SizedBox(height: AppSpacing.sm),

          // Help text
          Text(
            'Bilgilerin üzerine tıklayarak kopyalayabilirsiniz',
            style: themeTextStyles.caption.copyWith(
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialRow(
    BuildContext context, {
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    final themeColors = AppThemeColors.of(context);
    final themeTextStyles = AppThemeTextStyles.of(context);

    return GestureDetector(
      onTap: () {
        _copyToClipboard(context, value);
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: themeColors.surfaceColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: themeColors.borderColor.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 90,
              child: Text(
                label,
                style: themeTextStyles.body2.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: themeTextStyles.body2.copyWith(
                  color: themeColors.infoColor,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.copy_rounded,
              size: 16,
              color: themeColors.infoColor.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$text kopyalandı'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSpacing.md),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
