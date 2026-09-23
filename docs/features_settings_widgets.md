# Comprehensive Documentation for `widgets`

**Path:** `lib/features/settings/widgets/`

## Files

### 📄 `api_key_card.dart`
**Key Imports:**
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/services/groq_service.dart';`

**Defined Types & Details:**

#### `ApiKeyCard` extends StatefulWidget
- **Fields / Properties:**
  - `config`
- **Methods:**
  - `ApiKeyCard()`
  - `createState()`

#### `_ApiKeyCardState` extends State<ApiKeyCard>
- **Fields / Properties:**
  - `_obscure`
  - `_saved`
  - `s`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `build()`

---

### 📄 `profile_card.dart`
**Key Imports:**
- `import 'dart:io';`
- `import '../../../core/constants/app_colors.dart';`
- `import '../../../core/utils/responsive.dart';`
- `import '../../../data/models/user.dart';`
- `import '../../profile/widgets/profile_avatar.dart';`

**Defined Types & Details:**

#### `ProfileCard` extends StatelessWidget
- **Fields / Properties:**
  - `user`
  - `uploading`
  - `previewPath`
  - `uploadError`
  - `uploadSuccess`
  - `onTap`
  - `onRemove`
  - `onDismissError`
  - `s`
- **Methods:**
  - `build()`

---

### 📄 `settings_card.dart`
**Key Imports:**
- `import '../../../core/constants/app_colors.dart';`
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/ui_helpers.dart';`

**Defined Types & Details:**

#### `SettingsCard` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `title`
  - `subtitle`
  - `child`
  - `s`
- **Methods:**
  - `build()`

---

### 📄 `settings_nav_button.dart`
**Key Imports:**
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/ui_helpers.dart';`

**Defined Types & Details:**

#### `SettingsNavButton` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `title`
  - `subtitle`
  - `onTap`
  - `s`
- **Methods:**
  - `build()`

---

### 📄 `verified_badge.dart`
**Key Imports:**
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/user.dart';`

**Defined Types & Details:**

#### `VerifiedBadge` extends StatelessWidget
- **Fields / Properties:**
  - `user`
  - `s`
- **Methods:**
  - `VerifiedBadge()`
  - `build()`

---

