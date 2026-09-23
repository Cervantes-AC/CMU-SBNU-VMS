# Comprehensive Documentation for `sections`

**Path:** `lib/features/settings/sections/`

## Files

### 📄 `about_section_page.dart`
**Key Imports:**
- `import '../../../core/utils/responsive.dart';`
- `import '../widgets/settings_card.dart';`

**Defined Types & Details:**

#### `AboutSectionPage` extends StatelessWidget
- **Fields / Properties:**
  - `s`
- **Methods:**
  - `AboutSectionPage()`
  - `build()`
  - `_aboutRow()`

---

### 📄 `account_security_section_page.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../../../core/utils/responsive.dart';`
- `import '../../../data/services/auth_service.dart';`
- `import '../../../shared/result.dart';`

**Defined Types & Details:**

#### `AccountSecuritySectionPage` extends StatefulWidget
- **Methods:**
  - `AccountSecuritySectionPage()`
  - `createState()`
  - `_AccountSecuritySectionPageState()`

#### `_AccountSecuritySectionPageState` 
- **Fields / Properties:**
  - `_sendingReset`
  - `_error`
  - `_success`
  - `email`
  - `s`
- **Methods:**
  - `_sendPasswordReset()`
  - `setState()`
  - `build()`
  - `_showDeleteConfirmDialog()`
  - `_sectionHeader()`

---

### 📄 `ai_model_section_page.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/services/groq_service.dart';`
- `import '../widgets/api_key_card.dart';`
- *...and 1 more*

**Defined Types & Details:**

#### `AiModelSectionPage` extends StatelessWidget
- **Fields / Properties:**
  - `s`
  - `isSelected`
- **Methods:**
  - `AiModelSectionPage()`
  - `build()`

---

### 📄 `contact_section_page.dart`
**Key Imports:**
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../widgets/settings_card.dart';`

**Defined Types & Details:**

#### `ContactSectionPage` extends StatelessWidget
- **Fields / Properties:**
  - `s`
- **Methods:**
  - `ContactSectionPage()`
  - `build()`
  - `_socialBtn()`

---

### 📄 `help_section_page.dart`
**Key Imports:**
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../shared/app_feedback.dart';`
- `import '../widgets/settings_card.dart';`

**Defined Types & Details:**

#### `HelpSectionPage` extends StatefulWidget
- **Methods:**
  - `HelpSectionPage()`
  - `createState()`

#### `_HelpSectionPageState` extends State<HelpSectionPage>
- **Fields / Properties:**
  - `_feedbackType`
  - `s`
- **Methods:**
  - `dispose()`
  - `build()`

---

### 📄 `interface_section_page.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../../../core/theme/theme_provider.dart';`
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../widgets/settings_card.dart';`

**Defined Types & Details:**

#### `InterfaceSectionPage` extends StatelessWidget
- **Fields / Properties:**
  - `s`
  - `sel`
- **Methods:**
  - `InterfaceSectionPage()`
  - `build()`

---

### 📄 `notifications_section_page.dart`
**Key Imports:**
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../widgets/settings_card.dart';`

**Defined Types & Details:**

#### `NotificationsSectionPage` extends StatefulWidget
- **Methods:**
  - `NotificationsSectionPage()`
  - `createState()`
  - `_NotificationsSectionPageState()`

#### `_NotificationsSectionPageState` extends State<NotificationsSectionPage>
- **Fields / Properties:**
  - `_notificationsEnabled`
  - `s`
- **Methods:**
  - `build()`

---

### 📄 `profile_section_page.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'dart:io';`
- `import 'package:image_picker/image_picker.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../../core/constants/app_colors.dart';`
- *...and 9 more*

**Defined Types & Details:**

#### `ProfileSectionPage` extends StatefulWidget
- **Methods:**
  - `ProfileSectionPage()`
  - `createState()`

#### `_ProfileSectionPageState` extends State<ProfileSectionPage>
- **Fields / Properties:**
  - `_editing`
  - `_uploadingPhoto`
  - `_previewPath`
  - `_uploadError`
  - `_uploadSuccess`
  - `false`
  - `true`
  - `user`
  - `s`
- **Methods:**
  - `_validateFile()`
  - `setState()`
  - `_pickAndUploadPhoto()`
  - `_removePhoto()`
  - `unawaited()`
  - `build()`

---

