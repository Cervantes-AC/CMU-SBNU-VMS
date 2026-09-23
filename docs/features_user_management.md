# Comprehensive Documentation for `user_management`

**Path:** `lib/features/user_management/`

## Subdirectories
- `parts/`
- `widgets/`

## Files

### 📄 `user_management_controller.dart`
**Key Imports:**
- `import 'package:uuid/uuid.dart';`
- `import '../../core/utils/validators.dart';`
- `import '../../data/models/audit_log.dart';`
- `import '../../data/models/user.dart';`
- `import '../../data/services/auth_service.dart';`
- *...and 2 more*

**Defined Types & Details:**

#### `_PendingDestructiveAction` 
> Tracks pending destructive actions that require password confirmation.

- **Fields / Properties:**
  - `type`
  - `target`
- **Methods:**
  - `_PendingDestructiveAction()`

#### `UserManagementController` extends ChangeNotifier
> Controller that encapsulates state and actions for the user management screen.

- **Fields / Properties:**
  - `_auth`
  - `_firestore`
  - `_pendingAction`
  - `true`
  - `action`
  - `null`
  - `searchQuery`
  - `activeFilter`
  - `expandedUid`
  - `sortBy`
  - `sortAscending`
  - `selectedUids`
  - `confirmShow`
  - `confirmTitle`
  - `confirmMsg`
  - `confirmType`
  - `cachedUsers`
  - `usersHash`
  - `sorted`
  - `confirmAction`
  - `name`
  - `result`
- **Methods:**
  - `_destructiveActionRequiresReAuth()`: Returns the required role for the re-auth modal context.
  - `notifyListeners()`
  - `executePendingAction()`: Verifies the admin's password and executes the pending destructive action.
  - `_deleteUserInternal()`
  - `_blockInternal()`
  - `_denyInternal()`
  - `_deactivateInternal()`
  - `cancelPendingAction()`: Cancels the pending destructive action.
  - `setSearch()`
  - `setFilter()`
  - `toggleExpand()`
  - `setSortBy()`
  - `applySort()`
  - `toggleSelection()`
  - `clearSelection()`
  - `selectAll()`
  - `applyFilter()`
  - `showConfirm()`
  - `dismissConfirm()`
  - `_audit()`
  - `debugPrint()`
  - `approve()`
  - `deny()`
  - `confirmWithPassword()`
  - `block()`
  - `unblock()`
  - `deactivate()`
  - `deleteUser()`
  - `updateUser()`
  - `changeRole()`
  - `batchApprove()`
  - `batchDeny()`
  - `dispose()`

---

### 📄 `user_management_screen.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../../core/constants/app_colors.dart';`
- `import '../../core/utils/ui_helpers.dart';`
- `import '../../data/models/user.dart';`
- `import '../../data/services/auth_service.dart';`
- *...and 9 more*

**Defined Types & Details:**

#### `UserManagementScreen` extends StatefulWidget
> User account management screen - Requirement 16.

- **Methods:**
  - `UserManagementScreen()`
  - `createState()`

#### `_UserManagementScreenState` extends State<UserManagementScreen>
- **Fields / Properties:**
  - `incoming`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `build()`
  - `setState()`

---

