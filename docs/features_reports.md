# Comprehensive Documentation for `reports`

**Path:** `lib/features/reports/`

## Files

### 📄 `reports_screen.dart`
**Key Imports:**
- `import 'dart:convert';`
- `import 'dart:typed_data';`
- `import 'package:printing/printing.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../core/utils/ui_helpers.dart';`
- *...and 6 more*

**Defined Types & Details:**

#### `ReportsScreen` extends StatefulWidget
- **Methods:**
  - `ReportsScreen()`
  - `createState()`

#### `_ReportsScreenState` extends State<ReportsScreen>
- **Fields / Properties:**
  - `_selectedReport`
  - `_period`
  - `_reportData`
  - `_error`
  - `selected`
  - `_startDate`
  - `_endDate`
  - `report`
  - `data`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `_onServiceChange()`
  - `build()`
  - `_buildHeader()`
  - `_buildReportSelector()`
  - `_reportOption()`
  - `setState()`
  - `_buildDateFilters()`
  - `_buildGenerateButton()`
  - `_buildLoadingIndicator()`
  - `_buildErrorCard()`
  - `_buildReportPreview()`
  - `_buildExportOptions()`
  - `Expanded()`
  - `_outputOption()`
  - `_pickDate()`
  - `_generateReport()`
  - `_exportReport()`
  - `_saveFile()`

---

