# Comprehensive Documentation for `extensions`

**Path:** `lib/data/models/extensions/`

## Files

### 📄 `backup_record.dart`
**Defined Types & Details:**

#### `BackupRecord` 
- **Fields / Properties:**
  - `id`
  - `type`
  - `createdAt`
  - `status`
  - `fileUrl`
  - `fileSizeBytes`
  - `errorMessage`
  - `integrityVerified`
  - `completedAt`
  - `initiatedBy`

---

### 📄 `enhanced_audit_log.dart`
**Key Imports:**
- `import '../audit_log.dart';`

**Defined Types & Details:**

#### `EnhancedAuditLog` extends AuditLog
- **Fields / Properties:**
  - `userId`
  - `ipAddress`
  - `deviceInfo`
  - `userAgent`
  - `moduleName`
  - `responseTimeMs`
  - `changed`

---

### 📄 `mfa_code.dart`
**Defined Types & Details:**

#### `MfaCode` 
- **Fields / Properties:**
  - `id`
  - `userId`
  - `code`
  - `type`
  - `expiresAt`
  - `used`
  - `createdAt`

#### `MfaMethod` email, sms, authenticator }

#### `MfaMethodExt` on MfaMethod
- **Methods:**
  - `toJson()`

---

### 📄 `notification_preference.dart`
**Defined Types & Details:**

#### `NotificationPreference` 
- **Fields / Properties:**
  - `userId`
  - `emailNotifications`
  - `pushNotifications`
  - `smsNotifications`
  - `systemNotifications`
  - `warningAlerts`
  - `criticalAlerts`
  - `reminderNotifications`

---

### 📄 `report_config.dart`
**Defined Types & Details:**

#### `SavedReportConfig` 
- **Fields / Properties:**
  - `id`
  - `name`
  - `userId`
  - `reportType`
  - `scheduled`
  - `scheduleFrequency`
  - `emailOnGenerate`
  - `emailRecipients`
  - `createdAt`

---

### 📄 `user_session.dart`
**Defined Types & Details:**

#### `UserSession` 
- **Fields / Properties:**
  - `id`
  - `userId`
  - `deviceInfo`
  - `ipAddress`
  - `loginAt`
  - `lastActivityAt`
  - `expiresAt`
  - `isActive`
  - `last`

---

