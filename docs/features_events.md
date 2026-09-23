# Comprehensive Documentation for `events`

**Path:** `lib/features/events/`

## Subdirectories
- `constants/`
- `widgets/`

## Files

### 📄 `events_screen.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../../core/utils/responsive.dart';`
- `import '../../core/utils/ui_helpers.dart';`
- `import '../../data/models/event.dart';`
- `import '../../data/models/user.dart';`
- *...and 8 more*

**Defined Types & Details:**

#### `EventsScreen` extends StatefulWidget
> Events screen � Requirements 8, 9, 10.

- **Methods:**
  - `EventsScreen()`
  - `createState()`

#### `_EventsScreenState` extends State<EventsScreen>
- **Fields / Properties:**
  - `_search`
  - `_filterStatus`
  - `_selected`
  - `_cachedEvents`
  - `_eventsHash`
  - `_showAttendance`
  - `list`
  - `incoming`
  - `s`
  - `filtered`
  - `total`
  - `sel`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `build()`
  - `setState()`
  - `_buildEventsContent()`
  - `_buildHeader()`
  - `_buildStatsBar()`
  - `_buildSearchAndFilter()`
  - `_buildEventGrid()`
  - `EventCard()`
  - `_showFormSheet()`

---

