# Comprehensive Documentation for `widgets`

**Path:** `lib/features/ai_accomplishment_reports/widgets/`

## Files

### 📄 `report_focus_selector.dart`
**Key Imports:**
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../models/report_filter_state.dart';`

**Defined Types & Details:**

#### `ReportFocusSelector` extends StatelessWidget
- **Fields / Properties:**
  - `filters`
  - `onCategoryChanged`
- **Methods:**
  - `build()`

#### `_Label` extends StatelessWidget
- **Fields / Properties:**
  - `text`
  - `cs`
- **Methods:**
  - `_Label()`
  - `build()`

#### `_CategoryCard` extends StatelessWidget
- **Fields / Properties:**
  - `category`
  - `selected`
  - `onTap`
  - `cs`
  - `isDark`
  - `color`
- **Methods:**
  - `build()`

---

### 📄 `report_generate_button.dart`
**Key Imports:**
- `import '../models/report_filter_state.dart';`

**Defined Types & Details:**

#### `ReportGenerateButton` extends StatelessWidget
- **Fields / Properties:**
  - `isGenerating`
  - `canGenerate`
  - `filteredCount`
  - `category`
  - `onGenerate`
- **Methods:**
  - `build()`

#### `_StatusIndicator` extends StatelessWidget
- **Fields / Properties:**
  - `isGenerating`
  - `cs`
- **Methods:**
  - `_StatusIndicator()`
  - `build()`

#### `_GenerateButton` extends StatelessWidget
- **Fields / Properties:**
  - `isGenerating`
  - `canGenerate`
  - `onTap`
  - `cs`
  - `enabled`
- **Methods:**
  - `build()`

---

### 📄 `report_loading_panel.dart`
**Defined Types & Details:**

#### `ReportLoadingPanel` extends StatefulWidget
- **Methods:**
  - `ReportLoadingPanel()`
  - `createState()`

#### `_ReportLoadingPanelState` extends State<ReportLoadingPanel>
- **Methods:**
  - `initState()`
  - `dispose()`
  - `build()`

#### `_ProgressDots` extends StatelessWidget
- **Fields / Properties:**
  - `animation`
  - `cs`
  - `delay`
- **Methods:**
  - `_ProgressDots()`
  - `build()`

---

### 📄 `report_output_panel.dart`
**Key Imports:**
- `import '../../../core/constants/app_colors.dart';`
- `import '../../../shared/app_feedback.dart';`
- `import '../models/report_filter_state.dart';`
- `import '../utils/report_date_utils.dart';`
- `import '../utils/report_pdf_exporter.dart';`

**Defined Types & Details:**

#### `ReportOutputPanel` extends StatelessWidget
- **Fields / Properties:**
  - `report`
  - `filters`
  - `onClear`
- **Methods:**
  - `build()`
  - `_copyReport()`
  - `_downloadReport()`
  - `downloadReportPdf()`
  - `_printReport()`
  - `printReportPdf()`

#### `_ReportHeader` extends StatelessWidget
- **Fields / Properties:**
  - `title`
  - `subtitle`
  - `onClear`
  - `onCopy`
  - `onDownload`
  - `onPrint`
  - `cs`
- **Methods:**
  - `build()`

#### `_HeaderAction` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `label`
  - `onTap`
- **Methods:**
  - `build()`

#### `_ReportBody` extends StatelessWidget
- **Fields / Properties:**
  - `report`
  - `cs`
  - `isDark`
- **Methods:**
  - `_ReportBody()`
  - `build()`

#### `_MarkdownText` extends StatelessWidget
- **Fields / Properties:**
  - `text`
  - `cs`
  - `widgets`
  - `line`
  - `isFirst`
  - `spans`
  - `last`
- **Methods:**
  - `_MarkdownText()`
  - `build()`
  - `_renderLine()`
  - `_renderTableRow()`
  - `_renderInline()`
  - `RichText()`

---

### 📄 `report_stats_bar.dart`
**Defined Types & Details:**

#### `ReportStatsBar` extends StatelessWidget
- **Fields / Properties:**
  - `eventCount`
  - `incidentCount`
  - `sosCount`
  - `volunteerCount`
- **Methods:**
  - `build()`

#### `_Stat` 
- **Fields / Properties:**
  - `icon`
  - `label`
  - `value`
  - `gradient`

#### `_StatTile` extends StatelessWidget
- **Fields / Properties:**
  - `stat`
  - `cs`
- **Methods:**
  - `_StatTile()`
  - `build()`

---

### 📄 `report_tactical_filters.dart`
**Key Imports:**
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/event.dart';`
- `import '../models/report_filter_state.dart';`

**Defined Types & Details:**

#### `ReportTacticalFilters` extends StatelessWidget
- **Fields / Properties:**
  - `filters`
  - `events`
  - `onSearchChanged`
  - `onSortChanged`
  - `onEventSelected`
  - `onIncidentStatusChanged`
  - `onSosOnlyChanged`
  - `onEventTypeChanged`
  - `onReset`
  - `onSortChangedLegacy`
- **Methods:**
  - `build()`
  - `_buildCategoryFilters()`

#### `_Label` extends StatelessWidget
- **Fields / Properties:**
  - `text`
  - `cs`
- **Methods:**
  - `_Label()`
  - `build()`

#### `_SearchField` extends StatefulWidget
- **Fields / Properties:**
  - `value`
  - `onChanged`
  - `cs`
- **Methods:**
  - `createState()`

#### `_SearchFieldState` extends State<_SearchField>
- **Fields / Properties:**
  - `cs`
  - `isDark`
- **Methods:**
  - `initState()`
  - `didUpdateWidget()`
  - `dispose()`
  - `build()`

#### `_SortPicker` extends StatelessWidget
- **Fields / Properties:**
  - `value`
  - `onChanged`
  - `cs`
- **Methods:**
  - `build()`

#### `_EventPicker` extends StatelessWidget
- **Fields / Properties:**
  - `events`
  - `selectedId`
  - `onChanged`
  - `cs`
- **Methods:**
  - `build()`

#### `_SosToggle` extends StatelessWidget
- **Fields / Properties:**
  - `value`
  - `onChanged`
  - `cs`
  - `isDark`
- **Methods:**
  - `build()`

#### `_ResetLink` extends StatelessWidget
- **Fields / Properties:**
  - `onTap`
  - `hasFilters`
  - `cs`
  - `isDark`
- **Methods:**
  - `build()`

#### `_DropdownRow` <T> extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `label`
  - `value`
  - `items`
  - `onChanged`
  - `cs`
  - `isDark`
- **Methods:**
  - `build()`

---

### 📄 `report_time_selector.dart`
**Key Imports:**
- `import '../models/report_filter_state.dart';`
- `import '../utils/report_date_utils.dart';`

**Defined Types & Details:**

#### `ReportTimeSelector` extends StatelessWidget
- **Fields / Properties:**
  - `filters`
  - `onPresetChanged`
  - `onCustomStartChanged`
  - `onCustomEndChanged`
- **Methods:**
  - `build()`

#### `_Label` extends StatelessWidget
- **Fields / Properties:**
  - `text`
  - `cs`
- **Methods:**
  - `_Label()`
  - `build()`

#### `_PresetChips` extends StatelessWidget
- **Fields / Properties:**
  - `selected`
  - `onChanged`
  - `cs`
  - `isDark`
  - `sel`
- **Methods:**
  - `build()`

#### `_CustomDatePickers` extends StatelessWidget
- **Fields / Properties:**
  - `startDate`
  - `endDate`
  - `onStartChanged`
  - `onEndChanged`
  - `cs`
- **Methods:**
  - `_fmt()`
  - `fmtDate()`
  - `build()`

#### `_DateButton` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `value`
  - `onTap`
  - `cs`
  - `isDark`
- **Methods:**
  - `build()`

#### `_PeriodPreview` extends StatelessWidget
- **Fields / Properties:**
  - `range`
  - `cs`
- **Methods:**
  - `_PeriodPreview()`
  - `build()`

---

