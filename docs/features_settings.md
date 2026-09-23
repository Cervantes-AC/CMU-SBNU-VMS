# Comprehensive Documentation for `settings`

**Path:** `lib/features/settings/`

## Subdirectories
- `sections/`
- `widgets/`

## Files

### 📄 `settings_screen.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../../core/utils/responsive.dart';`
- `import '../../core/utils/ui_helpers.dart';`
- `import '../../data/models/user.dart';`
- `import '../../data/services/auth_service.dart';`
- *...and 12 more*

**Defined Types & Details:**

#### `SettingsScreen` extends StatefulWidget
- **Methods:**
  - `SettingsScreen()`
  - `createState()`

#### `_SettingsScreenState` extends State<SettingsScreen>
- **Fields / Properties:**
  - `_showPrivacy`
  - `s`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `build()`
  - `_openPage()`
  - `_buildPageHeader()`
  - `_buildPrivacyModal()`
  - `_privacySection()`

---

