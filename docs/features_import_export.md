# Comprehensive Documentation for `import_export`

**Path:** `lib/features/import_export/`

## Files

### 📄 `import_export_screen.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../../core/utils/ui_helpers.dart';`
- `import '../../data/models/user.dart';`
- `import '../../data/services/auth_service.dart';`
- `import '../../data/services/import_export/import_export_service.dart';`
- *...and 2 more*

**Defined Types & Details:**

#### `ImportExportScreen` extends StatefulWidget
- **Methods:**
  - `ImportExportScreen()`
  - `createState()`

#### `_ImportExportScreenState` extends State<ImportExportScreen>
- **Fields / Properties:**
  - `_selectedCollection`
  - `_importResult`
  - `_showJsonImport`
  - `result`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `_onServiceChange()`
  - `build()`
  - `_buildHeader()`
  - `_buildCollectionStats()`
  - `_buildExportSection()`
  - `_buildImportSection()`
  - `_buildResultCard()`
  - `_formatButton()`
  - `_sectionTitle()`
  - `_export()`
  - `_previewCsv()`
  - `setState()`
  - `_import()`

---

