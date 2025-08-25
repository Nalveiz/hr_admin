import 'package:equatable/equatable.dart';
import '../../data/models/team_model.dart';

abstract class TeamsState extends Equatable {
  const TeamsState();

  @override
  List<Object?> get props => [];
}

class TeamsInitial extends TeamsState {
  const TeamsInitial();
}

class TeamsLoading extends TeamsState {
  const TeamsLoading();
}

class TeamsLoaded extends TeamsState {
  final List<TeamModel> teams;
  final List<TeamModel> filteredTeams;

  const TeamsLoaded({required this.teams, required this.filteredTeams});

  @override
  List<Object?> get props => [teams, filteredTeams];

  TeamsLoaded copyWith({
    List<TeamModel>? teams,
    List<TeamModel>? filteredTeams,
  }) {
    return TeamsLoaded(
      teams: teams ?? this.teams,
      filteredTeams: filteredTeams ?? this.filteredTeams,
    );
  }
}

class TeamsError extends TeamsState {
  final String message;

  const TeamsError({required this.message});

  @override
  List<Object?> get props => [message];
}
