# Comprehensive Documentation for `reporting`

**Path:** `lib/data/services/reporting/`

## Files

### 📄 `report_service.dart`
**Key Imports:**
- `import 'dart:convert';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import 'package:uuid/uuid.dart';`
- `import '../../../core/utils/audit_logger.dart';`
- `import '../../models/audit_log.dart';`
- *...and 1 more*

**Defined Types & Details:**

#### `ReportData` 
- **Fields / Properties:**
  - `title`
  - `generatedAt`
- **Methods:**
  - `toJson()`

#### `ReportService` extends ChangeNotifier
- **Fields / Properties:**
  - `_firestore`
  - `_uuid`
  - `_savedConfigs`
  - `_isLoading`
  - `_isGenerating`
  - `_lastError`
  - `_lastReport`
  - `rows`
  - `rethrow`
  - `start`
  - `config`
- **Methods:**
  - `notifyListeners()`
  - `deleteConfig()`
  - `loadUserConfigs()`

---

