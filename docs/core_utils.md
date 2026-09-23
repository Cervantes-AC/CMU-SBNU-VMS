# Comprehensive Documentation for `utils`

**Path:** `lib/core/utils/`

## Files

### 📄 `audit_logger.dart`
**Key Imports:**
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import '../../data/models/audit_log.dart';`

**Defined Types & Details:**

#### `AuditLogger` 
> Centralized utility for writing audit log entries to Firestore.  Eliminates the `_writeAuditLog` method duplication that previously existed across 7+ service classes.  Usage: ```dart await AuditLogger.log( action: 'Login Success', category: 'Auth', userName: user.fullName, details: 'User logged in: ${user.email}', severity: AuditSeverity.info, ); ```

- **Fields / Properties:**
  - `_firestore`

---

### 📄 `cmu_data.dart`
**Defined Types & Details:**

#### `CmuData` 

---

### 📄 `date_helpers.dart`
*(No classes, mixins, or enums found)*

---

### 📄 `logger.dart`
**Key Imports:**
- `import 'package:firebase_crashlytics/firebase_crashlytics.dart';`

**Defined Types & Details:**

#### `LogLevel` debug, info, warning, error }

#### `AppLogger` 
- **Fields / Properties:**
  - `output`
- **Methods:**
  - `debugPrint()`
  - `_log()`

---

### 📄 `page_transition.dart`
**Defined Types & Details:**

#### `_SmoothRoute` <T> extends PageRouteBuilder<T>

---

### 📄 `responsive.dart`
**Defined Types & Details:**

#### `DeviceType` 
> Device type breakpoints (width-based).

- **Fields / Properties:**
  - `desktop`
  - `mobileMaxWidth`: Breakpoint constants.
  - `tabletMaxWidth`
  - `laptopMaxWidth`

#### `ResponsiveScaling` on BuildContext
> Responsive helpers on [BuildContext].

- **Methods:**
  - `res()`: Scale a [value] (font size, dimension, padding, margin, etc.)
  - `responsiveSymetric()`
  - `responsiveValue()`
  - `crossAxisCount()`: Max count of items that fit in a cross-axis given a minimum item width.

---

### 📄 `responsive_app.dart`
**Key Imports:**
- `import 'responsive.dart';`

**Defined Types & Details:**

#### `ResponsiveAppBuilder` extends StatelessWidget
- **Fields / Properties:**
  - `child`
  - `width`
- **Methods:**
  - `ResponsiveAppBuilder()`
  - `build()`

#### `_ResponsiveScrollBehavior` extends MaterialScrollBehavior
- **Methods:**
  - `_ResponsiveScrollBehavior()`
  - `getScrollPhysics()`

---

### 📄 `service_hours_calculator.dart`
**Key Imports:**
- `import '../../data/models/qr_duty_record.dart';`

**Defined Types & Details:**

#### `ServiceHoursSummary` 
- **Fields / Properties:**
  - `completedHours`
  - `completedSessions`
  - `openSessions`
  - `activeTimeIn`

#### `ServiceHoursCalculator` 
- **Fields / Properties:**
  - `totalMinutes`
  - `completedSessions`
  - `openSessions`
  - `activeTimeIn`
  - `grouped`

---

### 📄 `ui_helpers.dart`
**Key Imports:**
- `import '../constants/app_colors.dart';`
- `import 'responsive.dart';`

*(No classes, mixins, or enums found)*

---

### 📄 `validators.dart`
**Key Imports:**
- `import 'dart:convert';`

**Defined Types & Details:**

#### `AppValidators` 
- **Fields / Properties:**
  - `null`

#### `InputSanitizer` 
> Sanitizes user input to prevent XSS and injection attacks.

- **Fields / Properties:**
  - `data`

#### `SecureStorage` 
> Simple secure storage utility using obfuscation via base64 + HMAC-derived key. Provides a thin layer of protection for sensitive values stored in SharedPreferences, preventing casual plaintext reading.


#### `RateLimiter` 
> In-memory rate limiter for client-side throttling.

- **Fields / Properties:**
  - `maxAttempts`
  - `window`
  - `true`
- **Methods:**
  - `RateLimiter()`
  - `allow()`: Returns true if the action is allowed (under the rate limit).
  - `remaining()`: Returns the number of attempts remaining for [key].
  - `reset()`: Resets the attempt counter for [key].
  - `clear()`: Clears all rate limit data.

---

