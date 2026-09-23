# Comprehensive Documentation for `widgets`

**Path:** `lib/features/analytics/widgets/`

## Files

### 📄 `analytics_charts.dart`
**Key Imports:**
- `import 'package:fl_chart/fl_chart.dart';`
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/attendance.dart';`
- `import '../../../data/models/event.dart';`
- `import '../../../data/models/incident.dart';`
- *...and 1 more*

**Defined Types & Details:**

#### `ServiceHoursBarChart` extends StatelessWidget
- **Fields / Properties:**
  - `users`
  - `hrs`
  - `max`
  - `pct`
  - `color`
- **Methods:**
  - `ServiceHoursBarChart()`
  - `build()`

#### `EventStatusPieChart` extends StatelessWidget
- **Fields / Properties:**
  - `events`
  - `counts`
- **Methods:**
  - `EventStatusPieChart()`
  - `build()`

#### `IncidentTypeChart` extends StatelessWidget
- **Fields / Properties:**
  - `incidents`
  - `counts`
  - `max`
  - `pct`
  - `color`
- **Methods:**
  - `IncidentTypeChart()`
  - `build()`

#### `CompetencyPieChart` extends StatefulWidget
- **Fields / Properties:**
  - `users`
- **Methods:**
  - `CompetencyPieChart()`
  - `createState()`

#### `_CompetencyPieChartState` extends State<CompetencyPieChart>
- **Fields / Properties:**
  - `_touched`
  - `counts`
  - `isTouched`
  - `color`
- **Methods:**
  - `build()`
  - `setState()`

#### `AttendanceBarChart` extends StatelessWidget
- **Fields / Properties:**
  - `events`
  - `attendance`
  - `users`
  - `total`
- **Methods:**
  - `build()`

#### `IncidentTrendChart` extends StatelessWidget
- **Fields / Properties:**
  - `incidents`
  - `d`
- **Methods:**
  - `build()`
  - `return()`

#### `PerformanceRadarChart` extends StatelessWidget
- **Fields / Properties:**
  - `totalEvents`
  - `totalIncidents`
  - `resolvedIncidents`
  - `totalHours`
  - `volunteerCount`
  - `avgAttendanceRate`
- **Methods:**
  - `build()`

#### `_EmptyChart` extends StatelessWidget
- **Fields / Properties:**
  - `message`
- **Methods:**
  - `_EmptyChart()`
  - `build()`

---

### 📄 `analytics_chart_card.dart`
**Key Imports:**
- `import '../../../core/utils/ui_helpers.dart';`

**Defined Types & Details:**

#### `AnalyticsChartCard` extends StatelessWidget
> Wraps any chart widget in a styled card with a header.

- **Fields / Properties:**
  - `title`
  - `subtitle`
  - `child`
  - `legend`
- **Methods:**
  - `build()`

#### `AnalyticsLegendItem` 
- **Fields / Properties:**
  - `label`
  - `color`
- **Methods:**
  - `AnalyticsLegendItem()`
  - `analyticsLegend()`: Factory helper so callers can build legend lists concisely.

---

### 📄 `analytics_kpi_bar.dart`
**Key Imports:**
- `import '../../../core/constants/app_colors.dart';`

**Defined Types & Details:**

#### `AnalyticsKpiBar` extends StatelessWidget
- **Fields / Properties:**
  - `volunteerCount`
  - `eventCount`
  - `incidentCount`
  - `totalServiceHours`
- **Methods:**
  - `build()`

#### `_Stat` 
- **Fields / Properties:**
  - `icon`
  - `label`
  - `value`
  - `gradient`

#### `_KpiTile` extends StatelessWidget
- **Fields / Properties:**
  - `stat`
- **Methods:**
  - `_KpiTile()`
  - `build()`

---

