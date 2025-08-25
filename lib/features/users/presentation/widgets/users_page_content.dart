import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/users_cubit_new.dart';
import 'user_card_new.dart';
import '../../../../shared/shared.dart';

class UsersPageContent extends StatelessWidget {
  final Function(UserEntity) onEditUser;
  final Function(UserEntity) onDeleteUser;
  final VoidCallback onAddUser;
  final VoidCallback onRefresh;

  const UsersPageContent({
    super.key,
    required this.onEditUser,
    required this.onDeleteUser,
    required this.onAddUser,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubitNew, UsersStateNew>(
      builder: (context, state) {
        if (state is UsersLoadingNew) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UsersErrorNew) {
          return _buildErrorView(context, state.message);
        }

        if (state is UsersLoadedNew) {
          final users = state.filteredUsers;

          if (users.isEmpty) {
            return _buildEmptyView(context);
          }

          return _buildUsersList(context, users);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppThemeColors.of(context).errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Bir hata oluştu',
            style: AppThemeTextStyles.of(context).heading3,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppThemeTextStyles.of(context).body1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppButton.secondary(
            text: const Text('Yeniden Dene'),
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: AppThemeColors.of(context).textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz kullanıcı eklenmemiş',
            style: AppThemeTextStyles.of(context).heading3,
          ),
          const SizedBox(height: 8),
          Text(
            'İlk kullanıcınızı eklemek için "Yeni Kullanıcı" butonuna tıklayın',
            style: AppThemeTextStyles.of(context).body1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppButton.primary(
            text: const Text('Yeni Kullanıcı'),
            icon: Icons.add,
            onPressed: onAddUser,
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(BuildContext context, List<UserEntity> users) {
    final responsive = ResponsiveUtils(context);

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: responsive.isMobile
          ? _buildMobileList(users)
          : _buildDesktopGrid(users),
    );
  }

  Widget _buildMobileList(List<UserEntity> users) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return UserCard(
          user: user,
          onEdit: () => onEditUser(user),
          onDelete: () => onDeleteUser(user),
        );
      },
    );
  }

  Widget _buildDesktopGrid(List<UserEntity> users) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return UserCard(
          user: user,
          onEdit: () => onEditUser(user),
          onDelete: () => onDeleteUser(user),
        );
      },
    );
  }
}
