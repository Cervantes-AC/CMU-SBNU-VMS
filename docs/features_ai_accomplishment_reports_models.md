# Comprehensive Documentation for `models`

**Path:** `lib/features/ai_accomplishment_reports/models/`

## Files

### 📄 `report_filter_state.dart`
**Key Imports:**
- `import '../../../data/models/incident.dart';`

**Defined Types & Details:**

#### `ReportCategory` 
> The type of report to generate.

- **Fields / Properties:**
  - `incidents`

#### `DateRangePreset` 
> Plain-English date range presets. No jargon.

- **Fields / Properties:**
  - `custom`

#### `IncidentStatusFilter` 
- **Fields / Properties:**
  - `resolved`

#### `EventTypeFilter` 
- **Fields / Properties:**
  - `emergency`

#### `ReportSortBy` 
- **Fields / Properties:**
  - `status`

#### `ReportFilterState` 
> Immutable snapshot of all active filter values. No redundant "reporting cycle" field — the date range is the single source of truth for the report period.

- **Fields / Properties:**
  - `category`
  - `datePreset`
  - `customStart`
  - `customEnd`
  - `incidentStatus`
  - `eventType`
  - `sosOnly`
  - `searchQuery`
  - `sortBy`
  - `selectedEventId`

---

