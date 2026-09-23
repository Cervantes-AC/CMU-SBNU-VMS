# Comprehensive Documentation for `emergency_hotlines`

**Path:** `lib/features/emergency_hotlines/`

## Files

### 📄 `emergency_hotlines_screen.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'package:url_launcher/url_launcher.dart';`
- `import '../../core/utils/ui_helpers.dart';`
- `import '../../data/models/user.dart';`
- `import '../../shared/app_feedback.dart';`
- *...and 2 more*

**Defined Types & Details:**

#### `EmergencyHotlinesScreen` extends StatefulWidget
- **Methods:**
  - `EmergencyHotlinesScreen()`
  - `createState()`
  - `_EmergencyHotlinesScreenState()`

#### `_EmergencyHotlinesScreenState` extends State<EmergencyHotlinesScreen>
- **Fields / Properties:**
  - `_search`
  - `groups`
  - `twoColumns`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `build()`
  - `_buildSearchBar()`
  - `setState()`
  - `_buildPriorityGrid()`
  - `_buildResponseTip()`
  - `_callNumber()`
  - `unawaited()`
  - `launchUrl()`
  - `_copyNumber()`

#### `_PriorityHotlineTile` extends StatelessWidget
- **Fields / Properties:**
  - `item`
  - `onCall`
  - `onCopy`
- **Methods:**
  - `build()`

#### `_HotlineGroupCard` extends StatelessWidget
- **Fields / Properties:**
  - `group`
  - `onCall`
  - `onCopy`
- **Methods:**
  - `build()`

#### `_HotlineRow` extends StatelessWidget
- **Fields / Properties:**
  - `item`
  - `onCall`
  - `onCopy`
- **Methods:**
  - `build()`

#### `_HotlineItem` 
- **Fields / Properties:**
  - `name`
  - `number`
  - `description`
  - `icon`
  - `color`
  - `priority`

#### `_HotlineGroup` 
- **Fields / Properties:**
  - `category`
  - `icon`
  - `color`
  - `items`
- **Methods:**
  - `copyWith()`

---

