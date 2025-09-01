import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/users_cubit.dart';
import '../dialogs/add_user_dialog.dart';
import '../widgets/edit_user_dialog.dart';
import '../widgets/users_page_header.dart';
import '../widgets/users_page_content.dart';
import '../../../../injection_container.dart';
import '../../../../shared/shared.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late final UsersCubit _usersCubit;
  final TextEditingController _searchController = TextEditingController();
  UserRoleEntity? _selectedRoleFilter;

  @override
  void initState() {
    super.initState();
    _usersCubit = sl<UsersCubit>();
    _usersCubit.fetchUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _usersCubit,
      child: Scaffold(
        backgroundColor: AppThemeColors.of(context).backgroundColor,
        body: Column(
          children: [
            UsersPageHeader(
              searchController: _searchController,
              selectedRoleFilter: _selectedRoleFilter,
              onAddUser: _showAddUserDialog,
              onRoleFilterChanged: _onRoleFilterChanged,
              onFiltersChanged: _onFiltersChanged,
            ),
            Expanded(
              child: UsersPageContent(
                onEditUser: _showEditUserDialog,
                onDeleteUser: _deleteUser,
                onAddUser: _showAddUserDialog,
                onRefresh: _refreshUsers,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Event Handlers
  void _onRoleFilterChanged(UserRoleEntity? role) {
    setState(() {
      _selectedRoleFilter = role;
    });
  }

  void _onFiltersChanged() {
    final searchTerm = _searchController.text;
    _usersCubit.searchUsers(
      searchTerm: searchTerm.isEmpty ? null : searchTerm,
      role: _selectedRoleFilter,
    );
  }

  void _refreshUsers() {
    _usersCubit.fetchUsers();
  }

  // Dialog Operations
  Future<void> _showAddUserDialog() async {
    final result = await sl<DialogService>().showCustom(
      context,
      child: const AddUserDialog(),
    );
    if (result == true) {
      _refreshUsers();
    }
  }

  Future<void> _showEditUserDialog(UserEntity user) async {
    final result = await sl<DialogService>().showCustom(
      context,
      child: EditUserDialogNew(user: user),
    );
    if (result == true) {
      _refreshUsers();
    }
  }

  Future<void> _deleteUser(UserEntity user) async {
    final result = await sl<DialogService>().showConfirmation(
      context,
      title: 'Kullanıcıyı Sil',
      message:
          '${user.fullName} kullanıcısını silmek istediğinizden emin misiniz?',
      confirmText: 'Sil',
      cancelText: 'İptal',
      isDanger: true,
    );

    if (result == true) {
      await _usersCubit.deleteUser(user.id);
    }
  }
}
