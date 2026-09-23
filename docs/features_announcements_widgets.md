# Comprehensive Documentation for `widgets`

**Path:** `lib/features/announcements/widgets/`

## Files

### 📄 `announcements_dialog.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../../../core/constants/app_colors.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/announcement.dart';`
- `import '../../../data/models/user.dart';`
- *...and 4 more*

**Defined Types & Details:**

#### `_AnnouncementsModal` extends StatefulWidget
- **Methods:**
  - `_AnnouncementsModal()`
  - `createState()`

#### `_AnnouncementsModalState` extends State<_AnnouncementsModal>
- **Fields / Properties:**
  - `_searchQuery`
  - `_priorityFilter`
  - `list`
  - `all`
  - `sel`
  - `hasFilters`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `_applyFilters()`
  - `build()`
  - `_buildHeader()`
  - `_buildStats()`
  - `_buildFilterBar()`
  - `_buildList()`

---

### 📄 `announcement_card.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import 'package:uuid/uuid.dart';`
- `import '../../../core/constants/app_colors.dart';`
- `import '../../../core/theme/app_theme.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- *...and 7 more*

**Defined Types & Details:**

#### `AnnouncementCard` extends StatefulWidget
- **Fields / Properties:**
  - `announcement`
- **Methods:**
  - `AnnouncementCard()`
  - `createState()`

#### `_AnnouncementCardState` extends State<AnnouncementCard>
- **Fields / Properties:**
  - `_expanded`
  - `ampm`
  - `color`
  - `ann`
  - `isHigh`
- **Methods:**
  - `_fmtDate()`
  - `_editAnnouncement()`
  - `_confirmDelete()`
  - `build()`

#### `_DeleteConfirmDialog` extends StatelessWidget
- **Fields / Properties:**
  - `title`
- **Methods:**
  - `_DeleteConfirmDialog()`
  - `build()`

---

### 📄 `announcement_filter_bar.dart`
**Key Imports:**
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/announcement.dart';`

**Defined Types & Details:**

#### `AnnouncementFilterBar` extends StatefulWidget
> Search + priority filter bar for the announcements list.

- **Fields / Properties:**
  - `searchQuery`
  - `priorityFilter`
  - `onSearchChanged`
  - `onPriorityChanged`
- **Methods:**
  - `createState()`

#### `_AnnouncementFilterBarState` extends State<AnnouncementFilterBar>
- **Methods:**
  - `initState()`
  - `didUpdateWidget()`
  - `dispose()`
  - `_chipColor()`
  - `build()`

#### `_FilterChip` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `selected`
  - `color`
  - `onTap`
- **Methods:**
  - `build()`

---

### 📄 `announcement_form_sheet.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import 'package:uuid/uuid.dart';`
- `import '../../../core/constants/app_colors.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/announcement.dart';`
- *...and 4 more*

**Defined Types & Details:**

#### `AnnouncementFormSheet` extends StatefulWidget
- **Fields / Properties:**
  - `announcement`
- **Methods:**
  - `AnnouncementFormSheet()`
  - `createState()`

#### `_AnnouncementFormSheetState` extends State<AnnouncementFormSheet>
- **Fields / Properties:**
  - `_priority`
  - `_saving`
  - `_error`
  - `ann`
  - `user`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `_submit()`
  - `setState()`
  - `build()`
  - `_FormHeader()`
  - `_inputDeco()`

#### `_FormHeader` extends StatelessWidget
- **Fields / Properties:**
  - `onClose`
  - `isEdit`
- **Methods:**
  - `_FormHeader()`
  - `build()`

#### `_PriorityPicker` extends StatelessWidget
- **Fields / Properties:**
  - `cs`
  - `selected`
  - `onChanged`
  - `sel`
- **Methods:**
  - `build()`
  - `_priorityColor()`
  - `_priorityIcon()`

#### `_PostButton` extends StatelessWidget
- **Fields / Properties:**
  - `saving`
  - `isEdit`
  - `onTap`
- **Methods:**
  - `build()`

#### `_FieldLabel` extends StatelessWidget
- **Fields / Properties:**
  - `label`
- **Methods:**
  - `_FieldLabel()`
  - `build()`

#### `_ErrorBanner` extends StatelessWidget
- **Fields / Properties:**
  - `message`
- **Methods:**
  - `_ErrorBanner()`
  - `build()`

---

### 📄 `announcement_stats_bar.dart`
**Key Imports:**
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/announcement.dart';`

**Defined Types & Details:**

#### `AnnouncementStatsBar` extends StatelessWidget
- **Fields / Properties:**
  - `announcements`
  - `total`
  - `i`
  - `s`
- **Methods:**
  - `AnnouncementStatsBar()`
  - `build()`

---

