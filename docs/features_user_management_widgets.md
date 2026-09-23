# Comprehensive Documentation for `widgets`

**Path:** `lib/features/user_management/widgets/`

## Files

### 📄 `organization_account_sheet.dart`
**Key Imports:**
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/user.dart';`
- `import '../../../shared/result.dart';`

*(No classes, mixins, or enums found)*

---

### 📄 `user_confirm_overlay.dart`
**Key Imports:**
- `import '../../../core/utils/ui_helpers.dart';`

**Defined Types & Details:**

#### `UserConfirmOverlay` extends StatelessWidget
> Confirmation overlay dialog with severity-coded styling.

- **Fields / Properties:**
  - `title`
  - `message`
  - `onConfirm`
  - `onDismiss`
  - `isD`
  - `isS`
- **Methods:**
  - `build()`

---

### 📄 `user_edit_sheet.dart`
**Key Imports:**
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/user.dart';`
- `import '../../../shared/status_helpers.dart';`

*(No classes, mixins, or enums found)*

---

### 📄 `user_impersonation.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/user.dart';`
- `import '../../../data/services/auth_service_extensions.dart';`
- `import '../../../shared/app_feedback.dart';`

**Defined Types & Details:**

#### `UserImpersonationSheet` extends StatelessWidget
- **Fields / Properties:**
  - `user`
- **Methods:**
  - `UserImpersonationSheet()`
  - `build()`
  - `_actionButton()`

---

