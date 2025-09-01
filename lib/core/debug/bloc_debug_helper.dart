import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../observers/app_bloc_observer.dart';
import '../utils/logger.dart';

/// Debug utilities for BLoC monitoring and debugging
class BlocDebugHelper {
  static bool _isDebugModeEnabled = kDebugMode;

  /// Enable or disable debug mode
  static void setDebugMode(bool enabled) {
    _isDebugModeEnabled = enabled;
    AppLogger.info(
      'BlocDebugHelper: Debug mode ${enabled ? 'enabled' : 'disabled'}',
    );
  }

  /// Check if debug mode is enabled
  static bool get isDebugMode => _isDebugModeEnabled;

  /// Log all active BLoCs in the widget tree
  static void logActiveBloCs(List<BlocBase> blocs) {
    if (!_isDebugModeEnabled) return;

    AppLogger.info('=== Active BLoCs ===');
    for (final bloc in blocs) {
      AppLogger.info('• ${bloc.runtimeType}: ${bloc.state.runtimeType}');
    }
    AppLogger.info('=== Total: ${blocs.length} BLoCs ===');
  }

  /// Log BLoC performance metrics
  static void logBlocPerformance(
    String blocName,
    String operation,
    Duration duration,
  ) {
    if (!_isDebugModeEnabled) return;

    final emoji = duration.inMilliseconds > 100 ? '🐌' : '⚡';
    AppLogger.debug(
      '$emoji Performance: $blocName.$operation took ${duration.inMilliseconds}ms',
    );
  }

  /// Monitor memory usage of BLoCs
  static void logMemoryUsage(String blocName, int memoryBytes) {
    if (!_isDebugModeEnabled) return;

    final memoryMB = (memoryBytes / (1024 * 1024)).toStringAsFixed(2);
    AppLogger.debug('💾 Memory: $blocName using ${memoryMB}MB');
  }

  /// Create a debug summary for a BLoC
  static void createBlocSummary(BlocBase bloc) {
    if (!_isDebugModeEnabled) return;

    AppLogger.info('''
🔍 BLoC Debug Summary:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 BLoC Type: ${bloc.runtimeType}
🏠 Current State: ${bloc.state.runtimeType}
📊 State Data: ${bloc.state}
🔥 Is Closed: ${bloc.isClosed}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
''');
  }

  /// Monitor state transition frequency
  static final Map<String, int> _transitionCounts = {};

  static void trackTransition(String blocName) {
    if (!_isDebugModeEnabled) return;

    _transitionCounts[blocName] = (_transitionCounts[blocName] ?? 0) + 1;

    final count = _transitionCounts[blocName]!;
    if (count % 10 == 0) {
      AppLogger.warning('⚠️  High Activity: $blocName has $count transitions');
    }
  }

  /// Get transition statistics
  static Map<String, int> getTransitionStats() {
    return Map.from(_transitionCounts);
  }

  /// Clear transition statistics
  static void clearTransitionStats() {
    _transitionCounts.clear();
    AppLogger.info('🧹 Transition statistics cleared');
  }

  /// Monitor potential memory leaks
  static final Set<String> _activeBloCs = {};

  static void trackBlocCreation(String blocName) {
    if (!_isDebugModeEnabled) return;

    _activeBloCs.add(blocName);
    AppLogger.debug(
      '➕ BLoC Created: $blocName (Active: ${_activeBloCs.length})',
    );
  }

  static void trackBlocClosure(String blocName) {
    if (!_isDebugModeEnabled) return;

    _activeBloCs.remove(blocName);
    AppLogger.debug(
      '➖ BLoC Closed: $blocName (Active: ${_activeBloCs.length})',
    );
  }

  /// Check for potential memory leaks
  static void checkForMemoryLeaks() {
    if (!_isDebugModeEnabled) return;

    if (_activeBloCs.length > 10) {
      AppLogger.warning(
        '🚨 Memory Leak Warning: ${_activeBloCs.length} active BLoCs detected!\n'
        'Active BLoCs: ${_activeBloCs.join(', ')}',
      );
    }
  }

  /// Print current debug session summary
  static void printDebugSummary() {
    if (!_isDebugModeEnabled) return;

    AppLogger.info('''
📋 BLoC Debug Session Summary:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔢 Active BLoCs: ${_activeBloCs.length}
📊 Transition Counts: ${_transitionCounts.length} different BLoCs tracked
🏆 Most Active BLoC: ${_getMostActiveBloC()}
⚠️  High Activity BLoCs: ${_getHighActivityBloCs().join(', ')}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
''');
  }

  static String _getMostActiveBloC() {
    if (_transitionCounts.isEmpty) return 'None';

    return _transitionCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  static List<String> _getHighActivityBloCs() {
    return _transitionCounts.entries
        .where((entry) => entry.value > 5)
        .map((entry) => '${entry.key}(${entry.value})')
        .toList();
  }
}

/// Enhanced BLoC observer with debug capabilities
class DebugBlocObserver extends AppBlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    BlocDebugHelper.trackBlocCreation(bloc.runtimeType.toString());
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    BlocDebugHelper.trackTransition(bloc.runtimeType.toString());
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    BlocDebugHelper.trackBlocClosure(bloc.runtimeType.toString());
  }
}
