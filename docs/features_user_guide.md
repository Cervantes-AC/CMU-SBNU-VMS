# Comprehensive Documentation for `user_guide`

**Path:** `lib/features/user_guide/`

## Files

### 📄 `user_guide_screen.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../../core/utils/ui_helpers.dart';`
- `import '../../data/models/user.dart';`
- `import '../../data/services/auth_service.dart';`
- `import '../../shared/app_shell.dart';`
- *...and 1 more*

**Defined Types & Details:**

#### `UserGuideScreen` extends StatefulWidget
- **Methods:**
  - `UserGuideScreen()`
  - `createState()`

#### `_UserGuideScreenState` extends State<UserGuideScreen>
- **Fields / Properties:**
  - `_search`
  - `_selectedCategory`
  - `category`
  - `selected`
- **Methods:**
  - `dispose()`
  - `build()`
  - `_matchesFilters()`
  - `_buildSearchBar()`
  - `setState()`
  - `_buildCategoryRail()`

#### `_GuideSectionCard` extends StatefulWidget
- **Fields / Properties:**
  - `section`
- **Methods:**
  - `_GuideSectionCard()`
  - `createState()`

#### `_GuideSectionCardState` extends State<_GuideSectionCard>
- **Fields / Properties:**
  - `_expanded`
  - `section`
- **Methods:**
  - `build()`

#### `_IconBadge` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `color`
- **Methods:**
  - `_IconBadge()`
  - `build()`

#### `_GuideStep` extends StatelessWidget
- **Fields / Properties:**
  - `number`
  - `text`
  - `color`
- **Methods:**
  - `build()`

#### `_GuideSection` 
- **Fields / Properties:**
  - `title`
  - `category`
  - `icon`
  - `color`
  - `summary`
  - `steps`
  - `roles`

---

