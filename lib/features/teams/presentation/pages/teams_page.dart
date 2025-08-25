import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_admin/features/teams/data/models/team_model.dart';
import 'package:hr_admin/features/teams/presentation/bloc/teams_cubit.dart';
import 'package:hr_admin/features/teams/presentation/bloc/teams_state.dart';
import 'package:hr_admin/features/teams/presentation/widgets/add_team_dialog.dart';
import 'package:hr_admin/features/teams/presentation/widgets/edit_team_dialog.dart';
import 'package:hr_admin/injection_container.dart';
import '../../../../shared/shared.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  late final TeamsCubit _teamsCubit;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _teamsCubit = sl<TeamsCubit>();
    _teamsCubit.fetchTeams();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showAddTeamDialog() async {
    final result = await sl<DialogService>().showCustom(
      context,
      child: const AddTeamDialog(),
    );
    if (result == true) {
      _teamsCubit.fetchTeams();
    }
  }

  Future<void> _showEditTeamDialog(TeamModel team) async {
    final result = await sl<DialogService>().showCustom(
      context,
      child: EditTeamDialog(team: team),
    );
    if (result == true) {
      _teamsCubit.fetchTeams();
    }
  }

  Future<void> _deleteTeam(TeamModel team) async {
    final result = await sl<DialogService>().showConfirmation(
      context,
      title: 'Takımı Sil',
      message: '${team.name} takımını silmek istediğinizden emin misiniz?',
      confirmText: 'Sil',
      cancelText: 'İptal',
      isDanger: true,
    );

    if (result == true) {
      await _teamsCubit.deleteTeam(team.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return BlocProvider.value(
      value: _teamsCubit,
      child: Scaffold(
        backgroundColor: AppThemeColors.of(context).backgroundColor,
        body: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppThemeColors.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.groups,
                        size: 28,
                        color: AppThemeColors.of(context).primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Takım Yönetimi',
                        style: AppThemeTextStyles.of(context).heading2.copyWith(
                          color: AppThemeColors.of(context).primaryColor,
                        ),
                      ),
                      const Spacer(),
                      AppButton.primary(
                        text: const Text('Yeni Takım'),
                        icon: Icons.add,
                        onPressed: _showAddTeamDialog,
                        size: responsive.isMobile
                            ? ButtonSize.small
                            : ButtonSize.medium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search Bar
                  SizedBox(
                    width: responsive.isMobile ? double.infinity : 400,
                    child: AppTextFormField(
                      controller: _searchController,
                      label: 'Takım ara...',
                      prefixIcon: Icons.search,
                      onChanged: (value) => _teamsCubit.searchTeams(value),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: BlocBuilder<TeamsCubit, TeamsState>(
                builder: (context, state) {
                  if (state is TeamsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is TeamsError) {
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
                            state.message,
                            style: AppThemeTextStyles.of(context).body1,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          AppButton.secondary(
                            text: const Text('Yeniden Dene'),
                            onPressed: () => _teamsCubit.fetchTeams(),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is TeamsLoaded) {
                    final teams = state.filteredTeams;

                    if (teams.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.groups_outlined,
                              size: 64,
                              color: AppThemeColors.of(context).textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Henüz takım eklenmemiş',
                              style: AppThemeTextStyles.of(context).heading3,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'İlk takımınızı eklemek için "Yeni Takım" butonuna tıklayın',
                              style: AppThemeTextStyles.of(context).body1,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            AppButton.primary(
                              text: const Text('Yeni Takım Ekle'),
                              icon: Icons.add,
                              onPressed: _showAddTeamDialog,
                            ),
                          ],
                        ),
                      );
                    }

                    return _buildTeamsGrid(teams, responsive);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamsGrid(List<TeamModel> teams, ResponsiveUtils responsive) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: responsive.isMobile
              ? 1
              : (responsive.isTablet ? 2 : 3),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: responsive.isMobile ? 3 : 2.5,
        ),
        itemCount: teams.length,
        itemBuilder: (context, index) {
          final team = teams[index];
          return _buildTeamCard(team);
        },
      ),
    );
  }

  Widget _buildTeamCard(TeamModel team) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppThemeColors.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.groups,
                    color: AppThemeColors.of(context).primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.name,
                        style: AppThemeTextStyles.of(
                          context,
                        ).subtitle1.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Departman: ${team.departmentId}',
                        style: AppThemeTextStyles.of(context).body2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showEditTeamDialog(team);
                        break;
                      case 'delete':
                        _deleteTeam(team);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined),
                          SizedBox(width: 8),
                          Text('Düzenle'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Sil', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppThemeColors.of(context).textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Oluşturulma: ${_formatDate(team.createdAt)}',
                  style: AppThemeTextStyles.of(context).caption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Bilinmiyor';
    try {
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Bilinmiyor';
    }
  }
}
