/// Uygulama genelinde kullanılacak validator'lar
/// Tek yerden yönetim için static methodlar
class AppValidators {
  // Private constructor - static class
  AppValidators._();

  /// Boş alan kontrolü
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Bu alan'} zorunludur';
    }
    return null;
  }

  /// Email format kontrolü
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email adresi zorunludur';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Geçerli bir email adresi giriniz';
    }
    return null;
  }

  /// Şifre güçlülük kontrolü
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Şifre zorunludur';
    }

    if (value.length < minLength) {
      return 'Şifre en az $minLength karakter olmalıdır';
    }

    return null;
  }

  /// Güçlü şifre kontrolü (büyük/küçük harf, rakam, özel karakter)
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre zorunludur';
    }

    if (value.length < 8) {
      return 'Şifre en az 8 karakter olmalıdır';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Şifre en az bir büyük harf içermelidir';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Şifre en az bir küçük harf içermelidir';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Şifre en az bir rakam içermelidir';
    }

    return null;
  }

  /// Telefon numarası kontrolü
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefon numarası zorunludur';
    }

    // Türkiye telefon formatları: +90, 0, vs.
    final phoneRegex = RegExp(r'^(\+90|0)?[5][0-9]{9}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return 'Geçerli bir telefon numarası giriniz';
    }
    return null;
  }

  /// TC Kimlik No kontrolü
  static String? tcKimlik(String? value) {
    if (value == null || value.isEmpty) {
      return 'TC Kimlik No zorunludur';
    }

    if (value.length != 11) {
      return 'TC Kimlik No 11 haneli olmalıdır';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'TC Kimlik No sadece rakam içermelidir';
    }

    // TC Kimlik No algoritması
    if (value[0] == '0') {
      return 'TC Kimlik No 0 ile başlayamaz';
    }

    return null;
  }

  /// Minimum uzunluk kontrolü
  static String? minLength(String? value, int min, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Bu alan'} zorunludur';
    }

    if (value.length < min) {
      return '${fieldName ?? 'Bu alan'} en az $min karakter olmalıdır';
    }
    return null;
  }

  /// Maksimum uzunluk kontrolü
  static String? maxLength(String? value, int max, {String? fieldName}) {
    if (value != null && value.length > max) {
      return '${fieldName ?? 'Bu alan'} en fazla $max karakter olabilir';
    }
    return null;
  }

  /// Sadece rakam kontrolü
  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Bu alan'} zorunludur';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return '${fieldName ?? 'Bu alan'} sadece rakam içermelidir';
    }
    return null;
  }

  /// Pozitif sayı kontrolü
  static String? positiveNumber(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Bu alan'} zorunludur';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return '${fieldName ?? 'Bu alan'} geçerli bir sayı olmalıdır';
    }

    if (number <= 0) {
      return '${fieldName ?? 'Bu alan'} pozitif bir sayı olmalıdır';
    }
    return null;
  }

  /// Aralık kontrolü
  static String? range(String? value, double min, double max, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Bu alan'} zorunludur';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return '${fieldName ?? 'Bu alan'} geçerli bir sayı olmalıdır';
    }

    if (number < min || number > max) {
      return '${fieldName ?? 'Bu alan'} $min ile $max arasında olmalıdır';
    }
    return null;
  }

  /// Birden fazla validator'ı birleştir
  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
