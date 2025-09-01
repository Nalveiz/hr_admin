import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_admin/injection_container.dart';
import '../../shared.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/bloc/auth_event.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo/Header
          Container(
            height: 61,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    AppConstants.logoMiniPath,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to icon if logo fails to load
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppThemeColors.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.business,
                          color: Colors.white,
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  AppConstants.appName,
                  style: AppThemeTextStyles.of(context).heading3.copyWith(
                    color: AppThemeColors.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.dashboard_outlined,
                  selectedIcon: Icons.dashboard,
                  title: AppStrings.dashboard,
                  route: '/dashboard',
                  isSelected: currentLocation == '/dashboard',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.people_outline,
                  selectedIcon: Icons.people,
                  title: 'Kullanıcılar',
                  route: '/users',
                  isSelected: currentLocation.startsWith('/users'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.business_outlined,
                  selectedIcon: Icons.business,
                  title: 'Şirketler',
                  route: '/companies',
                  isSelected: currentLocation.startsWith('/companies'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.apartment_outlined,
                  selectedIcon: Icons.apartment,
                  title: AppStrings.departments,
                  route: '/departments',
                  isSelected: currentLocation.startsWith('/departments'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.groups_outlined,
                  selectedIcon: Icons.groups,
                  title: 'Takımlar',
                  route: '/teams',
                  isSelected: currentLocation.startsWith('/teams'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.access_time_outlined,
                  selectedIcon: Icons.access_time,
                  title: AppStrings.attendance,
                  route: '/attendance',
                  isSelected: currentLocation.startsWith('/attendance'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.payments_outlined,
                  selectedIcon: Icons.payments,
                  title: AppStrings.payroll,
                  route: '/payroll',
                  isSelected: currentLocation.startsWith('/payroll'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.event_note_outlined,
                  selectedIcon: Icons.event_note,
                  title: AppStrings.leaveRequests,
                  route: '/leave-requests',
                  isSelected: currentLocation.startsWith('/leave-requests'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.trending_up_outlined,
                  selectedIcon: Icons.trending_up,
                  title: AppStrings.performance,
                  route: '/performance',
                  isSelected: currentLocation.startsWith('/performance'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.assessment_outlined,
                  selectedIcon: Icons.assessment,
                  title: AppStrings.reports,
                  route: '/reports',
                  isSelected: currentLocation.startsWith('/reports'),
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                _buildMenuItem(
                  context,
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings,
                  title: AppStrings.settings,
                  route: '/settings',
                  isSelected: currentLocation == '/settings',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  title: AppStrings.profile,
                  route: '/profile',
                  isSelected: currentLocation == '/profile',
                ),

                const SizedBox(height: 8),
                const Divider(),

                // Logout Button
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: AppThemeColors.of(context).errorColor,
                    ),
                    title: Text(
                      'Çıkış Yap',
                      style: AppThemeTextStyles.of(context).subtitle2.copyWith(
                        color: AppThemeColors.of(context).errorColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () => _handleLogout(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required IconData selectedIcon,
    required String title,
    required String route,
    required bool isSelected,
  }) {
    final themeColors = AppThemeColors.of(context);
    final themeTextStyles = AppThemeTextStyles.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected
              ? themeColors.primaryColor
              : themeColors.textSecondary,
        ),
        title: Text(
          title,
          style: themeTextStyles.subtitle2.copyWith(
            color: isSelected
                ? themeColors.primaryColor
                : themeColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: themeColors.primaryColor.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () {
          context.go(route);
          // Close drawer on mobile
          if (Scaffold.of(context).hasDrawer) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    final result = await sl<DialogService>().showConfirmation(
      context,
      title: 'Çıkış Yap',
      message:
          'Oturumunuzu kapatmak istediğinizden emin misiniz?\n\nTüm giriş bilgileriniz silinecek ve login sayfasına yönlendirileceksiniz.',
      confirmText: 'Çıkış Yap',
      cancelText: 'İptal',
      icon: Icons.logout,
      isDanger: true,
    );

    if (result == true && context.mounted) {
      context.read<AuthBloc>().add(const AuthLogoutRequested());
    }
  }
}
