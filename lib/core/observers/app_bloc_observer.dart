import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/logger.dart';

/// Global BLoC observer for monitoring all state changes, events, and errors
class AppBlocObserver extends BlocObserver {
  static const String _tag = 'BlocObserver';

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    AppLogger.info('$_tag: ${bloc.runtimeType} created');

    // Development modunda console'a da yazdır
    if (kDebugMode) {
      log('🟢 BLoC Created: ${bloc.runtimeType}', name: _tag);
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);

    AppLogger.debug(
      '$_tag: ${bloc.runtimeType} received event: ${event.runtimeType}\n'
      'Event Data: $event',
    );

    if (kDebugMode) {
      log(
        '📨 Event: ${bloc.runtimeType} ← ${event.runtimeType}\n'
        '   Data: $event',
        name: _tag,
      );
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    AppLogger.debug(
      '$_tag: ${bloc.runtimeType} state changed\n'
      'From: ${change.currentState.runtimeType} → ${change.nextState.runtimeType}\n'
      'Current: ${change.currentState}\n'
      'Next: ${change.nextState}',
    );

    if (kDebugMode) {
      log(
        '🔄 State Change: ${bloc.runtimeType}\n'
        '   From: ${change.currentState.runtimeType} → ${change.nextState.runtimeType}\n'
        '   Current: ${change.currentState}\n'
        '   Next: ${change.nextState}',
        name: _tag,
      );
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    AppLogger.info(
      '$_tag: ${bloc.runtimeType} transition completed\n'
      'Event: ${transition.event.runtimeType}\n'
      '${transition.currentState.runtimeType} → ${transition.nextState.runtimeType}\n'
      'Event Data: ${transition.event}\n'
      'Current: ${transition.currentState}\n'
      'Next: ${transition.nextState}',
    );

    if (kDebugMode) {
      log(
        '🎯 Transition: ${bloc.runtimeType}\n'
        '   Event: ${transition.event.runtimeType}\n'
        '   ${transition.currentState.runtimeType} → ${transition.nextState.runtimeType}\n'
        '   Event Data: ${transition.event}\n'
        '   Current: ${transition.currentState}\n'
        '   Next: ${transition.nextState}',
        name: _tag,
      );
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    AppLogger.error(
      '$_tag: ${bloc.runtimeType} error occurred\n'
      'Error: $error\n'
      'Type: ${error.runtimeType}',
      error,
      stackTrace,
    );

    if (kDebugMode) {
      log(
        '❌ BLoC Error: ${bloc.runtimeType}\n'
        '   Error: $error\n'
        '   Type: ${error.runtimeType}',
        name: _tag,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);

    AppLogger.info('$_tag: ${bloc.runtimeType} closed');

    if (kDebugMode) {
      log('🔴 BLoC Closed: ${bloc.runtimeType}', name: _tag);
    }
  }
}

/// Extension methods for better BLoC monitoring
extension BlocObserverExtension on BlocBase {
  /// Add custom monitoring for specific BLoC instances
  void logCurrentState([String? context]) {
    AppLogger.debug(
      'BlocState: $runtimeType current state\n'
      'State: ${state.runtimeType}\n'
      'Data: $state\n'
      'Context: ${context ?? 'N/A'}',
    );

    if (kDebugMode) {
      log(
        '📊 Current State: $runtimeType\n'
        '   State: ${state.runtimeType}\n'
        '   Data: $state\n'
        '   Context: ${context ?? 'N/A'}',
        name: 'BlocState',
      );
    }
  }
}
