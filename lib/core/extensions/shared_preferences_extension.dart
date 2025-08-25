import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Extension for SharedPreferences with additional utilities
extension SharedPreferencesExtension on SharedPreferences {
  /// Get object from JSON string
  T? getObject<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final jsonString = getString(key);
    if (jsonString == null) return null;

    try {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  /// Set object as JSON string
  Future<bool> setObject<T>(
    String key,
    T object,
    Map<String, dynamic> Function(T) toJson,
  ) {
    try {
      final jsonString = json.encode(toJson(object));
      return setString(key, jsonString);
    } catch (e) {
      return Future.value(false);
    }
  }

  /// Get list of objects from JSON
  List<T>? getObjectList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final jsonString = getString(key);
    if (jsonString == null) return null;

    try {
      final jsonList = json.decode(jsonString) as List;
      return jsonList
          .cast<Map<String, dynamic>>()
          .map((json) => fromJson(json))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// Set list of objects as JSON
  Future<bool> setObjectList<T>(
    String key,
    List<T> objects,
    Map<String, dynamic> Function(T) toJson,
  ) {
    try {
      final jsonList = objects.map((obj) => toJson(obj)).toList();
      final jsonString = json.encode(jsonList);
      return setString(key, jsonString);
    } catch (e) {
      return Future.value(false);
    }
  }

  /// Check if key exists
  bool hasKey(String key) {
    return getKeys().contains(key);
  }

  /// Remove multiple keys
  Future<bool> removeKeys(List<String> keys) async {
    try {
      for (final key in keys) {
        await remove(key);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clear all data with confirmation
  Future<bool> clearAll() async {
    try {
      return await clear();
    } catch (e) {
      return false;
    }
  }
}
