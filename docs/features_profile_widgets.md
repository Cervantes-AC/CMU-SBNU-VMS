# Comprehensive Documentation for `widgets`

**Path:** `lib/features/profile/widgets/`

## Files

### 📄 `profile_avatar.dart`
**Key Imports:**
- `import '../../../core/constants/app_colors.dart';`
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/user.dart';`
- `import '../../../shared/status_helpers.dart';`

**Defined Types & Details:**

#### `ProfileAvatar` extends StatelessWidget
> Circular avatar showing the user's photo (or initial), role badge, and service hours.

- **Fields / Properties:**
  - `user`
  - `onTap`
  - `s`
  - `hasPhoto`
- **Methods:**
  - `ProfileAvatar()`
  - `build()`

#### `_Pill` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `color`
- **Methods:**
  - `_Pill()`
  - `build()`

---

### 📄 `profile_edit_form.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../../../core/constants/app_constants.dart';`
- `import '../../../core/utils/cmu_data.dart';`
- `import '../../../core/utils/responsive.dart';`
- `import '../../../data/models/user.dart';`
- *...and 3 more*

**Defined Types & Details:**

#### `ProfileEditForm` extends StatefulWidget
> Editable form for mutable profile fields.

- **Fields / Properties:**
  - `user`
  - `onCancel`
  - `onSaved`
- **Methods:**
  - `createState()`

#### `_ProfileEditFormState` extends State<ProfileEditForm>
- **Fields / Properties:**
  - `_saving`
  - `_showAcademicErrors`
  - `_selectedCollege`
  - `_selectedProgram`
  - `_selectedYearLevel`
  - `_selectedCompetency`
  - `u`
  - `s`
- **Methods:**
  - `_parseExistingAcademic()`
  - `initState()`
  - `dispose()`
  - `_composeCourseAndYear()`
  - `_save()`
  - `setState()`
  - `build()`

#### `_EditSection` extends StatelessWidget
- **Fields / Properties:**
  - `title`
  - `icon`
  - `children`
  - `cs`
  - `s`
- **Methods:**
  - `build()`

#### `_EditField` extends StatelessWidget
- **Fields / Properties:**
  - `controller`
  - `label`
  - `hint`
  - `icon`
  - `required`
  - `keyboardType`
  - `cs`
  - `s`
- **Methods:**
  - `build()`

#### `_SaveButton` extends StatelessWidget
- **Fields / Properties:**
  - `saving`
  - `onTap`
  - `cs`
  - `s`
- **Methods:**
  - `build()`

---

### 📄 `profile_info_section.dart`
**Key Imports:**
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/user.dart';`

**Defined Types & Details:**

#### `ProfileInfoSection` extends StatelessWidget
> Displays all profile fields in grouped, read-only sections.

- **Fields / Properties:**
  - `user`
- **Methods:**
  - `ProfileInfoSection()`
  - `build()`

#### `_SectionCard` extends StatelessWidget
- **Fields / Properties:**
  - `title`
  - `icon`
  - `fields`
  - `cs`
  - `isDark`
  - `s`
  - `isLast`
- **Methods:**
  - `build()`

#### `_FieldData` 
- **Fields / Properties:**
  - `label`
  - `value`
  - `icon`
- **Methods:**
  - `_FieldData()`

#### `_FieldRow` extends StatelessWidget
- **Fields / Properties:**
  - `data`
  - `cs`
  - `s`
- **Methods:**
  - `_FieldRow()`
  - `build()`

---

