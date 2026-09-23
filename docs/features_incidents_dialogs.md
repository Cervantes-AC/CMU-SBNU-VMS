# Comprehensive Documentation for `dialogs`

**Path:** `lib/features/incidents/dialogs/`

## Files

### 📄 `report_bottom_sheet.dart`
**Key Imports:**
- `import 'package:image_picker/image_picker.dart';`
- `import 'package:provider/provider.dart';`
- `import 'package:uuid/uuid.dart';`
- `import '../../../core/constants/app_constants.dart';`
- `import '../../../data/models/audit_log.dart';`
- *...and 8 more*

**Defined Types & Details:**

#### `ReportBottomSheet` extends StatefulWidget
- **Fields / Properties:**
  - `incident`
- **Methods:**
  - `ReportBottomSheet()`
  - `createState()`

#### `_ReportBottomSheetState` extends State<ReportBottomSheet>
- **Fields / Properties:**
  - `_type`
  - `_severity`
  - `_assistance`
  - `_affected`
  - `_saving`
  - `_images`
  - `_uploadingImages`
  - `inc`
  - `user`
  - `lat`
  - `lng`
  - `mediaUrls`
  - `isSOS`
  - `sel`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `_pickImages()`
  - `setState()`
  - `_takePhoto()`
  - `_removeImage()`
  - `_submit()`
  - `showFeedback()`
  - `_showImageSourceDialog()`
  - `build()`
  - `_sectionLabel()`
  - `_buildCategoryGrid()`
  - `_buildSeverityRow()`
  - `_buildAssistanceDropdown()`

#### `_AddPhotoButton` extends StatelessWidget
- **Fields / Properties:**
  - `onTap`
- **Methods:**
  - `_AddPhotoButton()`
  - `build()`

#### `_ImagePreview` extends StatelessWidget
- **Fields / Properties:**
  - `file`
  - `onRemove`
- **Methods:**
  - `_ImagePreview()`
  - `build()`

---

