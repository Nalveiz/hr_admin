import 'dart:async';

/// Lazy loader utility for performance optimization
class LazyLoader<T> {
  T? _value;
  final Future<T> Function() _loader;
  Completer<T>? _completer;

  LazyLoader(this._loader);

  /// Get the value, loading it if necessary
  Future<T> get value async {
    if (_value != null) return _value!;

    if (_completer != null) return _completer!.future;

    _completer = Completer<T>();

    try {
      _value = await _loader();
      _completer!.complete(_value!);
      return _value!;
    } catch (error) {
      _completer!.completeError(error);
      _completer = null;
      rethrow;
    }
  }

  /// Check if value is loaded
  bool get isLoaded => _value != null;

  /// Reset the lazy loader
  void reset() {
    _value = null;
    _completer = null;
  }
}

/// Debouncer utility for search optimization
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

/// Cache utility for API responses
class CacheManager<K, V> {
  final Map<K, _CacheEntry<V>> _cache = {};
  final Duration expiration;

  CacheManager({this.expiration = const Duration(minutes: 30)});

  /// Get value from cache
  V? get(K key) {
    final entry = _cache[key];
    if (entry == null) return null;

    if (DateTime.now().isAfter(entry.expiresAt)) {
      _cache.remove(key);
      return null;
    }

    return entry.value;
  }

  /// Put value in cache
  void put(K key, V value) {
    _cache[key] = _CacheEntry(
      value: value,
      expiresAt: DateTime.now().add(expiration),
    );
  }

  /// Clear cache
  void clear() {
    _cache.clear();
  }

  /// Remove specific key
  void remove(K key) {
    _cache.remove(key);
  }
}

class _CacheEntry<V> {
  final V value;
  final DateTime expiresAt;

  _CacheEntry({required this.value, required this.expiresAt});
}

typedef VoidCallback = void Function();
