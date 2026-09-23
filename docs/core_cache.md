# Comprehensive Documentation for `cache`

**Path:** `lib/core/cache/`

## Files

### 📄 `cache_keys.dart`
**Defined Types & Details:**

#### `CacheKeys` 

---

### 📄 `cache_service.dart`
**Key Imports:**
- `import 'dart:convert';`
- `import 'package:hive/hive.dart';`
- `import 'package:shared_preferences/shared_preferences.dart';`
- `import '../../data/interfaces/i_cache_service.dart';`
- `import 'cache_keys.dart';`

**Defined Types & Details:**

#### `CacheService` implements ICacheService
- **Fields / Properties:**
  - `_prefs`
  - `_stringBox`
  - `defaultTtlMinutes`
  - `cacheKey`
- **Methods:**
  - `_setTimestamp()`
  - `_getTimestamp()`
  - `_isExpired()`
  - `invalidateCollection()`
  - `invalidateDocument()`
  - `invalidateAll()`

---

