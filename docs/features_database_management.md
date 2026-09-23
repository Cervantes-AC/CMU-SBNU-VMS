# Comprehensive Documentation for `database_management`

**Path:** `lib/features/database_management/`

## Subdirectories
- `widgets/`

## Files

### 📄 `database_management_screen.dart`
**Key Imports:**
- `import '../../core/constants/app_constants.dart';`
- `import '../../data/models/event.dart';`
- `import '../../data/models/incident.dart';`
- `import '../../data/models/user.dart';`
- `import '../../shared/app_feedback.dart';`
- *...and 8 more*

**Defined Types & Details:**

#### `DatabaseManagementScreen` extends StatefulWidget
- **Methods:**
  - `DatabaseManagementScreen()`
  - `createState()`
  - `_DatabaseManagementScreenState()`

#### `_DatabaseManagementScreenState` extends State<DatabaseManagementScreen>
- **Fields / Properties:**
  - `_selectedIndex`
  - `_query`
  - `horizontal`
  - `headers`
- **Methods:**
  - `build()`
  - `_buildBody()`
  - `setState()`
  - `_datasets()`
  - `_filteredRows()`
  - `_userRows()`
  - `_eventRows()`
  - `_incidentRows()`
  - `_shareCsv()`
  - `_toCsv()`
  - `_csv()`
  - `_date()`

---

### 📄 `models.dart`
**Key Imports:**
- `import '../../data/models/event.dart';`
- `import '../../data/models/incident.dart';`
- `import '../../data/models/user.dart';`

**Defined Types & Details:**

#### `DatabaseSnapshot` 
- **Fields / Properties:**
  - `users`
  - `events`
  - `incidents`

#### `DbRow` 
- **Fields / Properties:**
  - `id`
  - `cells`

#### `DatasetSpec` 
- **Fields / Properties:**
  - `label`
  - `collection`
  - `icon`
  - `color`
  - `description`
  - `columns`
  - `rows`

---

