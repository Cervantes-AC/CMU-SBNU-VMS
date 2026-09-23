# Comprehensive Documentation for `services`

**Path:** `lib/data/services/`

## Subdirectories
- `backup/`
- `import_export/`
- `mfa/`
- `reporting/`

## Files

### 📄 `ai_accomplishment_report_service.dart`
**Key Imports:**
- `import '../models/attendance.dart';`
- `import '../models/event.dart';`
- `import '../models/incident.dart';`
- `import '../models/user.dart';`

**Defined Types & Details:**

#### `AIAccomplishmentReportService` 
> Service that generates volunteer accomplishment and activity reports from Firestore-sourced data using template-based text generation.  Fully synchronous / pure function — no I/O. Data is passed in from [FirestoreService] streams (Requirement 15).

- **Fields / Properties:**
  - `byRole`
  - `byStatus`
  - `byType`
- **Methods:**
  - `AIAccomplishmentReportService()`
  - `_pad()`

---

### 📄 `audio_service.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'package:audioplayers/audioplayers.dart';`

**Defined Types & Details:**

#### `AudioService` 
- **Fields / Properties:**
  - `_sosPlayer`
  - `_available`
- **Methods:**
  - `AudioService()`
  - `playSosAlarm()`
  - `unawaited()`
  - `debugPrint()`
  - `stopSosAlarm()`
  - `dispose()`

---

### 📄 `auth_service.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'dart:convert';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import 'package:firebase_auth/firebase_auth.dart';`
- `import 'package:firebase_core/firebase_core.dart';`
- *...and 9 more*

**Defined Types & Details:**

#### `RegistrationData` 
> Data required to register a new user.

- **Fields / Properties:**
  - `email`
  - `password`
  - `fullName`
  - `studentId`
  - `serialNumber`
  - `birthdate`
  - `gender`
  - `courseAndYear`
  - `primaryCompetency`
  - `contactInfo`
  - `currentAddress`
  - `homeAddress`
  - `emergencyContactPerson`
  - `emergencyContactNumber`
  - `dataPrivacyConsent`

#### `OrganizationAccountData` 
> Data required for an admin-created responder organization account.

- **Fields / Properties:**
  - `organizationName`
  - `email`
  - `password`

#### `AuthService` extends ChangeNotifier implements IAuthService
> Service for Firebase Authentication and session management.  Implements Requirements 3, 4, and 5.

- **Fields / Properties:**
  - `_auth`
  - `_firestore`
  - `_currentUser`
  - `_isLoading`
  - `_initialResolveDone`
  - `_isProcessingLogin`
  - `_mfaChallengePending`
  - `firebaseUser`
  - `uid`
  - `minutes`
  - `isBadPassword`
  - `createdFirebaseUser`
  - `rethrow`
  - `user`
  - `userName`
  - `email`
  - `null`
  - `idToken`
  - `decoded`
  - `error`
  - `message`
- **Methods:**
  - `RateLimiter()`
  - `_ensureLoadingCompletes()`: Gives Firebase Auth a moment to restore the persisted session on web before concluding there's no user.
  - `notifyListeners()`
  - `_onAuthStateChanged()`
  - `_fetchAndSetUser()`
  - `_cacheUserProfile()`
  - `debugPrint()`
  - `_setFirebasePersistence()`
  - `TimeoutException()`
  - `_resetLoginAttempts()`
  - `_setRememberedSession()`
  - `Success()`
  - `_recordFailedAttemptByEmail()`
  - `Failure()`
  - `register()`: Registers a new user account.  Creates Firebase Auth account and Firestore user document with status Pending, role Member, totalServiceHours 0.
  - `_deleteCreatedAuthUser()`
  - `_deleteRestCreatedUser()`
  - `sendPasswordReset()`: Sends a Firebase password-reset email to [email].  Returns [Success] on dispatch (regardless of whether the address exists, to avoid user enumeration).
  - `reauthenticate()`: Re-authenticates the current user with their password.  Used for sensitive operations like account deletion, role changes, and destructive admin actions to verify the user's identity.
  - `completeMfaChallenge()`: Marks the MFA challenge as complete for the current session. Called after the user successfully enters a valid MFA code.
  - `cancelMfaChallenge()`: Cancels the MFA challenge and signs the user out. Called when the user navigates away from the MFA challenge.
  - `logout()`: Signs out the current user and writes an audit log entry.
  - `restoreSession()`: Restores the authenticated session from Firebase Auth state.  Called on app startup; the [authStateChanges] listener handles this automatically, but this method can be called explicitly if needed.
  - `_recordFailedLoginAttempt()`
  - `_readCachedUserProfile()`
  - `_firebaseAuthExceptionFromRest()`
  - `_RestCreatedAuthUser()`
  - `_firebaseAuthRestUri()`
  - `FirebaseAuthException()`

#### `_RestCreatedAuthUser` 
- **Fields / Properties:**
  - `uid`
  - `idToken`
- **Methods:**
  - `_RestCreatedAuthUser()`

---

### 📄 `auth_service_extensions.dart`
**Key Imports:**
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import '../../core/utils/audit_logger.dart';`
- `import '../models/audit_log.dart';`
- `import '../models/extensions/mfa_code.dart';`
- `import '../models/user.dart';`
- *...and 3 more*

**Defined Types & Details:**

#### `PasswordPolicy` 
- **Fields / Properties:**
  - `minLength`
  - `requireUppercase`
  - `requireLowercase`
  - `requireNumber`
  - `requireSpecialChar`
  - `null`
  - `score`
- **Methods:**
  - `validate()`

#### `AuthServiceExtensions` extends ChangeNotifier
- **Fields / Properties:**
  - `_authService`
  - `_firestore`
  - `_mfaService`
  - `_sessionService`
  - `minutes`
  - `currentUser`
- **Methods:**
  - `getPasswordPolicy()`
  - `isAccountLocked()`
  - `getLockoutMessage()`
  - `recordFailedAttempt()`
  - `resetLoginAttempts()`
  - `endSession()`
  - `getUserSessions()`
  - `forceLogoutUser()`
  - `impersonateUser()`
  - `stopImpersonating()`

---

### 📄 `cloudinary_service.dart`
**Key Imports:**
- `import 'dart:convert';`
- `import 'package:crypto/crypto.dart';`
- `import 'package:http/http.dart' as http;`
- `import 'package:image_picker/image_picker.dart';`

**Defined Types & Details:**

#### `CloudinaryService` 
- **Fields / Properties:**
  - `cloudName`
  - `apiKey`
  - `apiSecret`
  - `data`
  - `results`
- **Methods:**
  - `uploadImage()`
  - `Exception()`
  - `_sign()`
  - `uploadMultiple()`

---

### 📄 `crud_service.dart`
**Key Imports:**
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import '../../core/utils/audit_logger.dart';`
- `import '../../core/utils/validators.dart';`
- `import '../../shared/app_feedback.dart';`
- `import '../models/audit_log.dart';`

**Defined Types & Details:**

#### `CrudService` <T>
> Provides standardized CRUD operations with notifications, audit trails, soft delete, and optimistic locking support.

- **Fields / Properties:**
  - `_firestore`
  - `_collection`
  - `item`
  - `changed`
  - `newItem`
  - `query`
  - `currentVersion`
- **Methods:**
  - `read()`
  - `_fromJson()`

#### `CrudNotifications` 
> Helper to show CRUD notifications with appropriate styling.

- **Methods:**
  - `showSuccessWithMessenger()`
  - `showErrorWithMessenger()`

---

### 📄 `firestore_service.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'dart:io';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import 'package:firebase_storage/firebase_storage.dart';`
- `import 'package:uuid/uuid.dart';`
- *...and 7 more*

**Defined Types & Details:**

#### `FirestoreService` extends ChangeNotifier
> Service for all Firestore reads and writes.  All reads use real-time [snapshots()] streams. Offline persistence is enabled so the app continues to function during connectivity gaps (Requirement 22).

- **Fields / Properties:**
  - `_db`
  - `_storage`
  - `_uuid`
  - `_lastError`
  - `_sosSubscription`
  - `models`
  - `incidentsStream`
  - `_hasActiveSOS`
  - `filtered`
  - `approved`
  - `docId`
  - `rethrow`
- **Methods:**
  - `_initSOSWatch()`
  - `dispose()`
  - `debugPrint()`
  - `incidentsVisibleTo()`
  - `notifyListeners()`
  - `saveUser()`
  - `_requireId()`
  - `deleteUser()`
  - `saveEvent()`
  - `deleteEvent()`
  - `saveIncident()`
  - `deleteIncident()`
  - `saveAttendance()`
  - `saveAnnouncement()`
  - `deleteAnnouncement()`
  - `addAuditLog()`
  - `saveQrDutyRecord()`
  - `uploadAttachment()`: Uploads a file to Firebase Cloud Storage under `incidents/{incidentId}/` and returns the download URL (Requirement 11.4).
  - `uploadProfilePicture()`: Uploads a profile picture for the given user and returns the download URL.
  - `_write()`
  - `operation()`
  - `_friendlyFirestoreError()`
  - `ArgumentError()`
  - `generateId()`: Generates a new unique ID for use as a Firestore document ID.

---

### 📄 `groq_service.dart`
**Key Imports:**
- `import 'dart:convert';`
- `import 'dart:io';`
- `import 'package:http/http.dart' as http;`
- `import 'package:shared_preferences/shared_preferences.dart';`
- `import '../../core/utils/validators.dart';`

**Defined Types & Details:**

#### `GroqModel` 
- **Fields / Properties:**
  - `id`
  - `displayName`
  - `description`
  - `_kApiKey`
  - `_kModelId`
  - `_kDefaultModel`

#### `GroqConfig` extends ChangeNotifier
> Persists and exposes the Groq API key and selected model.

- **Fields / Properties:**
  - `_apiKey`
  - `_modelId`
- **Methods:**
  - `load()`: Load persisted values from SharedPreferences.
  - `notifyListeners()`
  - `setApiKey()`
  - `setModel()`
  - `GroqException()`

#### `GroqService` 
> Calls the Groq chat completions API to generate AI-enhanced reports.

- **Fields / Properties:**
  - `config`
  - `timeout`
  - `maxRetries`
  - `rethrow`
  - `statusCode`
  - `payload`
  - `error`
  - `choices`
  - `first`
  - `message`
- **Methods:**
  - `complete()`
  - `_parseResponse()`
  - `_shouldRetry()`
  - `_retryDelay()`
  - `Duration()`
  - `enhanceReport()`: Enhances a template-generated report with AI narrative.  [templateReport] is the raw data report; Groq rewrites it into a polished professional document.

#### `GroqException` implements Exception
- **Fields / Properties:**
  - `message`
  - `statusCode`
  - `cause`
- **Methods:**
  - `GroqException()`
  - `toString()`

---

### 📄 `location_service.dart`
**Key Imports:**
- `import 'package:geolocator/geolocator.dart';`

**Defined Types & Details:**

#### `LocationResult` 
> Result of a GPS location capture attempt.

- **Fields / Properties:**
  - `latitude`
  - `longitude`
  - `success`
  - `errorMessage`

#### `LocationService` 
> Service for capturing the device's current GPS coordinates.  All errors are captured in [LocationResult] — no exceptions propagate to callers (Requirement 11.3).

- **Fields / Properties:**
  - `permission`
  - `false`
- **Methods:**
  - `LocationService()`
  - `requestPermission()`: Requests location permission from the user.  Returns `true` if permission is granted, `false` otherwise.
  - `getCurrentPosition()`: Returns the device's current GPS position.  Requests permission if not already granted. On any failure (permission denied, service disabled, timeout) returns a [LocationResult] with [LocationResult.success] == `false` and a non-null [LocationResult.errorMessage].

---

### 📄 `notification_service.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'dart:math';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import 'package:firebase_auth/firebase_auth.dart';`
- `import 'package:firebase_messaging/firebase_messaging.dart';`
- *...and 3 more*

**Defined Types & Details:**

#### `NotificationService` 
> Service for managing device notifications for SOS and critical incidents.  Server-side FCM broadcast is handled by Cloud Functions when an incident is created. This service registers the current device token and turns foreground FCM messages into repeated local alerts with vibration.

- **Fields / Properties:**
  - `_firebaseMessaging`
  - `_firestore`
  - `_auth`
  - `_initialized`
  - `_authSubscription`
  - `_recentLocalIncidentAlerts`
  - `user`
  - `isSOS`
  - `title`
  - `data`
  - `body`
  - `incidentId`
  - `payload`
  - `null`
- **Methods:**
  - `NotificationService()`
  - `FlutterLocalNotificationsPlugin()`
  - `initialize()`
  - `_createIncidentAlertChannel()`: Eagerly create the [incident_alerts] Android notification channel so that FCM push notifications always display with the correct sound and vibration settings, even when the app is in the background or has never been opened.
  - `_registerTokenForCurrentUser()`
  - `saveFCMToken()`
  - `debugPrint()`
  - `unawaited()`
  - `sendAnnouncementNotification()`
  - `_rememberLocalIncidentAlert()`
  - `_triggerVibration()`
  - `_handleForegroundMessage()`
  - `_handleNotificationTap()`
  - `getFCMToken()`
  - `removeFCMToken()`
  - `dispose()`

---

### 📄 `services.dart`
*(No classes, mixins, or enums found)*

---

### 📄 `session_service.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import 'package:uuid/uuid.dart';`
- `import '../../core/utils/audit_logger.dart';`
- `import '../models/audit_log.dart';`
- *...and 1 more*

**Defined Types & Details:**

#### `SessionService` extends ChangeNotifier
- **Fields / Properties:**
  - `_firestore`
  - `_uuid`
  - `_activityTimer`
  - `_sessionTimeoutTimer`
  - `_currentSessionId`
  - `onSessionExpired`: Callback invoked when the session expires.
  - `session`
  - `false`
- **Methods:**
  - `_startSessionTimeoutMonitor()`
  - `_checkSessionExpiry()`
  - `stopSessionTimeoutMonitor()`
  - `_startActivityMonitor()`
  - `notifyListeners()`
  - `updateActivity()`
  - `_resetActivityTimer()`
  - `endSession()`
  - `forceEndUserSessions()`
  - `isSessionValid()`
  - `dispose()`

---

