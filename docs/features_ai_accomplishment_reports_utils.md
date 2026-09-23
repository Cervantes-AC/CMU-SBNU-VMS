# Comprehensive Documentation for `utils`

**Path:** `lib/features/ai_accomplishment_reports/utils/`

## Files

### 📄 `report_data_filter.dart`
**Key Imports:**
- `import '../../../data/models/attendance.dart';`
- `import '../../../data/models/event.dart';`
- `import '../../../data/models/incident.dart';`
- `import '../../../data/models/user.dart';`
- `import '../models/report_filter_state.dart';`
- *...and 1 more*

**Defined Types & Details:**

#### `FilteredReportData` 
> Holds the filtered result sets used for report generation and the stats bar.

- **Fields / Properties:**
  - `incidents`
  - `events`
  - `dateRange`
  - `sosMatch`
  - `total`
- **Methods:**
  - `Function()`

---

### 📄 `report_date_utils.dart`
**Key Imports:**
- `import '../models/report_filter_state.dart';`

**Defined Types & Details:**

#### `DateRange` 
> A resolved start/end date pair.

- **Fields / Properties:**
  - `start`
  - `end`
  - `y`
  - `m`
  - `startMonth`
  - `adjustedMonth`
  - `ampm`
- **Methods:**
  - `DateRange()`
  - `fmtDate()`: "Apr 01, 2025"
  - `resolveDateRange()`: Resolves a [DateRangePreset] (plus optional custom dates) into a concrete [DateRange]. All times are normalised to start-of-day / end-of-day.
  - `_startOfDay()`
  - `_endOfDay()`
  - `_fmtShort()`: "Apr 01" (no year — used when year is shared)
  - `fmtDateTime()`: "Apr 01, 2025  2:30 PM"

---

### 📄 `report_generator.dart`
**Key Imports:**
- `import '../../../data/models/attendance.dart';`
- `import '../../../data/models/audit_log.dart';`
- `import '../../../data/models/event.dart';`
- `import '../../../data/models/incident.dart';`
- `import '../../../data/models/qr_duty_record.dart';`
- *...and 4 more*

*(No classes, mixins, or enums found)*

---

### 📄 `report_pdf_exporter.dart`
**Key Imports:**
- `import 'dart:typed_data';`
- `import 'package:pdf/pdf.dart';`
- `import 'package:pdf/widgets.dart' as pw;`
- `import 'package:printing/printing.dart';`

*(No classes, mixins, or enums found)*

---

