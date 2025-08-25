/// Extension for String with additional utilities
extension StringExtension on String {
  /// Check if string is empty or null
  bool get isNullOrEmpty => isEmpty;

  /// Check if string is not empty and not null
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Title case (capitalize each word)
  String get titleCase {
    if (isEmpty) return this;
    return split(
      ' ',
    ).map((word) => word.isEmpty ? word : word.capitalize).join(' ');
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Check if string is a valid email
  bool get isValidEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  /// Check if string is a valid phone number (Turkish format)
  bool get isValidPhone {
    return RegExp(r'^(\+90|0)?[5][0-9]{9}$').hasMatch(removeWhitespace);
  }

  /// Check if string contains only numbers
  bool get isNumeric {
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  /// Check if string is a valid Turkish ID number (TC Kimlik)
  bool get isValidTcKimlik {
    if (length != 11 || !isNumeric) return false;

    final digits = split('').map((e) => int.parse(e)).toList();

    // First digit cannot be 0
    if (digits[0] == 0) return false;

    // Algorithm check
    int sumOdd = 0;
    int sumEven = 0;

    for (int i = 0; i < 9; i++) {
      if (i % 2 == 0) {
        sumOdd += digits[i];
      } else {
        sumEven += digits[i];
      }
    }

    int check1 = ((sumOdd * 7) - sumEven) % 10;
    int check2 = (sumOdd + sumEven + digits[9]) % 10;

    return check1 == digits[9] && check2 == digits[10];
  }

  /// Parse to int safely
  int? get toIntOrNull {
    return int.tryParse(this);
  }

  /// Parse to double safely
  double? get toDoubleOrNull {
    return double.tryParse(this);
  }

  /// Parse to DateTime safely
  DateTime? get toDateTimeOrNull {
    return DateTime.tryParse(this);
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Mask string (for sensitive data)
  String mask({int showFirst = 2, int showLast = 2, String maskChar = '*'}) {
    if (length <= showFirst + showLast) return this;

    final first = substring(0, showFirst);
    final last = substring(length - showLast);
    final middle = maskChar * (length - showFirst - showLast);

    return '$first$middle$last';
  }

  /// Remove Turkish characters for search/comparison
  String get removeTurkishChars {
    return replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ı', 'i')
        .replaceAll('ö', 'o')
        .replaceAll('ş', 's')
        .replaceAll('ü', 'u')
        .replaceAll('Ç', 'C')
        .replaceAll('Ğ', 'G')
        .replaceAll('I', 'I')
        .replaceAll('İ', 'I')
        .replaceAll('Ö', 'O')
        .replaceAll('Ş', 'S')
        .replaceAll('Ü', 'U');
  }

  /// Check if string matches search term (Turkish-aware)
  bool matchesSearchTerm(String searchTerm) {
    if (searchTerm.isEmpty) return true;

    final normalizedThis = toLowerCase().removeTurkishChars;
    final normalizedSearch = searchTerm.toLowerCase().removeTurkishChars;

    return normalizedThis.contains(normalizedSearch);
  }

  /// Get initials from full name
  String get initials {
    final words = trim().split(' ').where((word) => word.isNotEmpty);
    if (words.isEmpty) return '';

    return words.take(2).map((word) => word[0].toUpperCase()).join();
  }

  /// Format as Turkish currency
  String get toTurkishCurrency {
    final number = toDoubleOrNull ?? 0.0;
    return '${number.toStringAsFixed(2).replaceAll('.', ',')} TL';
  }
}
