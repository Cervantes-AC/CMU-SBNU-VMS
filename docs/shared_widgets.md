# Comprehensive Documentation for `widgets`

**Path:** `lib/shared/widgets/`

## Subdirectories
- `dashboard/`

## Files

### 📄 `animated_widgets.dart`
**Defined Types & Details:**

#### `PulsingDot` extends StatefulWidget
- **Fields / Properties:**
  - `color`
  - `size`
- **Methods:**
  - `PulsingDot()`
  - `createState()`

#### `_PulsingDotState` extends State<PulsingDot>
- **Methods:**
  - `initState()`
  - `dispose()`
  - `build()`

#### `StaggeredList` extends StatelessWidget
- **Fields / Properties:**
  - `children`
  - `controller`
  - `totalDuration`
  - `offsetDistance`
  - `i`
  - `child`
- **Methods:**
  - `build()`

---

### 📄 `backdrop.dart`
**Key Imports:**
- `import '../../core/utils/responsive.dart';`

**Defined Types & Details:**

#### `ContentConstraint` extends StatelessWidget
- **Fields / Properties:**
  - `child`
  - `maxWidth`
  - `mw`
- **Methods:**
  - `ContentConstraint()`
  - `build()`

#### `FeatureBackdrop` extends StatelessWidget
- **Fields / Properties:**
  - `child`
  - `constrainContent`
  - `backdrop`
- **Methods:**
  - `build()`

#### `_FeatureBackdropPainter` extends CustomPainter
- **Fields / Properties:**
  - `grid`
  - `accent`
  - `gap`
- **Methods:**
  - `_FeatureBackdropPainter()`
  - `paint()`
  - `shouldRepaint()`

---

### 📄 `confirm_dialog.dart`
**Key Imports:**
- `import '../../core/constants/app_colors.dart';`

**Defined Types & Details:**

#### `ConfirmDialog` extends StatelessWidget
- **Fields / Properties:**
  - `title`
  - `message`
  - `type`
  - `isD`
  - `isS`
- **Methods:**
  - `build()`

---

### 📄 `empty_state.dart`
**Defined Types & Details:**

#### `EmptyState` extends StatelessWidget
- **Fields / Properties:**
  - `message`
  - `subtitle`
  - `icon`
- **Methods:**
  - `build()`

---

### 📄 `form_auto_save.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'package:shared_preferences/shared_preferences.dart';`

**Defined Types & Details:**

#### `FormAutoSave` <T extends StatefulWidget> on State<T>
> Mixin for automatically saving form field values as drafts.  Usage: ```dart class MyForm extends StatefulWidget { ... } class _MyFormState extends State<MyForm> with FormAutoSave { ... } ```  Call `initAutoSave(draftKey, {debounceMs})` in initState. Call `saveField(key, value)` in each field's onChanged. Call `clearDraft()` on successful submission.

- **Fields / Properties:**
  - `_draftKey`
  - `_saveTimer`
  - `_restoreTimer`
  - `_draftRestored`
- **Methods:**
  - `initAutoSave()`: Initialize auto-save for this form. [draftKey] must be unique per form (e.g., 'draft_event_form').
  - `_restoreDraft()`
  - `saveField()`: Save a single field value to the draft.
  - `_persistDraft()`
  - `saveFields()`: Save multiple field values at once.
  - `flushDraft()`: Persist all pending draft changes immediately without debounce.
  - `clearDraft()`
  - `MapEntry()`
  - `onDraftRestored()`: Override to populate form fields from restored draft values.
  - `setState()`
  - `onDismiss()`
  - `dispose()`

---

### 📄 `icon_action_button.dart`
**Defined Types & Details:**

#### `IconActionButton` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `color`
  - `tooltip`
  - `onTap`
  - `size`
- **Methods:**
  - `build()`

---

### 📄 `logo_badge.dart`
**Key Imports:**
- `import '../../core/constants/app_colors.dart';`

**Defined Types & Details:**

#### `LogoBadge` extends StatelessWidget
- **Fields / Properties:**
  - `asset`
  - `scale`
  - `baseSize`
- **Methods:**
  - `build()`

---

### 📄 `notification_bell.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../data/services/auth_service.dart';`
- `import '../app_feedback.dart';`

**Defined Types & Details:**

#### `NotificationBell` extends StatefulWidget
- **Fields / Properties:**
  - `iconColor`
  - `iconSize`
- **Methods:**
  - `createState()`

#### `_NotificationBellState` extends State<NotificationBell>
- **Fields / Properties:**
  - `_unreadCount`
  - `_sub`
- **Methods:**
  - `initState()`
  - `_setupListener()`
  - `dispose()`
  - `build()`
  - `_showNotificationPanel()`

#### `_NotificationPanel` extends StatelessWidget
- **Fields / Properties:**
  - `docs`
  - `isRead`
  - `title`
  - `body`
  - `type`
  - `createdAt`
- **Methods:**
  - `_NotificationPanel()`
  - `build()`
  - `_markAllRead()`
  - `_getColor()`
  - `_getIcon()`
  - `_formatTime()`

---

### 📄 `page_header.dart`
**Defined Types & Details:**

#### `PageHeader` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `iconColor`
  - `title`
  - `subtitle`
- **Methods:**
  - `build()`

---

### 📄 `password_policy_indicator.dart`
**Key Imports:**
- `import '../../core/constants/app_colors.dart';`

**Defined Types & Details:**

#### `PasswordPolicyIndicator` extends StatelessWidget
- **Fields / Properties:**
  - `password`
  - `strength`
  - `strengthColor`
  - `strengthLabel`
- **Methods:**
  - `PasswordPolicyIndicator()`
  - `build()`

#### `_Check` 
- **Fields / Properties:**
  - `label`
  - `passed`
- **Methods:**
  - `_Check()`

#### `PasswordStrengthMeter` extends StatelessWidget
- **Fields / Properties:**
  - `password`
- **Methods:**
  - `PasswordStrengthMeter()`
  - `build()`

---

### 📄 `pill_badge.dart`
**Defined Types & Details:**

#### `PillBadge` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `color`
  - `icon`
- **Methods:**
  - `build()`

#### `WhitePillBadge` extends StatelessWidget
- **Fields / Properties:**
  - `label`
- **Methods:**
  - `WhitePillBadge()`
  - `build()`

#### `FooterBadge` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `color`
  - `icon`
- **Methods:**
  - `build()`

---

### 📄 `section_widgets.dart`
**Key Imports:**
- `import '../../core/constants/app_colors.dart';`

**Defined Types & Details:**

#### `SectionLabel` extends StatelessWidget
- **Fields / Properties:**
  - `text`
  - `color`
- **Methods:**
  - `SectionLabel()`
  - `build()`
  - `smallSectionLabel()`
  - `fieldLabel()`

---

### 📄 `skeleton_loader.dart`
**Defined Types & Details:**

#### `SkeletonList` extends StatefulWidget
- **Fields / Properties:**
  - `count`
  - `height`
- **Methods:**
  - `SkeletonList()`
  - `createState()`

#### `_SkeletonListState` extends State<SkeletonList>
- **Fields / Properties:**
  - `_ctrl`
  - `base`
  - `highlight`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `build()`

---

### 📄 `stat_widgets.dart`
**Defined Types & Details:**

#### `StatItem` 
- **Fields / Properties:**
  - `icon`
  - `value`
  - `label`
  - `color`

#### `StatsBar` extends StatelessWidget
- **Fields / Properties:**
  - `stats`
  - `i`
  - `s`
- **Methods:**
  - `StatsBar()`
  - `build()`

---

### 📄 `warning_overlay.dart`
**Key Imports:**
- `import 'dart:async';`
- `import '../../core/constants/app_colors.dart';`

**Defined Types & Details:**

#### `WarningOverlay` extends StatefulWidget
- **Fields / Properties:**
  - `child`
- **Methods:**
  - `WarningOverlay()`
  - `createState()`

#### `_WarningOverlayState` extends State<WarningOverlay>
- **Fields / Properties:**
  - `_activeWarnings`
  - `_cleanupTimer`
- **Methods:**
  - `setState()`
  - `Timer()`
  - `dispose()`
  - `build()`

#### `_WarningBanner` extends StatelessWidget
- **Fields / Properties:**
  - `warning`
  - `onDismiss`
- **Methods:**
  - `_WarningBanner()`
  - `build()`

#### `_WarningType` critical, security, info, success }

#### `_WarningItem` 
- **Fields / Properties:**
  - `id`
  - `title`
  - `message`
  - `type`
  - `createdAt`

#### `WarningSystem` 

#### `WarningType` confirmation, impactSummary, captcha }

---

### 📄 `widgets.dart`
*(No classes, mixins, or enums found)*

---

