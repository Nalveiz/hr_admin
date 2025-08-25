// lib/features/permission_requests/presentation/pages/permission_request_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_admin/core/constants/app_constants.dart'; // Uygulama sabitlerinizin yolu
import 'package:hr_admin/core/theme/app_theme.dart'; // Tema ayarlarınızın yolu
import 'package:hr_admin/features/leave/presentation/bloc/permission_requests_cubit.dart';
import 'package:hr_admin/features/leave/presentation/bloc/permission_requests_state.dart';
import 'package:hr_admin/features/leave/presentation/widgets/permission_request_card.dart';
import 'package:hr_admin/features/leave/presentation/widgets/permission_status_filter.dart';
import 'package:hr_admin/injection_container.dart';
import 'package:hr_admin/shared/utils/dialog_service.dart';

class PermissionRequestsPage extends StatefulWidget {
  const PermissionRequestsPage({super.key});

  @override
  State<PermissionRequestsPage> createState() => _PermissionRequestsPageState();
}

class _PermissionRequestsPageState extends State<PermissionRequestsPage> {
  late final DialogService _dialogService;

  @override
  void initState() {
    super.initState();
    _dialogService = sl<DialogService>();
    context.read<PermissionRequestsCubit>().fetchPermissionRequests();
  }

  Future<void> _onAddPermissionRequestPressed() async {
    final result = await context.pushNamed<bool>('add-leave-request');
    if (!mounted) return;
    if (result == true) {
      context.read<PermissionRequestsCubit>().fetchPermissionRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PermissionRequestsCubit, PermissionRequestsState>(
      listener: (context, state) {
        // Hata durumunda SnackBar gösterimi
        if (state.error != null) {
          // SnackBarService kullanarak hata mesajını gösteriyoruz
          _dialogService.showError(
            context,
            title: 'Hata',
            message:
                'Beklenmeyen bir hata oluştu: ${state.error ?? 'Bilinmeyen hata'}',
          );
        }
      },
      builder: (context, state) {
        // Filtrelenmiş izin talepleri listesini alıyoruz
        final filteredRequests = context
            .read<PermissionRequestsCubit>()
            .filteredPermissionRequests;

        return Scaffold(
          backgroundColor: AppThemeColors.of(context).backgroundColor,
          body: Column(
            children: [
              // Header Bölümü
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      AppStrings
                          .leaveRequests, // AppStrings'e eklemeniz gerekecek
                      style: AppThemeTextStyles.of(context).heading2,
                    ),
                    const Spacer(),
                    // Görünüm değiştirme butonu KALDIRILDI
                    // Yeni izin talebi ekle butonu
                    ElevatedButton.icon(
                      onPressed: _onAddPermissionRequestPressed,
                      icon: const Icon(Icons.add),
                      label: Text(
                        AppStrings.add,
                      ), // AppStrings'e eklemeniz gerekecek
                    ),
                  ],
                ),
              ),

              // Filtreleme Çubuğu
              PermissionStatusFilter(
                selectedStatus: state.selectedStatusFilter,
                onStatusSelected: (status) {
                  context.read<PermissionRequestsCubit>().setStatusFilter(
                    status,
                  );
                },
              ),

              // İzin Talepleri Listesi (Her zaman ListView olarak)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: state.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        ) // Yükleniyor durumu
                      : state.error != null
                      ? Center(
                          // Hata durumu
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Error: ${state.error!}',
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              // Yeniden deneme butonu
                              ElevatedButton(
                                onPressed: () => context
                                    .read<PermissionRequestsCubit>()
                                    .fetchPermissionRequests(),
                                child: const Text('Try Again'),
                              ),
                            ],
                          ),
                        )
                      : filteredRequests.isEmpty
                      ? Center(
                          // Veri yok durumu
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_outlined, // Veri yok simgesi
                                size: 64,
                                color: AppColors.textHint,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                AppStrings
                                    .noData, // AppStrings'e eklemeniz gerekecek
                                style: AppTextStyles.subtitle1.copyWith(
                                  color: AppColors.textHint,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          // Sadece ListView kaldı
                          itemCount: filteredRequests.length,
                          itemBuilder: (context, index) {
                            final request = filteredRequests[index];
                            return PermissionRequestCard(
                              request: request,
                              onUpdateStatus: (id, status) {
                                context
                                    .read<PermissionRequestsCubit>()
                                    .updatePermissionRequestStatus(id, status);
                              },
                              onTap: () {
                                // Detay sayfasına gitme, eğer varsa
                                context.go(
                                  '/permission-requests/${request.id}',
                                );
                              },
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
