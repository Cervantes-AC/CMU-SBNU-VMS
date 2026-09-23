# Comprehensive Documentation for `shared`

**Path:** `lib/shared/`

## Subdirectories
- `widgets/`

## Files

### 📄 `academic_dropdowns.dart`
**Key Imports:**
- `import '../../core/utils/cmu_data.dart';`
- `import '../../core/utils/ui_helpers.dart';`

**Defined Types & Details:**

#### `AcademicDropdowns` extends StatelessWidget
> Three cascading dropdowns: College → Program → Year Level.  [selectedCollege], [selectedProgram], [selectedYearLevel] are the current values. When the college changes, the program is reset to null.  [onChanged] is called whenever any value changes, with the latest (college, program, yearLevel) triple.

- **Fields / Properties:**
  - `selectedCollege`
  - `selectedProgram`
  - `selectedYearLevel`
  - `onChanged`
  - `showErrors`: Whether to show validation errors (pass true after form submission).
- **Methods:**
  - `build()`

#### `CompetencyDropdown` extends StatelessWidget
> Single dropdown for NSRC primary competency.

- **Fields / Properties:**
  - `value`
  - `onChanged`
  - `showError`
- **Methods:**
  - `build()`

#### `_DropdownField` <T> extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `icon`
  - `value`
  - `hint`
  - `items`
  - `onChanged`
  - `errorText`
  - `enabled`
- **Methods:**
  - `build()`

---

### 📄 `app_feedback.dart`
**Defined Types & Details:**

#### `AppFeedback` 
- **Methods:**
  - `showFeedback()`

---

### 📄 `app_shell.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'dart:ui';`
- `import 'package:connectivity_plus/connectivity_plus.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../core/connectivity/connectivity_service.dart';`
- *...and 13 more*

**Defined Types & Details:**

#### `AppShell` extends StatefulWidget
- **Fields / Properties:**
  - `body`
  - `title`
  - `actions`
  - `floatingActionButton`
  - `showBottomNav`
- **Methods:**
  - `createState()`

#### `_AppShellState` extends State<AppShell>
- **Methods:**
  - `build()`

#### `_MobileAppShell` extends StatefulWidget
- **Fields / Properties:**
  - `title`
  - `body`
  - `actions`
  - `floatingActionButton`
  - `showBottomNav`
- **Methods:**
  - `createState()`

#### `_MobileAppShellState` extends State<_MobileAppShell>
- **Methods:**
  - `initState()`
  - `dispose()`
  - `build()`

#### `_AppBar` extends StatelessWidget implements PreferredSizeWidget
- **Fields / Properties:**
  - `title`
  - `initial`
  - `user`
  - `isNsrc`
  - `actions`
  - `s`
  - `accent`
- **Methods:**
  - `build()`

#### `_Avatar` extends StatelessWidget
- **Fields / Properties:**
  - `initial`
  - `user`
  - `s`
  - `isNsrc`
  - `photoUrl`
- **Methods:**
  - `build()`

#### `_GlassBottomNav` extends StatelessWidget
- **Fields / Properties:**
  - `sosPulseCtrl`
  - `role`
  - `primaryColor`
  - `hasActiveSOS`
  - `i`
  - `item`
  - `isSelected`
- **Methods:**
  - `_GlassBottomNav()`
  - `build()`

#### `_NavItem` extends StatelessWidget
- **Fields / Properties:**
  - `icon`
  - `label`
  - `isSelected`
  - `primaryColor`
  - `badge`
  - `onTap`
- **Methods:**
  - `build()`

#### `_ScannerNavItem` extends StatefulWidget
- **Fields / Properties:**
  - `isSelected`
  - `primaryColor`
  - `onTap`
- **Methods:**
  - `createState()`

#### `_ScannerNavItemState` extends State<_ScannerNavItem>
- **Fields / Properties:**
  - `_pressed`
  - `centerBg`
- **Methods:**
  - `build()`

#### `_BottomNavItem` 
- **Fields / Properties:**
  - `icon`
  - `selectedIcon`
  - `label`
  - `route`
  - `minRole`
  - `feature`

#### `_OfflineStatusBanner` extends StatefulWidget
- **Methods:**
  - `_OfflineStatusBanner()`
  - `createState()`

#### `_OfflineStatusBannerState` extends State<_OfflineStatusBanner>
- **Fields / Properties:**
  - `_subscription`
  - `_isOffline`
  - `s`
- **Methods:**
  - `initState()`
  - `unawaited()`
  - `dispose()`
  - `build()`

---

### 📄 `audit_color_chip.dart`
**Key Imports:**
- `import '../../core/constants/app_constants.dart';`
- `import '../../data/models/audit_log.dart';`

**Defined Types & Details:**

#### `AuditColorChip` extends StatelessWidget
> A severity-colored chip for audit log entries (Requirement 18.3).

- **Fields / Properties:**
  - `severity`
- **Methods:**
  - `AuditColorChip()`
  - `build()`
  - `final()`

---

### 📄 `result.dart`
*(No classes, mixins, or enums found)*

---

### 📄 `role_aware_nav_drawer.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../core/constants/app_constants.dart';`
- `import '../data/models/user.dart';`
- `import '../data/services/auth_service.dart';`

**Defined Types & Details:**

#### `RoleAwareNavDrawer` extends StatelessWidget
- **Fields / Properties:**
  - `user`
  - `role`
- **Methods:**
  - `RoleAwareNavDrawer()`
  - `build()`

#### `_TopAccentBar` extends StatelessWidget
- **Methods:**
  - `_TopAccentBar()`
  - `build()`

#### `_HeaderSection` extends StatelessWidget
- **Fields / Properties:**
  - `user`
  - `role`
- **Methods:**
  - `_HeaderSection()`
  - `build()`

#### `_Avatar` extends StatelessWidget
- **Fields / Properties:**
  - `photoUrl`
  - `initials`
- **Methods:**
  - `_Avatar()`
  - `build()`
  - `_initials()`

#### `_RoleChip` extends StatelessWidget
- **Fields / Properties:**
  - `role`
- **Methods:**
  - `_RoleChip()`
  - `build()`

#### `_NavBody` extends StatelessWidget
- **Fields / Properties:**
  - `role`
  - `currentRoute`
- **Methods:**
  - `_NavBody()`
  - `build()`
  - `_section()`
  - `_canShow()`

#### `_NavItem` 
- **Fields / Properties:**
  - `icon`
  - `label`
  - `route`
  - `minRole`
  - `feature`
- **Methods:**
  - `_NavItem()`

#### `_NavItemWidget` extends StatefulWidget
- **Fields / Properties:**
  - `item`
  - `selected`
- **Methods:**
  - `_NavItemWidget()`
  - `createState()`

#### `_NavItemWidgetState` extends State<_NavItemWidget>
- **Fields / Properties:**
  - `_hovered`
  - `item`
- **Methods:**
  - `build()`

#### `_LogoutButton` extends StatelessWidget
- **Methods:**
  - `_LogoutButton()`
  - `build()`

---

### 📄 `route_guard.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../../core/constants/app_colors.dart';`
- `import '../../data/models/user.dart';`
- `import '../../data/services/auth_service.dart';`
- `import '../../data/services/mfa/mfa_service.dart';`
- *...and 3 more*

**Defined Types & Details:**

#### `RouteGuard` extends StatelessWidget
> Enforces role-based and MFA-based access control at the widget level.  Behaviour: - While auth state is loading → shows a branded loading screen. - Unauthenticated (and loading complete) → redirected to [LandingPage]. - Under-privileged users → shown [AccessDeniedScreen]. - Authenticated but MFA challenge pending → shown inline MFA challenge. - Fully authorized → [child] is rendered.  Optionally accepts a [requiredFeature] for feature-level gating.

- **Fields / Properties:**
  - `requiredRole`
  - `requiredFeature`
  - `child`
- **Methods:**
  - `build()`
  - `_MfaGate()`

#### `_MfaGate` extends StatefulWidget
- **Fields / Properties:**
  - `child`
- **Methods:**
  - `_MfaGate()`
  - `createState()`

#### `_MfaGateState` extends State<_MfaGate>
- **Fields / Properties:**
  - `_loading`
  - `_useBackupCode`
  - `_error`
  - `user`
- **Methods:**
  - `dispose()`
  - `_verify()`
  - `setState()`
  - `build()`

#### `_AuthLoadingScreen` extends StatelessWidget
- **Methods:**
  - `_AuthLoadingScreen()`
  - `build()`

---

### 📄 `shimmer_loading.dart`
**Defined Types & Details:**

#### `ShimmerBox` extends StatefulWidget
> A modern shimmer loading container with animated gradient.

- **Fields / Properties:**
  - `width`
  - `height`
  - `borderRadius`
  - `margin`
- **Methods:**
  - `createState()`

#### `_ShimmerBoxState` extends State<ShimmerBox>
- **Fields / Properties:**
  - `_ctrl`
  - `highlight`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `build()`

#### `ShimmerCard` extends StatelessWidget
> Card-shaped shimmer skeleton

- **Fields / Properties:**
  - `height`
  - `margin`
- **Methods:**
  - `ShimmerCard()`
  - `build()`

#### `ShimmerRow` extends StatelessWidget
> Row shimmer with circle avatar + two text lines

- **Fields / Properties:**
  - `avatarSize`
  - `margin`
- **Methods:**
  - `ShimmerRow()`
  - `build()`

#### `ShimmerStatsBar` extends StatelessWidget
> Stats bar shimmer skeleton

- **Fields / Properties:**
  - `itemCount`
- **Methods:**
  - `ShimmerStatsBar()`
  - `build()`

#### `PageSkeleton` extends StatelessWidget
> Full-page content skeleton with multiple card shapes

- **Fields / Properties:**
  - `cardCount`
- **Methods:**
  - `PageSkeleton()`
  - `build()`

---

### 📄 `sos_banner_overlay.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'package:provider/provider.dart';`
- `import '../core/constants/app_constants.dart';`
- `import '../data/models/incident.dart';`
- `import '../data/models/user.dart';`
- *...and 4 more*

**Defined Types & Details:**

#### `SOSBannerOverlay` extends StatefulWidget
- **Fields / Properties:**
  - `child`
- **Methods:**
  - `SOSBannerOverlay()`
  - `createState()`

#### `_SOSBannerOverlayState` extends State<SOSBannerOverlay>
- **Fields / Properties:**
  - `true`
  - `_dismissed`
  - `_lastAlertIncident`
  - `incidentId`
  - `role`
  - `currentUid`
  - `incident`
  - `alertId`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `AudioService()`
  - `didChangeAppLifecycleState()`
  - `_dismiss()`
  - `_addBounded()`
  - `setState()`
  - `_openIncidents()`
  - `build()`
  - `unawaited()`

#### `_IncidentAlertPopup` extends StatefulWidget
- **Fields / Properties:**
  - `incident`
  - `onDismiss`
  - `onOpen`
- **Methods:**
  - `createState()`

#### `_IncidentAlertPopupState` extends State<_IncidentAlertPopup>
- **Fields / Properties:**
  - `incident`
  - `isSOS`
  - `isCritical`
  - `hasGps`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `build()`
  - `_buildInfoRow()`

---

### 📄 `status_badge.dart`
**Key Imports:**
- `import '../../core/constants/app_constants.dart';`
- `import '../../data/models/event.dart';`
- `import '../../data/models/user.dart';`

**Defined Types & Details:**

#### `StatusBadge` extends StatelessWidget
> A color-coded chip that visually represents a status value.  Supports event statuses and user statuses (Requirements 8.3, 11, 16).

- **Fields / Properties:**
  - `label`
  - `color`
- **Methods:**
  - `StatusBadge()`
  - `final()`
  - `build()`

---

### 📄 `status_helpers.dart`
**Key Imports:**
- `import '../core/constants/app_colors.dart';`
- `import '../data/models/attendance.dart';`
- `import '../data/models/event.dart';`
- `import '../data/models/user.dart';`

*(No classes, mixins, or enums found)*

---

