/// Form validation utilities
class AppValidators {
  /// Required field validator
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Bu alan'} zorunludur';
    }
    return null;
  }

  /// Email validator
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-posta adresi gereklidir';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Geçerli bir e-posta adresi giriniz';
    }

    return null;
  }

  /// Phone number validator
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone is optional
    }

    final phoneRegex = RegExp(r'^[+]?[0-9\s\-\(\)]{10,}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Geçerli bir telefon numarası giriniz';
    }

    return null;
  }

  /// Password validator
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre gereklidir';
    }

    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalıdır';
    }

    if (value.length > 128) {
      return 'Şifre en fazla 128 karakter olabilir';
    }

    return null;
  }

  /// Name validator
  static String? name(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'İsim'} gereklidir';
    }

    if (value.trim().length < 2) {
      return '${fieldName ?? 'İsim'} en az 2 karakter olmalıdır';
    }

    if (value.trim().length > 100) {
      return '${fieldName ?? 'İsim'} en fazla 100 karakter olabilir';
    }

    return null;
  }

  /// Number validator
  static String? number(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return null; // Numbers can be optional
    }

    if (double.tryParse(value.trim()) == null) {
      return '${fieldName ?? 'Bu alan'} geçerli bir sayı olmalıdır';
    }

    return null;
  }

  /// Positive number validator
  static String? positiveNumber(String? value, [String? fieldName]) {
    final numberValidation = number(value, fieldName);
    if (numberValidation != null) return numberValidation;

    if (value != null && value.trim().isNotEmpty) {
      final numValue = double.parse(value.trim());
      if (numValue <= 0) {
        return '${fieldName ?? 'Bu alan'} pozitif bir sayı olmalıdır';
      }
    }

    return null;
  }

  /// Min length validator
  static String? Function(String?) minLength(int min, [String? fieldName]) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return null; // Let required validator handle this
      }

      if (value.length < min) {
        return '${fieldName ?? 'Bu alan'} en az $min karakter olmalıdır';
      }

      return null;
    };
  }

  /// Max length validator
  static String? Function(String?) maxLength(int max, [String? fieldName]) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return null;
      }

      if (value.length > max) {
        return '${fieldName ?? 'Bu alan'} en fazla $max karakter olabilir';
      }

      return null;
    };
  }

  /// Combine multiple validators
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
