# Comprehensive Documentation for `dashboard`

**Path:** `lib/shared/widgets/dashboard/`

## Files

### 📄 `dashboard.dart`
*(No classes, mixins, or enums found)*

---

### 📄 `dashboard_activity_badge.dart`
**Key Imports:**
- `import '../../../core/utils/ui_helpers.dart';`

**Defined Types & Details:**

#### `DashboardActivityBadge` extends StatelessWidget
- **Fields / Properties:**
  - `activityType`
  - `kBlue`
- **Methods:**
  - `DashboardActivityBadge()`
  - `build()`

---

### 📄 `dashboard_constants.dart`
*(No classes, mixins, or enums found)*

---

### 📄 `dashboard_dot_grid_painter.dart`
**Key Imports:**
- `import 'dart:math' as math;`
- `import '../../../core/utils/ui_helpers.dart';`

**Defined Types & Details:**

#### `DashboardDotGridPainter` extends CustomPainter
- **Fields / Properties:**
  - `color`
  - `spacing`
- **Methods:**
  - `DashboardDotGridPainter()`
  - `paint()`
  - `shouldRepaint()`

---

### 📄 `dashboard_empty_state.dart`
**Defined Types & Details:**

#### `DashboardEmptyState` extends StatelessWidget
- **Fields / Properties:**
  - `message`
  - `icon`
- **Methods:**
  - `DashboardEmptyState()`
  - `build()`

---

### 📄 `dashboard_error_banner.dart`
**Key Imports:**
- `import '../../../core/theme/app_theme.dart';`

**Defined Types & Details:**

#### `DashboardErrorBanner` extends StatelessWidget
- **Fields / Properties:**
  - `message`
  - `onRetry`
- **Methods:**
  - `DashboardErrorBanner()`
  - `build()`

---

### 📄 `dashboard_event_row.dart`
**Key Imports:**
- `import '../../../core/theme/app_theme.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/event.dart';`
- `import 'dashboard_activity_badge.dart';`
- `import 'dashboard_constants.dart';`

**Defined Types & Details:**

#### `DashboardEventRow` extends StatelessWidget
- **Fields / Properties:**
  - `event`
  - `onTap`
  - `dt`
- **Methods:**
  - `build()`

---

### 📄 `dashboard_hero_card.dart`
**Key Imports:**
- `import '../../../core/theme/app_theme.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import 'dashboard_dot_grid_painter.dart';`

**Defined Types & Details:**

#### `DashboardHeroCard` extends StatelessWidget
- **Fields / Properties:**
  - `eyebrow`
  - `title`
  - `subtitle`
  - `icon`
  - `accentColor`
  - `badges`
  - `trailing`
- **Methods:**
  - `build()`

---

### 📄 `dashboard_incident_row.dart`
**Key Imports:**
- `import '../../../core/theme/app_theme.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/incident.dart';`
- `import 'dashboard_pulsing_dot.dart';`

**Defined Types & Details:**

#### `DashboardIncidentRow` extends StatelessWidget
- **Fields / Properties:**
  - `incident`
  - `onTap`
  - `kBlue`
  - `dt`
  - `isResolved`
- **Methods:**
  - `build()`

---

### 📄 `dashboard_mini_card.dart`
**Key Imports:**
- `import '../../../core/theme/app_theme.dart';`

**Defined Types & Details:**

#### `DashboardMiniCard` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `iconBg`
  - `iconColor`
  - `label`
  - `value`
  - `progress`
  - `progressColor`
- **Methods:**
  - `build()`

---

### 📄 `dashboard_pill.dart`
**Defined Types & Details:**

#### `DashboardPill` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `bgColor`
  - `textColor`
  - `borderColor`
  - `leading`
- **Methods:**
  - `build()`

---

### 📄 `dashboard_priority_panel.dart`
**Key Imports:**
- `import '../../../core/theme/app_theme.dart';`

**Defined Types & Details:**

#### `DashboardPriorityItem` 
- **Fields / Properties:**
  - `icon`
  - `title`
  - `detail`
  - `actionLabel`
  - `route`
  - `color`
  - `urgent`

#### `DashboardPriorityPanel` extends StatelessWidget
- **Fields / Properties:**
  - `title`
  - `subtitle`
  - `icon`
  - `accentColor`
  - `items`
- **Methods:**
  - `build()`

#### `_DashboardPriorityRow` extends StatelessWidget
- **Fields / Properties:**
  - `item`
- **Methods:**
  - `_DashboardPriorityRow()`
  - `build()`

---

### 📄 `dashboard_pulsing_dot.dart`
**Defined Types & Details:**

#### `DashboardPulsingDot` extends StatefulWidget
- **Fields / Properties:**
  - `color`
- **Methods:**
  - `DashboardPulsingDot()`
  - `createState()`

#### `_DashboardPulsingDotState` extends State<DashboardPulsingDot>
- **Fields / Properties:**
  - `_ctrl`
  - `_anim`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `build()`

---

### 📄 `dashboard_quick_action.dart`
**Key Imports:**
- `import '../../../core/theme/app_theme.dart';`
- `import '../../../core/utils/ui_helpers.dart';`

**Defined Types & Details:**

#### `DashboardQuickAction` 
- **Fields / Properties:**
  - `icon`
  - `label`
  - `color`
  - `route`
  - `arguments`

#### `DashboardQuickActionBar` extends StatelessWidget
- **Fields / Properties:**
  - `actions`
- **Methods:**
  - `DashboardQuickActionBar()`
  - `build()`

---

### 📄 `dashboard_section_divider.dart`
**Key Imports:**
- `import '../../../core/theme/app_theme.dart';`

**Defined Types & Details:**

#### `DashboardSectionDivider` extends StatelessWidget
- **Fields / Properties:**
  - `label`
- **Methods:**
  - `DashboardSectionDivider()`
  - `build()`

---

### 📄 `dashboard_skeleton_list.dart`
**Defined Types & Details:**

#### `DashboardSkeletonList` extends StatelessWidget
- **Fields / Properties:**
  - `controller`
  - `itemCount`
- **Methods:**
  - `build()`

---

### 📄 `dashboard_stat_bar_item.dart`
**Key Imports:**
- `import 'dashboard_stat_item.dart';`

**Defined Types & Details:**

#### `DashboardStatBarItem` extends StatelessWidget
- **Fields / Properties:**
  - `stat`
- **Methods:**
  - `DashboardStatBarItem()`
  - `build()`

---

### 📄 `dashboard_stat_item.dart`
**Defined Types & Details:**

#### `DashboardStatItem` 
- **Fields / Properties:**
  - `icon`
  - `value`
  - `label`
  - `color`

---

