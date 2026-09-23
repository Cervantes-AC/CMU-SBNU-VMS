# Comprehensive Documentation for `theme`

**Path:** `lib/core/theme/`

## Files

### 📄 `app_theme.dart`
**Defined Types & Details:**

#### `AppTheme` 
- **Fields / Properties:**
  - `isDark`
  - `isNsrc`
  - `primary`
- **Methods:**
  - `_build()`
  - `return()`

#### `Glass` 

---

### 📄 `theme_provider.dart`
**Key Imports:**
- `import 'package:shared_preferences/shared_preferences.dart';`

**Defined Types & Details:**

#### `NsrcThemeMode` 

#### `ThemeProvider` extends ChangeNotifier
- **Fields / Properties:**
  - `_mode`
  - `values`
- **Methods:**
  - `ThemeProvider()`
  - `_load()`
  - `notifyListeners()`
  - `toggle()`
  - `cycleMode()`
  - `setMode()`

---

