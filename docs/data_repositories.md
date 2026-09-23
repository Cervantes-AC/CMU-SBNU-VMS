# Comprehensive Documentation for `repositories`

**Path:** `lib/data/repositories/`

## Files

### 📄 `announcement_repository.dart`
**Key Imports:**
- `import '../../core/cache/cache_keys.dart';`
- `import '../../shared/result.dart';`
- `import '../interfaces/i_announcement_repository.dart';`
- `import '../interfaces/i_cache_service.dart';`
- `import '../models/announcement.dart';`
- *...and 1 more*

**Defined Types & Details:**

#### `AnnouncementRepository` extends ChangeNotifier implements IAnnouncementRepository
- **Fields / Properties:**
  - `_cacheService`
  - `_firestoreService`
  - `_cachedAnnouncements`
  - `_isLoading`
  - `announcements`
- **Methods:**
  - `Success()`
  - `notifyListeners()`
  - `Failure()`
  - `saveAnnouncement()`
  - `deleteAnnouncement()`

---

### 📄 `attendance_repository.dart`
**Key Imports:**
- `import '../../core/cache/cache_keys.dart';`
- `import '../../shared/result.dart';`
- `import '../interfaces/i_attendance_repository.dart';`
- `import '../interfaces/i_cache_service.dart';`
- `import '../models/attendance.dart';`
- *...and 1 more*

**Defined Types & Details:**

#### `AttendanceRepository` extends ChangeNotifier implements IAttendanceRepository
- **Fields / Properties:**
  - `_cacheService`
  - `_firestoreService`
  - `_cachedRecords`
  - `_isLoading`
  - `records`
  - `result`
- **Methods:**
  - `getAttendance()`
  - `notifyListeners()`
  - `Success()`
  - `Failure()`
  - `streamAttendance()`
  - `saveAttendance()`

---

### 📄 `audit_log_repository.dart`
**Key Imports:**
- `import '../../core/cache/cache_keys.dart';`
- `import '../../shared/result.dart';`
- `import '../interfaces/i_audit_log_repository.dart';`
- `import '../interfaces/i_cache_service.dart';`
- `import '../models/audit_log.dart';`
- *...and 1 more*

**Defined Types & Details:**

#### `AuditLogRepository` extends ChangeNotifier implements IAuditLogRepository
- **Fields / Properties:**
  - `_cacheService`
  - `_firestoreService`
  - `_cachedLogs`
  - `_isLoading`
  - `logs`
- **Methods:**
  - `getAuditLogs()`
  - `notifyListeners()`
  - `Success()`
  - `Failure()`
  - `streamAuditLogs()`
  - `addAuditLog()`

---

### 📄 `event_repository.dart`
**Key Imports:**
- `import '../../core/cache/cache_keys.dart';`
- `import '../../shared/result.dart';`
- `import '../interfaces/i_cache_service.dart';`
- `import '../interfaces/i_event_repository.dart';`
- `import '../models/event.dart';`
- *...and 1 more*

**Defined Types & Details:**

#### `EventRepository` extends ChangeNotifier implements IEventRepository
- **Fields / Properties:**
  - `_cacheService`
  - `_firestoreService`
  - `_cachedEvents`
  - `_isLoading`
  - `events`
  - `result`
- **Methods:**
  - `getEvents()`
  - `notifyListeners()`
  - `Success()`
  - `Failure()`
  - `getUpcomingEvents()`
  - `streamEvents()`
  - `streamUpcomingEvents()`
  - `saveEvent()`
  - `deleteEvent()`

---

### 📄 `incident_repository.dart`
**Key Imports:**
- `import '../../core/cache/cache_keys.dart';`
- `import '../../shared/result.dart';`
- `import '../interfaces/i_cache_service.dart';`
- `import '../interfaces/i_incident_repository.dart';`
- `import '../models/incident.dart';`
- *...and 1 more*

**Defined Types & Details:**

#### `IncidentRepository` extends ChangeNotifier implements IIncidentRepository
- **Fields / Properties:**
  - `_cacheService`
  - `_firestoreService`
  - `_cachedIncidents`
  - `_isLoading`
  - `incidents`
  - `null`
- **Methods:**
  - `getIncidents()`
  - `notifyListeners()`
  - `Success()`
  - `Failure()`
  - `getActiveSosIncident()`
  - `streamIncidents()`
  - `streamActiveSosIncident()`
  - `saveIncident()`

---

### 📄 `qr_duty_repository.dart`
**Key Imports:**
- `import '../../core/cache/cache_keys.dart';`
- `import '../../shared/result.dart';`
- `import '../interfaces/i_cache_service.dart';`
- `import '../interfaces/i_qr_duty_repository.dart';`
- `import '../models/qr_duty_record.dart';`
- *...and 1 more*

**Defined Types & Details:**

#### `QrDutyRepository` extends ChangeNotifier implements IQrDutyRepository
- **Fields / Properties:**
  - `_cacheService`
  - `_firestoreService`
  - `_cachedRecords`
  - `_isLoading`
  - `records`
  - `result`
  - `null`
- **Methods:**
  - `getRecords()`
  - `notifyListeners()`
  - `Success()`
  - `Failure()`
  - `streamRecords()`
  - `saveRecord()`

---

### 📄 `repositories.dart`
*(No classes, mixins, or enums found)*

---

### 📄 `user_repository.dart`
**Key Imports:**
- `import '../../core/cache/cache_keys.dart';`
- `import '../../shared/result.dart';`
- `import '../interfaces/i_cache_service.dart';`
- `import '../interfaces/i_user_repository.dart';`
- `import '../models/user.dart';`
- *...and 1 more*

**Defined Types & Details:**

#### `UserRepository` extends ChangeNotifier implements IUserRepository
- **Fields / Properties:**
  - `_cacheService`
  - `_firestoreService`
  - `_cachedUsers`
  - `_isLoading`
  - `users`
  - `result`
- **Methods:**
  - `getUsers()`
  - `notifyListeners()`
  - `Success()`
  - `Failure()`
  - `getApprovedUsers()`
  - `getPendingUsers()`
  - `streamUsers()`
  - `streamApprovedUsers()`
  - `saveUser()`
  - `deleteUser()`

---

