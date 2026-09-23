# Comprehensive Documentation for `backup`

**Path:** `lib/data/services/backup/`

## Files

### 📄 `backup_service.dart`
**Key Imports:**
- `import 'dart:convert';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import 'package:uuid/uuid.dart';`
- `import '../../../core/utils/audit_logger.dart';`
- `import '../../models/audit_log.dart';`
- *...and 1 more*

**Defined Types & Details:**

#### `BackupService` extends ChangeNotifier
- **Fields / Properties:**
  - `_firestore`
  - `_uuid`
  - `_isRunning`
  - `_lastError`
  - `_progress`
  - `_totalBackups`
  - `_completedCount`
  - `_failedCount`
  - `_totalSizeBytes`
  - `sizeBytes`
  - `completedRecord`
  - `failedRecord`
  - `true`
  - `false`
  - `data`
  - `d`
  - `mediaUrls`
- **Methods:**
  - `loadStats()`
  - `notifyListeners()`
  - `deleteBackup()`
  - `verifyBackupIntegrity()`
  - `debugPrint()`
  - `cleanupOldBackups()`

---

