# Comprehensive Documentation for `widgets`

**Path:** `lib/features/attendance/widgets/`

## Files

### 📄 `attendance_event_picker.dart`
**Key Imports:**
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/event.dart';`
- `import '../../../shared/status_helpers.dart';`

**Defined Types & Details:**

#### `AttendanceEventPicker` extends StatelessWidget
> Dropdown that lists all events. Shows a detail card below when one is selected.

- **Fields / Properties:**
  - `events`
  - `selected`
  - `onChanged`
- **Methods:**
  - `build()`
  - `onChanged()`

#### `_EventInfoCard` extends StatelessWidget
- **Fields / Properties:**
  - `event`
- **Methods:**
  - `_EventInfoCard()`
  - `build()`

#### `_Pill` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `bg`
  - `fg`
- **Methods:**
  - `_Pill()`
  - `build()`

---

### 📄 `attendance_stats_bar.dart`
**Key Imports:**
- `import '../../../core/utils/ui_helpers.dart';`

**Defined Types & Details:**

#### `AttendanceStats` 
> Computed attendance statistics for a single event.

- **Fields / Properties:**
  - `total`
  - `present`
  - `absent`
  - `excused`
  - `pending`

#### `AttendanceStatsBar` extends StatelessWidget
- **Fields / Properties:**
  - `stats`
- **Methods:**
  - `AttendanceStatsBar()`
  - `build()`

#### `_Tile` 
- **Fields / Properties:**
  - `icon`
  - `label`
  - `value`
  - `color`
  - `badge`

#### `_StatTile` extends StatelessWidget
- **Fields / Properties:**
  - `tile`
- **Methods:**
  - `_StatTile()`
  - `build()`

#### `_AttendanceProgressBar` extends StatelessWidget
- **Fields / Properties:**
  - `stats`
  - `total`
  - `presentFrac`
  - `absentFrac`
  - `excusedFrac`
- **Methods:**
  - `_AttendanceProgressBar()`
  - `build()`

#### `_Legend` extends StatelessWidget
- **Fields / Properties:**
  - `color`
  - `label`
- **Methods:**
  - `_Legend()`
  - `build()`

---

### 📄 `attendance_volunteer_card.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import 'package:uuid/uuid.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/attendance.dart';`
- `import '../../../data/models/audit_log.dart';`
- *...and 6 more*

**Defined Types & Details:**

#### `AttendanceVolunteerCard` extends StatefulWidget
- **Fields / Properties:**
  - `volunteer`
  - `event`
  - `existing`
- **Methods:**
  - `createState()`
  - `_AttendanceVolunteerCardState()`

#### `_AttendanceVolunteerCardState` extends State<AttendanceVolunteerCard>
- **Fields / Properties:**
  - `_saving`
  - `officer`
  - `isMarked`
- **Methods:**
  - `_mark()`
  - `setState()`
  - `showFeedback()`
  - `build()`

#### `_ActionBtn` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `color`
  - `active`
  - `tooltip`
  - `onTap`
- **Methods:**
  - `build()`

#### `_StatusBadge` extends StatelessWidget
- **Fields / Properties:**
  - `status`
- **Methods:**
  - `_StatusBadge()`
  - `build()`

---

