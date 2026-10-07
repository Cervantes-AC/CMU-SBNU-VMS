import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds and persists the current [ThemeMode] preference.
///
/// Persists only the preference, not personal data. Loading has a
/// deterministic default ([ThemeMode.system]) and safe failure behavior.
class ThemeProvider extends ChangeNotifier {
  ThemeProvider({SharedPreferences? prefs}) : _prefs = prefs;

  static const String _prefKey = 'app.theme_mode';

  SharedPreferences? _prefs;
  ThemeMode _mode = ThemeMode.system;
  bool _loaded = false;

  ThemeMode get mode => _mode;
  bool get loaded => _loaded;

  /// Loads the persisted preference. Safe on failure: falls back to system.
  Future<void> load() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      final stored = _prefs!.getString(_prefKey);
      _mode = switch (stored) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        'system' || null => ThemeMode.system,
        // Unknown stored value: deterministic default.
        _ => ThemeMode.system,
      };
    } catch (_) {
      _mode = ThemeMode.system;
    } finally {
      _loaded = true;
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
    try {
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.setString(_prefKey, mode.name);
    } catch (_) {
      // Persistence failure must not block the in-memory preference.
    }
  }
}
