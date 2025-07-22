import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/employee.dart';

class EmployeeDetailPage extends StatelessWidget {
  final String employeeId;

  const EmployeeDetailPage({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    // Mock data - In real app, this would come from BLoC
    final employee = Employee(
      id: employeeId,
      name: 'Ahmet',
      surname: 'Yılmaz',
      email: 'ahmet.yilmaz@company.com',
      role: 'user',
      department: 'IT',
      company: 'Tech Company',
      position: 'Senior Developer',
      employmentStartDate: DateTime(2022, 1, 15),
      phone: '+90 532 123 4567',
      address: 'İstanbul, Türkiye',
      status: 0,
      createdAt: DateTime.now(),
      createdBy: 'admin',
      note: 'Deneyimli yazılım geliştirici',
    );

    return Scaffold(
      backgroundColor: AppThemeColors.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Profile
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Back Button and Actions
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              // Edit employee
                            },
                            icon: const Icon(Icons.edit, color: Colors.white),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'activate',
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle),
                                    SizedBox(width: 8),
                                    Text('Aktive Et'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'deactivate',
                                child: Row(
                                  children: [
                                    Icon(Icons.block),
                                    SizedBox(width: 8),
                                    Text('Pasife Al'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'terminate',
                                child: Row(
                                  children: [
                                    Icon(Icons.person_remove),
                                    SizedBox(width: 8),
                                    Text('İşten Çıkar'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Profile Picture
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: employee.attachment != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(46),
                                child: Image.network(
                                  employee.attachment!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Text(
                                  '${employee.name.substring(0, 1)}${employee.surname.substring(0, 1)}',
                                  style: AppTextStyles.heading2.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),

                      // Name and Title
                      Text(
                        '${employee.name} ${employee.surname}',
                        style: AppTextStyles.heading2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        employee.position,
                        style: AppTextStyles.subtitle1.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          employee.department,
                          style: AppTextStyles.body2.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionCard(
                          icon: Icons.access_time,
                          title: 'Yoklama',
                          subtitle: 'Giriş/Çıkış',
                          color: AppColors.infoColor,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildActionCard(
                          icon: Icons.event_note,
                          title: 'İzin',
                          subtitle: 'Talep Oluştur',
                          color: AppColors.warningColor,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildActionCard(
                          icon: Icons.payments,
                          title: 'Bordro',
                          subtitle: 'Görüntüle',
                          color: AppColors.successColor,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Personal Information
                  _buildInfoSection(
                    title: 'Kişisel Bilgiler',
                    children: [
                      _buildInfoRow('ID', employee.id ?? '-'),
                      _buildInfoRow('E-posta', employee.email),
                      _buildInfoRow('Telefon', employee.phone),
                      _buildInfoRow('Adres', employee.address ?? '-'),
                      _buildInfoRow('Not', employee.note ?? '-'),
                      _buildInfoRow('Rol', employee.role ?? '-'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Work Information
                  _buildInfoSection(
                    title: 'İş Bilgileri',
                    children: [
                      _buildInfoRow('Pozisyon', employee.position),
                      _buildInfoRow('Departman', employee.department),
                      _buildInfoRow(
                        'İşe Başlama Tarihi',
                        '${employee.employmentStartDate.day}.${employee.employmentStartDate.month}.${employee.employmentStartDate.year}',
                      ),
                      _buildInfoRow(
                        'Durum',
                        employee.status == 0 ? 'Aktif' : 'Pasif',
                      ),
                      _buildInfoRow(
                        'Oluşturulma Tarihi',
                        employee.createdAt != null
                            ? '${employee.createdAt!.day}.${employee.createdAt!.month}.${employee.createdAt!.year}'
                            : '-',
                      ),
                      _buildInfoRow('Oluşturan', employee.createdBy ?? '-'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.subtitle2.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.heading3),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(flex: 3, child: Text(value, style: AppTextStyles.body1)),
        ],
      ),
    );
  }
}
