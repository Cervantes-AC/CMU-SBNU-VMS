# Comprehensive Documentation for `widgets`

**Path:** `lib/features/audit_logs/widgets/`

## Files

### 📄 `audit_log_export.dart`
**Key Imports:**
- `import 'dart:convert';`
- `import '../../../data/models/audit_log.dart';`
- `import '../../../shared/app_feedback.dart';`

**Defined Types & Details:**

#### `AuditLogExport` 
- **Fields / Properties:**
  - `false`

---

### 📄 `audit_log_filter_bar.dart`
**Key Imports:**
- `import '../../../core/utils/ui_helpers.dart';`
- `import '../../../data/models/audit_log.dart';`

**Defined Types & Details:**

#### `AuditLogFilterBar` extends StatefulWidget
- **Fields / Properties:**
  - `searchQuery`
  - `categoryFilter`
  - `severityFilter`
  - `onSearchChanged`
  - `onCategoryChanged`
  - `onSeverityChanged`
- **Methods:**
  - `createState()`

#### `_AuditLogFilterBarState` extends State<AuditLogFilterBar>
- **Methods:**
  - `initState()`
  - `didUpdateWidget()`
  - `dispose()`
  - `build()`

#### `_StyledDropdown` <T> extends StatelessWidget
- **Fields / Properties:**
  - `value`
  - `icon`
  - `hint`
  - `items`
  - `onChanged`
- **Methods:**
  - `build()`

---

### 📄 `audit_log_row.dart`
**Key Imports:**
- `import '../../../core/constants/app_colors.dart';`
- `import '../../../data/models/audit_log.dart';`
- `import 'audit_log_export.dart';`

**Defined Types & Details:**

#### `AuditLogRow` extends StatelessWidget
- **Fields / Properties:**
  - `log`
  - `ampm`
  - `sc`
- **Methods:**
  - `AuditLogRow()`
  - `_categoryColor()`
  - `_fmtDate()`
  - `build()`

---

