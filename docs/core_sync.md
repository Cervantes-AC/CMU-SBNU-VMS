# Comprehensive Documentation for `sync`

**Path:** `lib/core/sync/`

## Files

### 📄 `sync_service.dart`
**Key Imports:**
- `import 'dart:async';`
- `import '../../data/interfaces/i_connectivity_service.dart';`
- `import '../../data/repositories/announcement_repository.dart';`
- `import '../../data/repositories/attendance_repository.dart';`
- `import '../../data/repositories/audit_log_repository.dart';`
- *...and 5 more*

**Defined Types & Details:**

#### `SyncService` extends ChangeNotifier
- **Fields / Properties:**
  - `_connectivityService`
  - `_eventRepo`
  - `_incidentRepo`
  - `_userRepo`
  - `_attendanceRepo`
  - `_announcementRepo`
  - `_auditLogRepo`
  - `_qrDutyRepo`
  - `_autoSyncTimer`
  - `_isSyncing`
  - `_lastSyncTime`
  - `_lastError`
  - `connected`
- **Methods:**
  - `sync()`
  - `notifyListeners()`
  - `startAutoSync()`
  - `stopAutoSync()`
  - `dispose()`

---

