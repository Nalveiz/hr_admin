import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/team_service.dart';
import 'teams_state.dart';

class TeamsCubit extends Cubit<TeamsState> {
  final TeamService _teamService;

  TeamsCubit(this._teamService) : super(const TeamsInitial());

  Future<void> fetchTeams() async {
    emit(const TeamsLoading());

    try {
      final response = await _teamService.getAllTeams();

      if (response.isSuccess && response.data != null) {
        final teams = response.data!;
        emit(TeamsLoaded(teams: teams, filteredTeams: teams));
      } else {
        emit(
          TeamsError(
            message: response.error ?? 'Takımlar yüklenirken bir hata oluştu',
          ),
        );
      }
    } catch (e) {
      emit(TeamsError(message: 'Beklenmeyen bir hata oluştu: ${e.toString()}'));
    }
  }

  void searchTeams(String query) {
    final currentState = state;
    if (currentState is TeamsLoaded) {
      if (query.isEmpty) {
        emit(currentState.copyWith(filteredTeams: currentState.teams));
      } else {
        final filteredTeams = currentState.teams
            .where(
              (team) => team.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
        emit(currentState.copyWith(filteredTeams: filteredTeams));
      }
    }
  }

  Future<void> deleteTeam(String teamId) async {
    try {
      final response = await _teamService.deleteTeam(teamId);

      if (response.isSuccess) {
        // Refresh the list
        await fetchTeams();
      } else {
        emit(
          TeamsError(
            message: response.error ?? 'Takım silinirken bir hata oluştu',
          ),
        );
      }
    } catch (e) {
      emit(TeamsError(message: 'Beklenmeyen bir hata oluştu: ${e.toString()}'));
    }
  }
}
