import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// Cache entry with metadata so repositories can mark stale data.
class CacheEntry<T> {
  const CacheEntry({required this.value, required this.storedAt});

  final T value;
  final DateTime storedAt;

  bool isStale(Duration ttl, {DateTime? now}) =>
      (now ?? DateTime.now().toUtc()).difference(storedAt.toUtc()) > ttl;
}

/// Minimal typed get/set/remove/clear cache over SharedPreferences.
///
/// Clear [clearUserScope] on sign-out/account disable. TTL is enforced by
/// the consuming repository via [CacheEntry.isStale]; entries past
/// [maxAge] are dropped on read to bound growth.
class CacheService {
  CacheService({SharedPreferences? prefs}) : _prefs = prefs;

  static const String _keyPrefix = 'cache.';
  static const Duration maxAge = Duration(days: 7);

  SharedPreferences? _prefs;

  Future<SharedPreferences> _ensurePrefs() async =>
      _prefs ??= await SharedPreferences.getInstance();

  /// Initializes the underlying store; safe on failure (cache becomes a
  /// no-op passthrough).
  Future<void> initialize() async {
    try {
      await _ensurePrefs();
    } catch (_) {
      _prefs = null;
    }
  }

  Future<CacheEntry<T>?> get<T>(String key) async {
    try {
      final prefs = await _ensurePrefs();
      final raw = prefs.getString('$_keyPrefix$key');
      if (raw == null) return null;
      final separator = raw.indexOf('|');
      if (separator < 0) return null;
      final storedAt = DateTime.tryParse(raw.substring(0, separator));
      if (storedAt == null) return null;
      if (DateTime.now().toUtc().difference(storedAt.toUtc()) > maxAge) {
        await prefs.remove('$_keyPrefix$key');
        return null;
      }
      final value = raw.substring(separator + 1);
      if (value is T) {
        return CacheEntry<T>(value: value as T, storedAt: storedAt);
      }
      // Type mismatch (e.g. schema change): drop the entry.
      await prefs.remove('$_keyPrefix$key');
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> set<T>(String key, T value) async {
    try {
      final prefs = await _ensurePrefs();
      final stamp = DateTime.now().toUtc().toIso8601String();
      await prefs.setString('$_keyPrefix$key', '$stamp|$value');
    } catch (_) {
      // Cache write failure must not fail the operation.
    }
  }

  Future<void> remove(String key) async {
    try {
      final prefs = await _ensurePrefs();
      await prefs.remove('$_keyPrefix$key');
    } catch (_) {}
  }

  /// Removes every key with the given namespace prefix.
  Future<void> clearNamespace(String namespace) async {
    try {
      final prefs = await _ensurePrefs();
      final keys = prefs.getKeys().where((k) => k.startsWith('$_keyPrefix$namespace'));
      for (final k in keys) {
        await prefs.remove(k);
      }
    } catch (_) {}
  }

  /// Clears all user-scoped cache for [uid] — call on sign-out and account
  /// disablement.
  Future<void> clearUserScope(String uid) async {
    try {
      final prefs = await _ensurePrefs();
      final keys = prefs
          .getKeys()
          .where((k) => k.startsWith(_keyPrefix) && k.contains('.$uid'));
      for (final k in keys) {
        await prefs.remove(k);
      }
    } catch (_) {}
  }

  /// Clears everything managed by this cache.
  Future<void> clearAll() async {
    try {
      final prefs = await _ensurePrefs();
      final keys = prefs.getKeys().where((k) => k.startsWith(_keyPrefix));
      for (final k in keys) {
        await prefs.remove(k);
      }
    } catch (_) {}
  }
}
