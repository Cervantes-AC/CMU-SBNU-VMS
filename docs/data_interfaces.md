# Comprehensive Documentation for `interfaces`

**Path:** `lib/data/interfaces/`

## Files

### 📄 `interfaces.dart`
*(No classes, mixins, or enums found)*

---

### 📄 `i_announcement_repository.dart`
**Key Imports:**
- `import '../../shared/result.dart';`
- `import '../models/announcement.dart';`

**Defined Types & Details:**

#### `IAnnouncementRepository` 
- **Methods:**
  - `getAnnouncements()`
  - `saveAnnouncement()`
  - `deleteAnnouncement()`

---

### 📄 `i_attendance_repository.dart`
**Key Imports:**
- `import '../../shared/result.dart';`
- `import '../models/attendance.dart';`

**Defined Types & Details:**

#### `IAttendanceRepository` 
- **Methods:**
  - `getAttendance()`
  - `streamAttendance()`
  - `saveAttendance()`

---

### 📄 `i_audit_log_repository.dart`
**Key Imports:**
- `import '../../shared/result.dart';`
- `import '../models/audit_log.dart';`

**Defined Types & Details:**

#### `IAuditLogRepository` 
- **Methods:**
  - `getAuditLogs()`
  - `streamAuditLogs()`
  - `addAuditLog()`

---

### 📄 `i_auth_service.dart`
**Key Imports:**
- `import '../models/user.dart';`

**Defined Types & Details:**

#### `IAuthService` 

---

### 📄 `i_cache_service.dart`
**Defined Types & Details:**

#### `ICacheService` 
- **Methods:**
  - `invalidateCollection()`
  - `invalidateDocument()`
  - `invalidateAll()`

---

### 📄 `i_connectivity_service.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'package:connectivity_plus/connectivity_plus.dart';`

**Defined Types & Details:**

#### `IConnectivityService` 

---

### 📄 `i_event_repository.dart`
**Key Imports:**
- `import '../../shared/result.dart';`
- `import '../models/event.dart';`

**Defined Types & Details:**

#### `IEventRepository` 
- **Methods:**
  - `getEvents()`
  - `getUpcomingEvents()`
  - `streamEvents()`
  - `streamUpcomingEvents()`
  - `saveEvent()`
  - `deleteEvent()`

---

### 📄 `i_incident_repository.dart`
**Key Imports:**
- `import '../../shared/result.dart';`
- `import '../models/incident.dart';`

**Defined Types & Details:**

#### `IIncidentRepository` 
- **Methods:**
  - `getIncidents()`
  - `getActiveSosIncident()`
  - `streamIncidents()`
  - `streamActiveSosIncident()`
  - `saveIncident()`

---

### 📄 `i_qr_duty_repository.dart`
**Key Imports:**
- `import '../../shared/result.dart';`
- `import '../models/qr_duty_record.dart';`

**Defined Types & Details:**

#### `IQrDutyRepository` 
- **Methods:**
  - `getRecords()`
  - `streamRecords()`
  - `getLastRecordForUserToday()`
  - `saveRecord()`

---

### 📄 `i_user_repository.dart`
**Key Imports:**
- `import '../../shared/result.dart';`
- `import '../models/user.dart';`

**Defined Types & Details:**

#### `IUserRepository` 
- **Methods:**
  - `getUsers()`
  - `getApprovedUsers()`
  - `getPendingUsers()`
  - `streamUsers()`
  - `streamApprovedUsers()`
  - `saveUser()`
  - `deleteUser()`

---

