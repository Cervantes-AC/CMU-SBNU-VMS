# Comprehensive Documentation for `import_export`

**Path:** `lib/data/services/import_export/`

## Files

### 📄 `import_export_service.dart`
**Key Imports:**
- `import 'dart:convert';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import 'package:uuid/uuid.dart';`
- `import '../../../core/utils/audit_logger.dart';`
- `import '../../models/audit_log.dart';`

**Defined Types & Details:**

#### `ImportResult` 
- **Fields / Properties:**
  - `totalRows`
  - `successCount`
  - `failCount`
  - `errors`

#### `ExportData` 
- **Fields / Properties:**
  - `fileName`
  - `mimeType`
  - `bytes`

#### `CollectionStat` 
- **Fields / Properties:**
  - `name`
  - `count`
  - `sampleFields`

#### `ImportExportService` extends ChangeNotifier
- **Fields / Properties:**
  - `_firestore`
  - `_uuid`
  - `_progress`
  - `_isRunning`
  - `_lastError`
  - `_collectionStats`
  - `collections`
  - `stats`
  - `d`
  - `rows`
  - `success`
  - `fail`
  - `errors`
  - `failedRows`
  - `row`
  - `val`
  - `items`
  - `preview`
  - `columns`
  - `value`
  - `result`
  - `current`
  - `inQuotes`
  - `c`
- **Methods:**
  - `loadCollectionStats()`
  - `notifyListeners()`
  - `ImportResult()`
  - `_getColumns()`
  - `_escapeCsv()`
  - `_parseCsvLine()`

---

### 📄 `pdf_export_service.dart`
**Key Imports:**
- `import 'package:pdf/pdf.dart';`
- `import 'package:pdf/widgets.dart' as pw;`
- `import 'package:printing/printing.dart';`

**Defined Types & Details:**

#### `PdfExportService` 
- **Fields / Properties:**
  - `null`
- **Methods:**
  - `_loadFont()`
  - `printPdf()`

---

