# Comprehensive Documentation for `mfa`

**Path:** `lib/data/services/mfa/`

## Files

### 📄 `mfa_service.dart`
**Key Imports:**
- `import 'dart:convert';`
- `import 'dart:math';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import 'package:crypto/crypto.dart';`
- `import 'package:uuid/uuid.dart';`
- *...and 1 more*

**Defined Types & Details:**

#### `MfaService` extends ChangeNotifier
- **Fields / Properties:**
  - `_firestore`
  - `_uuid`
  - `code`
  - `true`
  - `codes`
  - `hashes`
- **Methods:**
  - `generateOtp()`
  - `return()`
  - `invalidateAllCodes()`
  - `generateBackupCodes()`: Generates 8 single-use backup codes, stores SHA-256 hashes on the user document, and returns the plain-text codes to show the user once.
  - `_hashCode()`

---

