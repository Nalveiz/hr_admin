class AppConstants {
  static const String appName = 'HR Admin';
  static const String appVersion = '1.0.0';

  // Logo Assets
  static const String logoPath = 'assets/logo/logo.png';
  static const String logoMiniPath = 'assets/logo/logo-mini.png';
  static const String logoSquarePath = 'assets/logo/logo-square.png';
  static const String logoDensePath = 'assets/logo/logo-dense.png';

  // API Constants
  static const String baseUrl = 'https://app.intimeik.com/api';
  static const String loginEndpoint = '/auth/login';
  static const String employeesEndpoint = '/employees';
  static const String departmentsEndpoint = '/departments';
  static const String attendanceEndpoint = '/attendance';
  static const String payrollEndpoint = '/payroll';
  static const String leaveRequestsEndpoint = '/leave-requests';
  static const String performanceEndpoint = '/performance';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Date Formats
  static const String dateFormat = 'dd.MM.yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd.MM.yyyy HH:mm';

  // File Upload
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedFileTypes = [
    'pdf',
    'doc',
    'docx',
    'jpg',
    'jpeg',
    'png',
  ];

  // Employee Status
  static const String activeStatus = 'active';
  static const String inactiveStatus = 'inactive';
  static const String terminatedStatus = 'terminated';

  // Leave Types
  static const String annualLeave = 'annual';
  static const String sickLeave = 'sick';
  static const String maternityLeave = 'maternity';
  static const String paternityLeave = 'paternity';
  static const String personalLeave = 'personal';

  // Department Codes
  static const String hrDepartment = 'HR';
  static const String itDepartment = 'IT';
  static const String salesDepartment = 'SALES';
  static const String marketingDepartment = 'MARKETING';
  static const String financeDepartment = 'FINANCE';
  static const String operationsDepartment = 'OPERATIONS';
}

class AppStrings {
  // General
  static const String yes = 'Evet';
  static const String no = 'Hayır';
  static const String ok = 'Tamam';
  static const String cancel = 'İptal';
  static const String save = 'Kaydet';
  static const String delete = 'Sil';
  static const String edit = 'Düzenle';
  static const String add = 'Ekle';
  static const String search = 'Ara';
  static const String filter = 'Filtrele';
  static const String refresh = 'Yenile';
  static const String loading = 'Yükleniyor...';
  static const String noData = 'Veri bulunamadı';
  static const String error = 'Hata';
  static const String success = 'Başarılı';
  static const String warning = 'Uyarı';
  static const String info = 'Bilgi';

  // Navigation
  static const String dashboard = 'Ana Sayfa';
  static const String employees = 'Çalışanlar';
  static const String departments = 'Departmanlar';
  static const String attendance = 'Yoklama';
  static const String payroll = 'Bordro';
  static const String leaveRequests = 'İzin Talepleri';
  static const String performance = 'Performans';
  static const String reports = 'Raporlar';
  static const String settings = 'Ayarlar';
  static const String profile = 'Profil';
  static const String logout = 'Çıkış';

  // Auth
  static const String login = 'Giriş Yap';
  static const String username = 'Kullanıcı Adı';
  static const String password = 'Şifre';
  static const String forgotPassword = 'Şifremi Unuttum';
  static const String rememberMe = 'Beni Hatırla';
  static const String loginError =
      'Giriş başarısız. Bilgilerinizi kontrol edin.';

  // Employee
  static const String employeeId = 'Çalışan ID';
  static const String firstName = 'Ad';
  static const String lastName = 'Soyad';
  static const String email = 'E-posta';
  static const String phone = 'Telefon';
  static const String position = 'Pozisyon';
  static const String department = 'Departman';
  static const String hireDate = 'İşe Başlama Tarihi';
  static const String salary = 'Maaş';
  static const String status = 'Durum';
  static const String birthDate = 'Doğum Tarihi';
  static const String address = 'Adres';
  static const String emergencyContact = 'Acil Durum Kişisi';

  // Attendance
  static const String checkIn = 'Giriş';
  static const String checkOut = 'Çıkış';
  static const String date = 'Tarih';
  static const String time = 'Saat';
  static const String workingHours = 'Çalışma Saati';
  static const String overtime = 'Mesai';
  static const String absent = 'Devamsız';
  static const String late = 'Geç Gelme';
  static const String earlyLeave = 'Erken Çıkış';

  // Leave
  static const String leaveType = 'İzin Türü';
  static const String startDate = 'Başlangıç Tarihi';
  static const String endDate = 'Bitiş Tarihi';
  static const String duration = 'Süre';
  static const String reason = 'Sebep';
  static const String approvalStatus = 'Onay Durumu';
  static const String pending = 'Beklemede';
  static const String approved = 'Onaylandı';
  static const String rejected = 'Reddedildi';

  // Performance
  static const String performanceReview = 'Performans Değerlendirmesi';
  static const String goals = 'Hedefler';
  static const String achievements = 'Başarılar';
  static const String rating = 'Puan';
  static const String comments = 'Yorumlar';
  static const String reviewPeriod = 'Değerlendirme Dönemi';

  // Payroll
  static const String basicSalary = 'Temel Maaş';
  static const String allowances = 'Ödeneğe';
  static const String deductions = 'Kesintiler';
  static const String netSalary = 'Net Maaş';
  static const String tax = 'Vergi';
  static const String socialSecurity = 'SGK';
  static const String bonus = 'Prim';

  // Validation Messages
  static const String fieldRequired = 'Bu alan gereklidir';
  static const String invalidEmail = 'Geçersiz e-posta adresi';
  static const String invalidPhone = 'Geçersiz telefon numarası';
  static const String passwordTooShort = 'Şifre en az 6 karakter olmalıdır';
  static const String passwordsDoNotMatch = 'Şifreler eşleşmiyor';
  static const String invalidDate = 'Geçersiz tarih';
  static const String invalidAmount = 'Geçersiz tutar';
}
