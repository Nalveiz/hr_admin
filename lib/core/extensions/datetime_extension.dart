/// Extension for DateTime with additional utilities
extension DateTimeExtension on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Get start of day (00:00:00)
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Get end of day (23:59:59.999)
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  /// Get start of week (Monday)
  DateTime get startOfWeek {
    final daysFromMonday = weekday - 1;
    return subtract(Duration(days: daysFromMonday)).startOfDay;
  }

  /// Get end of week (Sunday)
  DateTime get endOfWeek {
    final daysToSunday = 7 - weekday;
    return add(Duration(days: daysToSunday)).endOfDay;
  }

  /// Get start of month
  DateTime get startOfMonth {
    return DateTime(year, month, 1);
  }

  /// Get end of month
  DateTime get endOfMonth {
    return DateTime(year, month + 1, 0, 23, 59, 59, 999);
  }

  /// Format date as DD/MM/YYYY
  String get ddmmyyyy {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  /// Format time as HH:MM
  String get hhmm {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Format datetime as DD/MM/YYYY HH:MM
  String get ddmmyyyyhhmm {
    return '$ddmmyyyy $hhmm';
  }

  /// Get relative time (e.g., "2 days ago", "in 3 hours")
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else if (difference.inSeconds > 0) {
      return '${difference.inSeconds} saniye önce';
    } else if (difference.inSeconds < 0) {
      final futureDiff = difference.abs();
      if (futureDiff.inDays > 0) {
        return '${futureDiff.inDays} gün sonra';
      } else if (futureDiff.inHours > 0) {
        return '${futureDiff.inHours} saat sonra';
      } else if (futureDiff.inMinutes > 0) {
        return '${futureDiff.inMinutes} dakika sonra';
      } else {
        return '${futureDiff.inSeconds} saniye sonra';
      }
    } else {
      return 'şimdi';
    }
  }

  /// Check if date is between two dates
  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start) && isBefore(end) ||
        isAtSameMomentAs(start) ||
        isAtSameMomentAs(end);
  }

  /// Get age from birthdate
  int get age {
    final now = DateTime.now();
    int age = now.year - year;

    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }

    return age;
  }

  /// Get days until this date
  int get daysUntil {
    final now = DateTime.now();
    return difference(now).inDays;
  }

  /// Get working days between dates (excluding weekends)
  int workingDaysUntil(DateTime endDate) {
    int workingDays = 0;
    DateTime current = startOfDay;
    final end = endDate.startOfDay;

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      if (current.weekday != DateTime.saturday &&
          current.weekday != DateTime.sunday) {
        workingDays++;
      }
      current = current.add(const Duration(days: 1));
    }

    return workingDays;
  }
}
