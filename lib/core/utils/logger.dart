import 'dart:developer' as dev;

/// Application logger utility
class AppLogger {
  static const String _name = 'HRAdmin';

  /// Log levels
  static const int _debugLevel = 0;
  static const int _infoLevel = 1;
  static const int _warningLevel = 2;
  static const int _errorLevel = 3;

  static int _currentLevel = _debugLevel;

  /// Set log level
  static void setLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        _currentLevel = _debugLevel;
        break;
      case LogLevel.info:
        _currentLevel = _infoLevel;
        break;
      case LogLevel.warning:
        _currentLevel = _warningLevel;
        break;
      case LogLevel.error:
        _currentLevel = _errorLevel;
        break;
    }
  }

  /// Debug logging
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (_currentLevel <= _debugLevel) {
      dev.log(
        message,
        name: _name,
        level: 500,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Info logging
  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    if (_currentLevel <= _infoLevel) {
      dev.log(
        message,
        name: _name,
        level: 800,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Warning logging
  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    if (_currentLevel <= _warningLevel) {
      dev.log(
        message,
        name: _name,
        level: 900,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Error logging
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (_currentLevel <= _errorLevel) {
      dev.log(
        message,
        name: _name,
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Network request logging
  static void networkRequest(
    String method,
    String url, [
    Map<String, dynamic>? data,
  ]) {
    debug('🔵 $method $url${data != null ? '\nData: $data' : ''}');
  }

  /// Network response logging
  static void networkResponse(
    String method,
    String url,
    int statusCode, [
    dynamic data,
  ]) {
    final icon = statusCode >= 200 && statusCode < 300 ? '🟢' : '🔴';
    debug(
      '$icon $statusCode $method $url${data != null ? '\nResponse: $data' : ''}',
    );
  }

  /// BLoC event logging
  static void blocEvent(String blocName, String eventName) {
    debug('🎯 $blocName: $eventName');
  }

  /// BLoC state logging
  static void blocState(String blocName, String stateName) {
    debug('📦 $blocName: $stateName');
  }
}

/// Log levels
enum LogLevel { debug, info, warning, error }
