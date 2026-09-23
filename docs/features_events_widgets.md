# Comprehensive Documentation for `widgets`

**Path:** `lib/features/events/widgets/`

## Files

### 📄 `event_card.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../../../core/theme/app_theme.dart';`
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/event.dart';`
- *...and 2 more*

**Defined Types & Details:**

#### `EventCard` extends StatelessWidget
> Card widget displaying a single event in the list.

- **Fields / Properties:**
  - `event`
  - `onTap`
  - `s`
  - `uid`
- **Methods:**
  - `EventCard()`
  - `build()`

#### `StatusPill` extends StatelessWidget
> Status pill badge for events.

- **Fields / Properties:**
  - `status`
- **Methods:**
  - `StatusPill()`
  - `build()`

#### `_DateTimeRow` extends StatelessWidget
- **Fields / Properties:**
  - `dateTime`
- **Methods:**
  - `_DateTimeRow()`
  - `build()`

#### `_VenueRow` extends StatelessWidget
- **Fields / Properties:**
  - `venue`
- **Methods:**
  - `_VenueRow()`
  - `build()`

#### `_FooterRow` extends StatelessWidget
- **Fields / Properties:**
  - `volunteerCount`
  - `isAssigned`
  - `sc`
- **Methods:**
  - `build()`

#### `_VolunteerCountBadge` extends StatelessWidget
- **Fields / Properties:**
  - `count`
- **Methods:**
  - `_VolunteerCountBadge()`
  - `build()`

#### `_JoinStatusBadge` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `color`
  - `icon`
- **Methods:**
  - `build()`

#### `DateBadge` extends StatelessWidget
> Date badge shown on the right side of event cards.

- **Fields / Properties:**
  - `dateTime`
  - `color`
  - `s`
- **Methods:**
  - `DateBadge()`
  - `build()`

---

### 📄 `event_detail_overlay.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import 'package:uuid/uuid.dart';`
- `import '../../../core/constants/app_constants.dart';`
- `import '../../../core/theme/app_theme.dart';`
- `import '../../../core/utils/responsive.dart';`
- *...and 8 more*

**Defined Types & Details:**

#### `EventDetailOverlay` extends StatelessWidget
> Overlay widget showing detailed event information.

- **Fields / Properties:**
  - `event`
  - `onDismiss`
  - `s`
  - `myRole`
  - `canReviewJoinRequests`
  - `uid`
  - `assignedVolunteers`
- **Methods:**
  - `build()`
  - `_buildHeader()`
  - `_buildVolunteerSection()`
  - `_buildFooter()`
  - `onDismiss()`
  - `onEventUpdated()`
  - `showFeedback()`
  - `_submitJoinRequest()`
  - `_deleteEvent()`
  - `_editEvent()`

#### `_StatusPillWhite` extends StatelessWidget
- **Fields / Properties:**
  - `status`
- **Methods:**
  - `_StatusPillWhite()`
  - `build()`

#### `_StatusButton` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `color`
  - `icon`
  - `onTap`
- **Methods:**
  - `build()`

#### `_JoinRequestRow` extends StatefulWidget
- **Fields / Properties:**
  - `request`
  - `event`
- **Methods:**
  - `createState()`

#### `_JoinRequestRowState` extends State<_JoinRequestRow>
- **Fields / Properties:**
  - `_displayName`
  - `_loading`
  - `users`
  - `request`
- **Methods:**
  - `initState()`
  - `_resolveName()`
  - `setState()`
  - `build()`

---

### 📄 `event_form_sheet.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import 'package:uuid/uuid.dart';`
- `import '../../../core/constants/app_colors.dart';`
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- *...and 6 more*

**Defined Types & Details:**

#### `EventFormSheet` extends StatefulWidget
> Form sheet for creating or editing events.

- **Fields / Properties:**
  - `event`
- **Methods:**
  - `EventFormSheet()`
  - `createState()`

#### `_EventFormSheetState` extends State<EventFormSheet>
- **Fields / Properties:**
  - `_activityType`
  - `_status`
  - `_dateTime`
  - `_saving`
  - `e`
  - `s`
  - `sel`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `_pickDateTime()`
  - `_submit()`
  - `setState()`
  - `showFeedback()`
  - `build()`

---

### 📄 `widgets.dart`
*(No classes, mixins, or enums found)*

---

