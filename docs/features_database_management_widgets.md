# Comprehensive Documentation for `widgets`

**Path:** `lib/features/database_management/widgets/`

## Files

### 📄 `database_command_bar.dart`
**Key Imports:**
- `import '../../../core/constants/app_constants.dart';`
- `import '../models.dart';`

**Defined Types & Details:**

#### `DatabaseCommandBar` extends StatelessWidget
- **Fields / Properties:**
  - `query`
  - `dataset`
  - `visibleCount`
  - `onQueryChanged`
  - `onExportCurrent`
  - `onExportAll`
- **Methods:**
  - `build()`

#### `VisibleBadge` extends StatelessWidget
- **Fields / Properties:**
  - `count`
  - `total`
- **Methods:**
  - `VisibleBadge()`
  - `build()`

---

### 📄 `database_dataset_cards.dart`
**Key Imports:**
- `import '../models.dart';`

**Defined Types & Details:**

#### `DatasetCards` extends StatelessWidget
- **Fields / Properties:**
  - `datasets`
  - `selectedIndex`
  - `onSelected`
- **Methods:**
  - `build()`

#### `DatasetCard` extends StatelessWidget
- **Fields / Properties:**
  - `dataset`
  - `selected`
  - `onTap`
- **Methods:**
  - `build()`

#### `CollectionTag` extends StatelessWidget
- **Fields / Properties:**
  - `name`
  - `color`
- **Methods:**
  - `CollectionTag()`
  - `build()`

---

### 📄 `database_hero.dart`
**Key Imports:**
- `import '../../../core/constants/app_constants.dart';`
- `import '../../../data/models/incident.dart';`
- `import '../models.dart';`

**Defined Types & Details:**

#### `DatabaseHero` extends StatelessWidget
- **Fields / Properties:**
  - `data`
  - `compact`
- **Methods:**
  - `DatabaseHero()`
  - `build()`

#### `HeroCopy` extends StatelessWidget
- **Fields / Properties:**
  - `activeIncidents`
- **Methods:**
  - `HeroCopy()`
  - `build()`

#### `HeroMetrics` extends StatelessWidget
- **Fields / Properties:**
  - `userCount`
  - `eventCount`
  - `incidentCount`
  - `sosCount`
- **Methods:**
  - `build()`

#### `HeroPill` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `label`
- **Methods:**
  - `HeroPill()`
  - `build()`

---

### 📄 `database_stream_scope.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../../../core/constants/app_colors.dart';`
- `import '../../../data/models/event.dart';`
- `import '../../../data/models/incident.dart';`
- `import '../../../data/models/user.dart';`
- *...and 6 more*

**Defined Types & Details:**

#### `DatabaseStreamScope` extends StatefulWidget
- **Methods:**
  - `DatabaseStreamScope()`
  - `createState()`

#### `DatabaseStreamScopeState` extends State<DatabaseStreamScope>
- **Methods:**
  - `build()`

---

### 📄 `database_table.dart`
**Key Imports:**
- `import '../../../core/constants/app_constants.dart';`
- `import '../models.dart';`
- `import 'database_dataset_cards.dart';`

**Defined Types & Details:**

#### `DatabaseTable` extends StatelessWidget
- **Fields / Properties:**
  - `dataset`
  - `rows`
- **Methods:**
  - `DatabaseTable()`
  - `build()`
  - `_showDetails()`

#### `TableHeader` extends StatelessWidget
- **Fields / Properties:**
  - `dataset`
- **Methods:**
  - `TableHeader()`
  - `build()`

#### `DetailRow` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `value`
- **Methods:**
  - `DetailRow()`
  - `build()`

#### `ClipText` extends StatelessWidget
- **Fields / Properties:**
  - `value`
  - `monospace`
- **Methods:**
  - `ClipText()`
  - `build()`

#### `LoadMessage` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `message`
- **Methods:**
  - `LoadMessage()`
  - `build()`

---

### 📄 `widgets.dart`
*(No classes, mixins, or enums found)*

---

