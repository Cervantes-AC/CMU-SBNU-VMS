# Comprehensive Documentation for `qr_duty_monitoring`

**Path:** `lib/features/qr_duty_monitoring/`

## Files

### 📄 `duty_monitoring_dashboard.dart`
**Key Imports:**
- `import 'package:intl/intl.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../core/utils/service_hours_calculator.dart';`
- `import '../../core/utils/ui_helpers.dart';`
- `import '../../data/models/qr_duty_record.dart';`
- *...and 4 more*

**Defined Types & Details:**

#### `DutyMonitoringDashboard` extends StatelessWidget
- **Methods:**
  - `DutyMonitoringDashboard()`
  - `build()`

#### `DutyMonitoringBody` extends StatefulWidget
- **Methods:**
  - `DutyMonitoringBody()`
  - `createState()`

#### `_DutyMonitoringBodyState` extends State<DutyMonitoringBody>
- **Fields / Properties:**
  - `_searchQuery`
  - `_selectedFilter`
  - `_selectedDate`
  - `_selectedEvent`
  - `false`
  - `true`
  - `events`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `_onSearchChanged()`
  - `setState()`
  - `build()`
  - `_filteredRecords()`
  - `_getAvailableEvents()`
  - `_clearFilters()`

#### `_DutyStats` 
- **Fields / Properties:**
  - `todayIn`
  - `todayOut`
  - `activeNow`
  - `uniqueToday`
  - `todayServiceHours`
  - `totalServiceHours`
  - `completedSessionsToday`
  - `latest`
  - `latestByUser`
  - `current`

#### `_SummaryPanel` extends StatelessWidget
- **Fields / Properties:**
  - `stats`
- **Methods:**
  - `_SummaryPanel()`
  - `build()`

#### `_LatestActivity` extends StatelessWidget
- **Fields / Properties:**
  - `stats`
  - `record`
  - `color`
- **Methods:**
  - `_LatestActivity()`
  - `build()`

#### `_FilterBar` extends StatelessWidget
- **Fields / Properties:**
  - `selectedFilter`
  - `selectedDate`
  - `selectedEvent`
  - `searchController`
  - `resultCount`
  - `availableEvents`
  - `onFilterChanged`
  - `onDateChanged`
  - `onEventChanged`
  - `onClear`
  - `narrow`
- **Methods:**
  - `build()`

#### `_Dropdown` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `value`
  - `values`
  - `icon`
  - `onChanged`
- **Methods:**
  - `build()`

#### `_RecordsHeader` extends StatelessWidget
- **Fields / Properties:**
  - `count`
  - `loading`
- **Methods:**
  - `_RecordsHeader()`
  - `build()`

#### `_RecordCard` extends StatelessWidget
- **Fields / Properties:**
  - `record`
  - `compact`
  - `isTimeIn`
  - `color`
  - `icon`
- **Methods:**
  - `_RecordCard()`
  - `build()`

#### `_Meta` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `text`
- **Methods:**
  - `_Meta()`
  - `build()`

---

### 📄 `qr_code_generator_screen.dart`
**Key Imports:**
- `import 'package:intl/intl.dart';`
- `import 'package:pdf/pdf.dart';`
- `import 'package:pdf/widgets.dart' as pw;`
- `import 'package:printing/printing.dart';`
- `import 'package:provider/provider.dart';`
- *...and 12 more*

**Defined Types & Details:**

#### `QrCodeGeneratorScreen` extends StatelessWidget
- **Methods:**
  - `QrCodeGeneratorScreen()`
  - `build()`

#### `QrGeneratorBody` extends StatefulWidget
- **Methods:**
  - `QrGeneratorBody()`
  - `createState()`

#### `_QrGeneratorBodyState` extends State<QrGeneratorBody>
- **Fields / Properties:**
  - `_selectedEvent`
  - `_qrTimeInData`
  - `_qrTimeOutData`
  - `_generated`
  - `_printing`
  - `base`
  - `event`
  - `wide`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `_generateQr()`
  - `setState()`
  - `_printQr()`
  - `_copyToken()`
  - `build()`

#### `_EventPickerPanel` extends StatelessWidget
- **Fields / Properties:**
  - `events`
  - `selectedEvent`
  - `generated`
  - `onChanged`
  - `onGenerate`
- **Methods:**
  - `build()`

#### `_QrPreviewPanel` extends StatelessWidget
- **Fields / Properties:**
  - `event`
  - `qrTimeInData`
  - `qrTimeOutData`
  - `generated`
  - `printing`
  - `onPrint`
  - `wide`
- **Methods:**
  - `build()`

#### `_QrCodeCard` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `data`
  - `eventTitle`
  - `color`
- **Methods:**
  - `build()`

#### `_EventInfoCard` extends StatelessWidget
- **Fields / Properties:**
  - `event`
- **Methods:**
  - `_EventInfoCard()`
  - `build()`

#### `_InfoRow` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `label`
  - `value`
- **Methods:**
  - `build()`

---

### 📄 `qr_duty_scanner_screen.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'package:mobile_scanner/mobile_scanner.dart';`
- `import 'package:provider/provider.dart';`
- `import 'package:uuid/uuid.dart';`
- `import '../../core/utils/ui_helpers.dart';`
- *...and 11 more*

**Defined Types & Details:**

#### `QrDutyScannerScreen` extends StatelessWidget
- **Methods:**
  - `QrDutyScannerScreen()`
  - `build()`

#### `QrScannerBody` extends StatefulWidget
- **Methods:**
  - `QrScannerBody()`
  - `createState()`

#### `_QrScannerBodyState` extends State<QrScannerBody>
- **Fields / Properties:**
  - `_lastScannedCode`
  - `_processing`
  - `_torchOn`
  - `_frontCamera`
  - `_statusMessage`
  - `_isSuccess`
  - `_lastRecordType`
  - `_lastRecordTime`
  - `_scannedTokens`
  - `user`
  - `false`
  - `barcode`
  - `code`
  - `eventId`
  - `explicitType`
  - `eventTitle`
  - `nextType`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `_checkEventApproval()`
  - `_onDetect()`
  - `setState()`
  - `unawaited()`
  - `Success()`
  - `Failure()`
  - `_toggleTorch()`
  - `_switchCamera()`
  - `build()`

#### `_ScannerTopBar` extends StatelessWidget
- **Fields / Properties:**
  - `processing`
  - `torchOn`
  - `frontCamera`
  - `onTorch`
  - `onSwitchCamera`
- **Methods:**
  - `build()`

#### `_DimmedScannerOverlay` extends StatelessWidget
- **Fields / Properties:**
  - `pulseCtrl`
- **Methods:**
  - `_DimmedScannerOverlay()`
  - `build()`

#### `_CornerFrame` extends StatelessWidget
- **Methods:**
  - `_CornerFrame()`
  - `build()`

#### `_CornerFramePainter` extends CustomPainter
- **Fields / Properties:**
  - `length`
  - `inset`
- **Methods:**
  - `paint()`
  - `shouldRepaint()`

#### `_StatusBanner` extends StatelessWidget
- **Fields / Properties:**
  - `message`
  - `isSuccess`
  - `processing`
- **Methods:**
  - `build()`

#### `_BottomInfo` extends StatelessWidget
- **Fields / Properties:**
  - `lastType`
  - `lastTime`
- **Methods:**
  - `_BottomInfo()`
  - `build()`

#### `_GlassPill` extends StatelessWidget
- **Fields / Properties:**
  - `child`
- **Methods:**
  - `_GlassPill()`
  - `build()`

#### `_ScannerButton` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `tooltip`
  - `active`
  - `onTap`
- **Methods:**
  - `build()`

---

