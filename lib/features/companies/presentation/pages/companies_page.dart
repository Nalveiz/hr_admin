import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_admin/features/companies/presentation/bloc/companies_cubit.dart';
import 'package:hr_admin/features/companies/presentation/bloc/companies_state.dart';
import 'package:hr_admin/features/companies/presentation/widgets/add_company_dialog.dart';
import 'package:hr_admin/features/companies/presentation/widgets/edit_company_dialog.dart';
import 'package:hr_admin/injection_container.dart';
import '../../../../shared/shared.dart';

class CompaniesPage extends StatefulWidget {
  const CompaniesPage({super.key});

  @override
  State<CompaniesPage> createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage> {
  late final CompaniesCubit _companiesCubit;
  bool _showActiveOnly = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _companiesCubit = sl<CompaniesCubit>();
    _companiesCubit.fetchCompanies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showAddCompanyDialog() async {
    final result = await sl<DialogService>().showCustom(
      context,
      child: const AddCompanyDialog(),
    );
    if (result == true) {
      _companiesCubit.fetchCompanies();
    }
  }

  Future<void> _showEditCompanyDialog(CompanyModel company) async {
    final result = await sl<DialogService>().showCustom(
      context,
      child: EditCompanyDialog(company: company),
    );
    if (result == true) {
      _companiesCubit.fetchCompanies();
    }
  }

  Future<void> _deleteCompany(CompanyModel company) async {
    final result = await sl<DialogService>().showConfirmation(
      context,
      title: 'Şirketi Sil',
      message: '${company.name} şirketini silmek istediğinizden emin misiniz?',
      confirmText: 'Sil',
      cancelText: 'İptal',
      isDanger: true,
    );

    if (result == true) {
      await _companiesCubit.deleteCompany(company.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return BlocProvider.value(
      value: _companiesCubit,
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
                        Icons.business,
                        size: 28,
                        color: AppThemeColors.of(context).primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Şirket Yönetimi',
                        style: AppThemeTextStyles.of(context).heading2.copyWith(
                          color: AppThemeColors.of(context).primaryColor,
                        ),
                      ),
                      const Spacer(),
                      AppButton.primary(
                        text: const Text('Yeni Şirket'),
                        icon: Icons.add,
                        onPressed: _showAddCompanyDialog,
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
                      label: 'Şirket ara...',
                      prefixIcon: Icons.search,
                      onChanged: (value) => _companiesCubit.filterCompanies(
                        value,
                        _showActiveOnly,
                      ),
                    ),
                  ),
                  FilterChip(
                    label: const Text('Sadece Aktif'),
                    selected: _showActiveOnly,
                    onSelected: (value) {
                      setState(() {
                        _showActiveOnly = value;
                      });
                      _companiesCubit.filterCompanies(
                        _searchController.text,
                        _showActiveOnly,
                      );
                    },
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: BlocBuilder<CompaniesCubit, CompaniesState>(
                builder: (context, state) {
                  if (state is CompaniesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CompaniesError) {
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
                            onPressed: () => _companiesCubit.fetchCompanies(),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is CompaniesLoaded) {
                    final companies = state.filteredCompanies;

                    if (companies.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.business_outlined,
                              size: 64,
                              color: AppThemeColors.of(context).textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Henüz şirket eklenmemiş',
                              style: AppThemeTextStyles.of(context).heading3,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'İlk şirketinizi eklemek için "Yeni Şirket" butonuna tıklayın',
                              style: AppThemeTextStyles.of(context).body1,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            AppButton.primary(
                              text: const Text('Yeni Şirket Ekle'),
                              icon: Icons.add,
                              onPressed: _showAddCompanyDialog,
                            ),
                          ],
                        ),
                      );
                    }

                    return _buildCompaniesGrid(companies, responsive);
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

  Widget _buildCompaniesGrid(
    List<CompanyModel> companies,
    ResponsiveUtils responsive,
  ) {
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
        itemCount: companies.length,
        itemBuilder: (context, index) {
          final company = companies[index];
          return _buildCompanyCard(company);
        },
      ),
    );
  }

  Widget _buildCompanyCard(CompanyModel company) {
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
                    Icons.business,
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
                        company.name,
                        style: AppThemeTextStyles.of(
                          context,
                        ).subtitle1.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Şu anda CompanyModel'de description yok, bu yüzden bu kısmı kaldırıyoruz
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showEditCompanyDialog(company);
                        break;
                      case 'delete':
                        _deleteCompany(company);
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
                  'Oluşturulma: ${_formatDate(company.createdAt)}',
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
