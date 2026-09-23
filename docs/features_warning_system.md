# Comprehensive Documentation for `warning_system`

**Path:** `lib/features/warning_system/`

## Files

### 📄 `soft_delete_mixin.dart`
**Key Imports:**
- `import 'package:cloud_firestore/cloud_firestore.dart';`

**Defined Types & Details:**

#### `SoftDeleteMixin` 
> Provides soft-delete and restore functionality for Firestore documents.  Usage: Mix this into any service or repository class.

- **Methods:**
  - `debugPrint()`
  - `applySoftDeleteFilter()`
  - `streamNonDeleted()`

#### `OptimisticLockingMixin` 
> Optimistic locking mixin for preventing concurrent edit conflicts.

- **Fields / Properties:**
  - `currentVersion`
- **Methods:**
  - `debugPrint()`

---

### 📄 `warning_dialogs.dart`
**Defined Types & Details:**

#### `WarningDialogs` 

---

