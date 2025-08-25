import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/company_service.dart';
import 'companies_state.dart';

class CompaniesCubit extends Cubit<CompaniesState> {
  final CompanyService _companyService;

  CompaniesCubit(this._companyService) : super(const CompaniesInitial());

  Future<void> fetchCompanies() async {
    emit(const CompaniesLoading());

    try {
      final response = await _companyService.getAllCompanies();

      if (response.isSuccess && response.data != null) {
        final companies = response.data!;
        emit(
          CompaniesLoaded(companies: companies, filteredCompanies: companies),
        );
      } else {
        emit(
          CompaniesError(
            message: response.error ?? 'Şirketler yüklenirken bir hata oluştu',
          ),
        );
      }
    } catch (e) {
      emit(
        CompaniesError(message: 'Beklenmeyen bir hata oluştu: ${e.toString()}'),
      );
    }
  }

  void filterCompanies(String query, bool showActiveOnly) {
    final currentState = state;
    if (currentState is CompaniesLoaded) {
      var filtered = currentState.companies;

      if (query.isNotEmpty) {
        filtered = filtered
            .where(
              (company) =>
                  company.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }

      if (showActiveOnly) {
        filtered = filtered.where((c) => c.valid == true).toList();
      }
      emit(currentState.copyWith(filteredCompanies: filtered));
    }
  }

  Future<void> deleteCompany(String companyId) async {
    try {
      final response = await _companyService.deleteCompany(companyId);

      if (response.isSuccess) {
        // Refresh the list
        await fetchCompanies();
      } else {
        emit(
          CompaniesError(
            message: response.error ?? 'Şirket silinirken bir hata oluştu',
          ),
        );
      }
    } catch (e) {
      emit(
        CompaniesError(message: 'Beklenmeyen bir hata oluştu: ${e.toString()}'),
      );
    }
  }
}
