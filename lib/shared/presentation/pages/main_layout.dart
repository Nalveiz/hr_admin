import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../features/auth/presentation/bloc/auth_state.dart';
import '../widgets/sidebar_menu.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Eğer logout olduysa login sayfasına yönlendir
        if (state is AuthUnauthenticated) {
          context.go('/login');
        }
      },
      child: Scaffold(
        body: Row(
          children: [
            // Sidebar
            if (MediaQuery.of(context).size.width > 768)
              const SizedBox(width: 250, child: SidebarMenu()),

            // Main Content
            Expanded(
              child: Column(
                children: [
                  // Top App Bar
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        if (MediaQuery.of(context).size.width <= 768)
                          IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                        const Spacer(),

                        // User Profile Menu
                        PopupMenuButton<String>(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppThemeColors.of(
                                    context,
                                  ).primaryColor,
                                  child: Text(
                                    'A', // Will be replaced with user initials
                                    style: AppThemeTextStyles.of(
                                      context,
                                    ).button.copyWith(fontSize: 12),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('Admin'),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'profile',
                              child: Row(
                                children: [
                                  Icon(Icons.person_outline),
                                  SizedBox(width: 8),
                                  Text(AppStrings.profile),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'settings',
                              child: Row(
                                children: [
                                  Icon(Icons.settings_outlined),
                                  SizedBox(width: 8),
                                  Text(AppStrings.settings),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem(
                              value: 'logout',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.logout_outlined,
                                    color: AppThemeColors.of(
                                      context,
                                    ).errorColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Çıkış Yap',
                                    style: TextStyle(
                                      color: AppThemeColors.of(
                                        context,
                                      ).errorColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            switch (value) {
                              case 'profile':
                                context.go('/profile');
                                break;
                              case 'settings':
                                context.go('/settings');
                                break;
                              case 'logout':
                                _handleLogout(context);
                                break;
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),

                  // Page Content
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
        drawer: MediaQuery.of(context).size.width <= 768
            ? const Drawer(child: SidebarMenu())
            : null,
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    // Logout işlemi için AuthBloc'a event gönder
    context.read<AuthBloc>().add(const AuthLogoutRequested());
  }
}
