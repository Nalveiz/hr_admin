import 'package:hr_admin/core/domain/base_interfaces.dart';
import '../entities/company.dart';

/// Abstract repository for company data operations
abstract class CompanyRepository extends BaseRepository<Company, String> {
  Future<List<Company>> searchCompanies(String query);
  Future<List<Company>> getActiveCompanies();
}
