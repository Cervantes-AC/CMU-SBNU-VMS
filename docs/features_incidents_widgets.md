# Comprehensive Documentation for `widgets`

**Path:** `lib/features/incidents/widgets/`

## Files

### 📄 `incident_card.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import 'package:url_launcher/url_launcher.dart';`
- `import '../../../core/theme/app_theme.dart';`
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- *...and 6 more*

**Defined Types & Details:**

#### `IncidentCard` extends StatelessWidget
- **Fields / Properties:**
  - `incident`
  - `isExpanded`
  - `isOfficer`
  - `onTap`
  - `onStatusChange`
  - `s`
  - `inc`
  - `accentColor`
  - `textColor`
  - `subtextColor`
  - `narrativeBg`
  - `narrativeBorder`
  - `narrativeText`
  - `narrativeSubtext`
  - `tapHintColor`
  - `bg`
  - `border`
  - `color`
  - `labelColor`
  - `mediaBg`
  - `url`
  - `actionBg`
  - `actionBorder`
  - `footerTextColor`
  - `buttonBg`
  - `buttonText`
- **Methods:**
  - `build()`
  - `_buildHeaderRow()`
  - `_buildNarrative()`
  - `_buildDetailChips()`
  - `_buildResponderInfo()`
  - `_buildCallChip()`
  - `launchUrl()`
  - `_buildMediaGrid()`
  - `_buildAdminActions()`
  - `_buildFooter()`

#### `StatusPill` extends StatelessWidget
- **Fields / Properties:**
  - `status`
- **Methods:**
  - `StatusPill()`
  - `build()`

#### `SeverityPill` extends StatelessWidget
- **Fields / Properties:**
  - `severity`
- **Methods:**
  - `SeverityPill()`
  - `build()`

#### `StatusTimeline` extends StatefulWidget
- **Fields / Properties:**
  - `current`
- **Methods:**
  - `StatusTimeline()`
  - `createState()`

#### `_StatusTimelineState` extends State<StatusTimeline>
- **Fields / Properties:**
  - `borderColor`
  - `done`
  - `active`
  - `pulseVal`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `build()`

#### `ActionBtn` extends StatelessWidget
- **Fields / Properties:**
  - `ctx`
  - `incident`
  - `label`
  - `target`
  - `color`
  - `icon`
  - `onStatusChange`
  - `user`
  - `uid`
  - `name`
  - `updated`
- **Methods:**
  - `build()`
  - `onStatusChange()`

---

### 📄 `incident_detail_overlay.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import 'package:url_launcher/url_launcher.dart';`
- `import 'package:uuid/uuid.dart';`
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- *...and 10 more*

**Defined Types & Details:**

#### `IncidentDetailOverlay` extends StatelessWidget
- **Fields / Properties:**
  - `incident`
  - `onDismiss`
  - `onIncidentUpdated`
  - `s`
  - `inc`
  - `url`
  - `role`
  - `canEdit`
- **Methods:**
  - `build()`
  - `_buildHeader()`
  - `_buildBody()`
  - `launchUrl()`
  - `_buildResponseRow()`
  - `_buildFooter()`
  - `_editIncident()`
  - `onDismiss()`
  - `_deleteIncident()`

#### `_IconBtn` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `color`
  - `tooltip`
  - `onTap`
  - `s`
- **Methods:**
  - `build()`

#### `_WhitePill` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `icon`
- **Methods:**
  - `_WhitePill()`
  - `build()`

#### `_SeverityPill` extends StatelessWidget
- **Fields / Properties:**
  - `severity`
- **Methods:**
  - `_SeverityPill()`
  - `build()`

#### `_DetailSectionLabel` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `color`
  - `c`
- **Methods:**
  - `_DetailSectionLabel()`
  - `build()`

#### `_DetailChip` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `label`
  - `color`
- **Methods:**
  - `build()`

---

### 📄 `incident_header.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../../../core/utils/responsive.dart';`
- `import '../../../data/models/user.dart';`
- `import '../../../data/services/auth_service.dart';`
- `import '../constants/incident_helpers.dart';`
- *...and 1 more*

**Defined Types & Details:**

#### `IncidentHeader` extends StatelessWidget
- **Fields / Properties:**
  - `isTactical`
  - `onViewModeChanged`
  - `s`
- **Methods:**
  - `_buildEditorialLabel()`
  - `build()`

#### `IncidentStatsBar` extends StatelessWidget
> Stats row rendered as four editorial stat cards.

- **Fields / Properties:**
  - `activeCount`
  - `sosCount`
  - `recent24h`
  - `resolvedPct`
  - `isWide`
- **Methods:**
  - `build()`

---

### 📄 `incident_list.dart`
**Key Imports:**
- `import '../../../core/utils/responsive.dart';`
- `import '../../../data/models/incident.dart';`
- `import '../constants/incident_helpers.dart';`
- `import 'incident_card.dart';`

**Defined Types & Details:**

#### `IncidentList` extends StatelessWidget
- **Fields / Properties:**
  - `incidents`
  - `isOfficer`
  - `expandedId`
  - `onIncidentTapped`
  - `onExpandedChanged`
  - `onStatusChange`
- **Methods:**
  - `build()`
  - `onTapped()`
  - `onExpandedChanged()`
  - `onIncidentTapped()`

#### `_EmptyState` extends StatelessWidget
- **Fields / Properties:**
  - `s`
- **Methods:**
  - `_EmptyState()`
  - `build()`

#### `IncidentSkeleton` extends StatelessWidget
- **Fields / Properties:**
  - `s`
- **Methods:**
  - `IncidentSkeleton()`
  - `build()`

---

### 📄 `incident_search_filters.dart`
**Key Imports:**
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../constants/incident_helpers.dart';`

**Defined Types & Details:**

#### `IncidentSearchFilters` extends StatefulWidget
- **Fields / Properties:**
  - `searchCtrl`
  - `search`
  - `filterStatus`
  - `filterSeverity`
  - `filterType`
  - `filterAssistanceType`
  - `startDate`
  - `endDate`
  - `sortBy`
  - `sortDesc`
  - `showFilters`
  - `onSearchChanged`
  - `onFilterStatusChanged`
  - `onFilterSeverityChanged`
  - `onFilterTypeChanged`
  - `onFilterAssistanceTypeChanged`
  - `onStartDateChanged`
  - `onEndDateChanged`
  - `onSortByChanged`
  - `onSortDescChanged`
  - `onToggleFilters`
  - `onReset`
- **Methods:**
  - `createState()`

#### `_IncidentSearchFiltersState` extends State<IncidentSearchFilters>
- **Fields / Properties:**
  - `isWide`
- **Methods:**
  - `build()`
  - `_resetButton()`

---

### 📄 `incident_sos_card.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'package:provider/provider.dart';`
- `import 'package:uuid/uuid.dart';`
- `import '../../../core/theme/app_theme.dart';`
- `import '../../../core/utils/responsive.dart';`
- *...and 8 more*

**Defined Types & Details:**

#### `SOSCard` extends StatefulWidget
- **Fields / Properties:**
  - `sosCtrl`
- **Methods:**
  - `SOSCard()`
  - `createState()`

#### `_SOSCardState` extends State<SOSCard>
- **Fields / Properties:**
  - `_sendingCategory`
  - `user`
  - `s`
  - `isWide`
  - `isSending`
- **Methods:**
  - `_triggerSOS()`
  - `unawaited()`
  - `setState()`
  - `showFeedback()`
  - `build()`

#### `_SOSCategoryButton` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `icon`
  - `color`
  - `isSending`
  - `onTap`
  - `s`
- **Methods:**
  - `build()`

#### `_SOSConfirmDialog` extends StatelessWidget
- **Fields / Properties:**
  - `s`
- **Methods:**
  - `_SOSConfirmDialog()`
  - `build()`

#### `_DotPatternPainter` extends CustomPainter
- **Fields / Properties:**
  - `spacing`
  - `radius`
- **Methods:**
  - `paint()`
  - `shouldRepaint()`

---

### 📄 `sos_button.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'package:provider/provider.dart';`
- `import 'package:uuid/uuid.dart';`
- `import '../../../core/constants/app_constants.dart';`
- `import '../../../data/models/audit_log.dart';`
- *...and 6 more*

**Defined Types & Details:**

#### `SosButton` extends StatefulWidget
> SOS emergency alert button with pulsing animation.

- **Fields / Properties:**
  - `animationController`
- **Methods:**
  - `SosButton()`
  - `createState()`

#### `_SosButtonState` extends State<SosButton>
- **Fields / Properties:**
  - `_isProcessing`
  - `user`
- **Methods:**
  - `_triggerSOS()`
  - `unawaited()`
  - `setState()`
  - `showFeedback()`
  - `build()`

#### `_SOSConfirmDialog` extends StatelessWidget
- **Methods:**
  - `_SOSConfirmDialog()`
  - `build()`

---

### 📄 `tactical_map_view.dart`
**Key Imports:**
- `import 'dart:math' show pow;`
- `import 'package:latlong2/latlong.dart';`
- `import 'package:url_launcher/url_launcher.dart';`
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- *...and 2 more*

**Defined Types & Details:**

#### `TacticalMapView` extends StatefulWidget
- **Fields / Properties:**
  - `incidents`
- **Methods:**
  - `createState()`

#### `_TacticalMapViewState` extends State<TacticalMapView>
- **Fields / Properties:**
  - `_selected`
  - `_currentZoom`
  - `_prevHash`
  - `_didInitialFit`
  - `h`
  - `g`
  - `minLat`
  - `minLng`
  - `geotagged`
  - `grid`
  - `key`
  - `markers`
  - `isSOS`
  - `isSelected`
  - `size`
  - `s`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `didUpdateWidget()`
  - `_fitAllMarkers()`
  - `_buildMarkers()`
  - `_singleMarker()`
  - `setState()`
  - `_clusterMarker()`
  - `build()`
  - `_buildHudHeader()`

#### `_EnhancedIncidentPopup` extends StatelessWidget
- **Fields / Properties:**
  - `incident`
  - `onDismiss`
  - `onOpenMaps`
  - `s`
  - `isSOS`
- **Methods:**
  - `build()`

#### `_StatusBadge` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `color`
- **Methods:**
  - `_StatusBadge()`
  - `build()`

#### `_MapControls` extends StatelessWidget
- **Fields / Properties:**
  - `canZoomIn`
  - `canZoomOut`
  - `onZoomIn`
  - `onZoomOut`
  - `onRecenter`
- **Methods:**
  - `build()`

#### `_ControlButton` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `onTap`
  - `s`
- **Methods:**
  - `_ControlButton()`
  - `build()`

#### `IncidentLocationChip` extends StatelessWidget
- **Fields / Properties:**
  - `incident`
  - `s`
  - `lat`
  - `lng`
- **Methods:**
  - `IncidentLocationChip()`
  - `build()`

#### `_EmptyMapState` extends StatelessWidget
- **Methods:**
  - `_EmptyMapState()`
  - `build()`

#### `_LegendDot` extends StatelessWidget
- **Fields / Properties:**
  - `color`
  - `label`
- **Methods:**
  - `_LegendDot()`
  - `build()`

---

### 📄 `view_mode_toggle.dart`
**Key Imports:**
- `import '../constants/incident_helpers.dart';`

**Defined Types & Details:**

#### `ViewModeToggle` extends StatelessWidget
- **Fields / Properties:**
  - `isTactical`
  - `onChanged`
- **Methods:**
  - `build()`

#### `_Tab` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `label`
  - `selected`
  - `onTap`
- **Methods:**
  - `build()`

---

