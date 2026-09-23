# Comprehensive Documentation for `models`

**Path:** `lib/data/models/`

## Subdirectories
- `extensions/`

## Files

### 📄 `announcement.dart`
**Defined Types & Details:**

#### `AnnouncementPriority` 
> Priority level of an announcement.

- **Fields / Properties:**
  - `low`
- **Methods:**
  - `toJson()`

#### `Announcement` 
> An announcement posted by an Officer or Admin.  Maps to Firestore collection: `/announcements/{announcementId}`

- **Fields / Properties:**
  - `id`
  - `title`
  - `content`
  - `authorUid`
  - `authorName`
  - `timestamp`
  - `priority`
- **Methods:**
  - `toString()`

---

### 📄 `attendance.dart`
**Defined Types & Details:**

#### `AttendanceStatus` 
> Attendance status for a volunteer at an event.

- **Fields / Properties:**
  - `excused`
- **Methods:**
  - `toJson()`

#### `Attendance` 
> Attendance record for a volunteer at a specific event.  Maps to Firestore collection: `/attendance/{attendanceId}`

- **Fields / Properties:**
  - `id`
  - `eventId`
  - `userId`
  - `markedBy`
  - `status`
  - `timestamp`
- **Methods:**
  - `toString()`

---

### 📄 `audit_log.dart`
**Defined Types & Details:**

#### `AuditSeverity` 
> Severity level of an audit log entry.

- **Fields / Properties:**
  - `critical`
- **Methods:**
  - `toJson()`

#### `AuditLog` 
> An immutable audit log entry recording a system action.  Maps to Firestore collection: `/auditLogs/{logId}` Audit logs are append-only — no update or delete operations.

- **Fields / Properties:**
  - `id`
  - `action`
  - `category`
  - `userName`
  - `details`
  - `timestamp`
  - `severity`
- **Methods:**
  - `toString()`

---

### 📄 `event.dart`
**Defined Types & Details:**

#### `EventStatus` 
> Status of an event.

- **Fields / Properties:**
  - `cancelled`
- **Methods:**
  - `toJson()`

#### `JoinRequestStatus` 
> Status of a volunteer's join request for an event.

- **Fields / Properties:**
  - `denied`
- **Methods:**
  - `toJson()`

#### `JoinRequest` 
> A volunteer's request to join an event.

- **Fields / Properties:**
  - `userId`
  - `status`
- **Methods:**
  - `JoinRequest()`
  - `copyWith()`
  - `toString()`

#### `Event` 
> An SBNU event with volunteer assignments and join requests.  Maps to Firestore collection: `/events/{eventId}`

- **Fields / Properties:**
  - `id`
  - `title`
  - `dateTime`
  - `venue`
  - `activityType`
  - `status`
  - `assignedVolunteers`
  - `joinRequests`
- **Methods:**
  - `toString()`

---

### 📄 `incident.dart`
**Defined Types & Details:**

#### `IncidentStatus` 
> Status of an incident report.

- **Fields / Properties:**
  - `resolved`
- **Methods:**
  - `toJson()`

#### `Incident` 
> An incident report submitted by a volunteer.  Maps to Firestore collection: `/incidents/{incidentId}`  [reportedBy] stores the UID of the submitter. [reporterName] stores the full name at submission time so it can be displayed without a separate user lookup. Backward-compatible: old documents without this field fall back to showing [reportedBy].

- **Fields / Properties:**
  - `id`
  - `reportedBy`: UID of the user who submitted this incident.
  - `reporterName`: Full name of the reporter, stored at submission time. Null for legacy documents — callers should fall back to [reportedBy].
  - `type`
  - `dateTime`
  - `narrative`
  - `assistanceType`
  - `severity`
  - `contactNumber`
  - `affectedPersons`
  - `latitude`
  - `longitude`
  - `mediaUrls`
  - `status`
  - `isSOS`
  - `respondedBy`: UID of the user who marked this incident as responded.
  - `respondedByName`: Full name of the responder, captured at response time.
  - `resolvedBy`: UID of the user who marked this incident as resolved.
  - `resolvedByName`: Full name of the resolver, captured at resolution time.
- **Methods:**
  - `toString()`

---

### 📄 `models.dart`
*(No classes, mixins, or enums found)*

---

### 📄 `qr_duty_record.dart`
**Key Imports:**
- `import 'package:intl/intl.dart';`

**Defined Types & Details:**

#### `QrDutyType` timeIn, timeOut }

#### `QrDutyRecord` 
- **Fields / Properties:**
  - `id`
  - `userId`
  - `userName`
  - `userStudentId`
  - `eventId`
  - `eventTitle`
  - `type`
  - `timestamp`
  - `date`
  - `qrToken`

---

### 📄 `user.dart`
**Defined Types & Details:**

#### `UserRole` 
> User role enum defining access levels in the system.  Hierarchy: admin > officer > member. Organization is a responder role with incident visibility, but no staff write privileges.

- **Fields / Properties:**
  - `organization`
- **Methods:**
  - `hasAccess()`: Returns true if this role has access to the required role level.  Access hierarchy: - admin can access admin, officer, and member levels - officer can access officer and member levels - member can only access member level  Example: ```dart UserRole.admin.hasAccess(UserRole.officer) // true UserRole.member.hasAccess(UserRole.officer) // false ```
  - `toJson()`: Converts the enum to a lowercase string for Firestore serialization.

#### `Feature` 
> Granular application features for role-based access control.  Each feature maps to a specific screen or capability in the app. Use [UserRoleFeatures.features] to get the set of features a role can access.


#### `UserRoleFeatures` on UserRole
> Extension on [UserRole] that provides feature-based access resolution.  Usage: ```dart final role = UserRole.officer; role.features.contains(Feature.analytics); // false ```


#### `UserStatus` 
> User account status enum.

- **Fields / Properties:**
  - `suspended`
- **Methods:**
  - `toJson()`: Converts the enum to a lowercase string for Firestore serialization.

#### `AppUser` 
> Complete user profile model for the CMU - SBNU system.  Maps to Firestore collection: `/users/{uid}`

- **Fields / Properties:**
  - `uid`: Firebase Authentication UID (unique identifier)
  - `email`: User's email address
  - `fullName`: Full name of the user
  - `studentId`: Student ID number
  - `serialNumber`: NSRC serial number
  - `birthdate`: Birthdate in ISO 8601 date string format (YYYY-MM-DD)
  - `gender`: Gender of the user
  - `courseAndYear`: Course and year level (e.g., "BSCS 3")
  - `primaryCompetency`: Primary competency or skill area
  - `contactInfo`: Contact information (phone number)
  - `currentAddress`: Current residential address
  - `homeAddress`: Optional home address
  - `emergencyContactPerson`: Optional emergency contact person name
  - `emergencyContactNumber`: Optional emergency contact phone number
  - `role`: User's role in the system
  - `status`: User's account status
  - `totalServiceHours`: Total accumulated service hours
  - `fcmToken`: Firebase Cloud Messaging device token for push notifications
  - `photoUrl`: URL to the user's profile picture in Firebase Storage
  - `createdAt`: ISO 8601 timestamp of when the account was created
  - `lastLoginAt`: ISO 8601 timestamp of the last successful login, or null if never logged in
  - `dataPrivacyConsent`: Whether the user has consented to the Data Privacy Act (RA 10173)
  - `dataPrivacyConsentAt`: ISO 8601 timestamp when data privacy consent was given
  - `loginAttempts`
  - `lockedUntil`
  - `mfaEnabled`
  - `mfaMethod`
  - `mfaSecret`
  - `backupCodeHashes`
  - `lastLoginIp`
  - `lastLoginDevice`
  - `deletedAt`
  - `deletedBy`
  - `isImpersonating`
  - `true`
- **Methods:**
  - `toString()`
  - `_listEquals()`

---

