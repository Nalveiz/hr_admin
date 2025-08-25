import 'package:equatable/equatable.dart';
import '../../data/models/company_model.dart';

abstract class CompaniesState extends Equatable {
  const CompaniesState();

  @override
  List<Object?> get props => [];
}

class CompaniesInitial extends CompaniesState {
  const CompaniesInitial();
}

class CompaniesLoading extends CompaniesState {
  const CompaniesLoading();
}

class CompaniesLoaded extends CompaniesState {
  final List<CompanyModel> companies;
  final List<CompanyModel> filteredCompanies;

  const CompaniesLoaded({
    required this.companies,
    required this.filteredCompanies,
  });

  @override
  List<Object?> get props => [companies, filteredCompanies];

  CompaniesLoaded copyWith({
    List<CompanyModel>? companies,
    List<CompanyModel>? filteredCompanies,
  }) {
    return CompaniesLoaded(
      companies: companies ?? this.companies,
      filteredCompanies: filteredCompanies ?? this.filteredCompanies,
    );
  }
}

class CompaniesError extends CompaniesState {
  final String message;

  const CompaniesError({required this.message});

  @override
  List<Object?> get props => [message];
}
