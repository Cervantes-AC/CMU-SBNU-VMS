# Audit Logs Feature Documentation

## Features
The `audit_logs` feature provides a user interface for system administrators to view, filter, search, and export system audit logs. It acts as a chronological chain of custody, helping admins monitor system usage, track down suspicious activity, and audit actions across different categories such as Auth, User, Event, Incident, etc. It satisfies "Requirement 18" in the app's specifications. 

Key capabilities include:
- Viewing logs in reverse chronological order.
- Searching logs by action, username, or details.
- Filtering logs by category (Auth, Event, Attendance, etc.) and severity (info, warning, critical).
- Displaying summary statistics for logs (Total, Critical, Auth Events, Last 24h).
- Exporting logs to CSV or JSON formats.
- Highlighting suspicious activities visually.

## Functions & Architecture

### State Management & Architecture
- **State Management**: Uses standard Flutter `StatefulWidget` for local state (search queries, active filters) and relies on the `provider` package to access the `FirestoreService`.
- **StreamBuilder**: `AuditLogsScreen` listens to `FirestoreService().auditLogsStream` to build the UI reactively as new logs are added or changed in real-time.

### Key Classes & Methods
- **`AuditLogsScreen`**: The main entry point. Sets up an `AnimationController` for staggered entrance animations. It manages local state for `_searchQuery`, `_categoryFilter`, and `_severityFilter`. 
  - `_applyFilters(List<AuditLog> all)`: Filters the logs based on severity, category, and text search across action, username, and details.
  - `_copyToClipboard`: Calls `AuditLogExport` to generate CSV or JSON strings and copies them to the clipboard, then displays a Snackbar using `AppFeedback`.
- **`AuditLogExport`**: A utility class containing static methods for generating exports and evaluating log severity.
  - `generateCsv` / `generateJson`: Converts `List<AuditLog>` into formatted strings.
  - `isSuspicious(AuditLog log)`: Returns true if the action matches a hardcoded list of suspicious events (e.g., 'Login Failed', 'Bulk Delete') or contains certain keywords, used to flag items in the UI.
- **`AuditLogFilterBar`**: A stateless-like UI component (internally stateful just to manage its `TextEditingController` for the search box) that provides callbacks (`onSearchChanged`, `onCategoryChanged`, `onSeverityChanged`) to the parent screen.
- **`AuditLogRow`**: Represents a single log entry. Evaluates log severity and category to display appropriate colors, icons, and badges. Uses `AuditLogExport.isSuspicious` to add a red gradient and warning tooltip.

## UI/UX
- **UI Structure**: 
  - **Page Header**: Title and an Export dropdown button (CSV/JSON).
  - **Stats Bar (`_StatsBar`)**: A horizontal array of cards showing metrics: Total Logs, Critical, Auth Events, and Last 24h.
  - **Filter Bar**: A search text field above a row of two styled dropdowns for Category and Severity.
  - **Result Count**: A tiny label showing how many logs match the current filters.
  - **List View**: Displays `AuditLogRow` items or an `EmptyState` if no logs match.
- **User Experience Flow**:
  - The page loads with a staggered slide-up animation. 
  - A skeleton loading state is shown while the stream connects.
  - If a user enters text or changes a dropdown, the list filters instantaneously on the client side.
  - Hovering or interacting with a suspicious log shows extra tooltip warnings.
  - Exporting copies data to clipboard and shows a green success snackbar.
- **Widgets Used**: `AppShell` (for the main scaffold), `RouteGuard` (to enforce admin-only access), `SkeletonList`, `EmptyState`, `PageHeader`, `Tooltip`, `TextField`, `DropdownButton`, and custom styled container boxes.

## Connections
This feature integrates with multiple other parts of the application:
- **Core / UI Utils**: Uses `kPagePaddingScaled`, `staggered` animations, `themedCardDecoration`, `kSectionGap`, and defined colors (like `kGreen`, `kBlue`, `kRed`) from `core/utils/ui_helpers.dart` and `core/constants/app_colors.dart`.
- **Data Models**: Relies on `AuditLog` (including `AuditSeverity` enum) and `User` from the `data/models` module.
- **Services**: Consumes `FirestoreService` via `Provider` to fetch `auditLogsStream`.
- **Shared Components**: 
  - `AppShell`: Wraps the screen.
  - `RouteGuard`: Ensures only users with `UserRole.admin` and `Feature.auditLogs` access can view the page.
  - `AppFeedback`: Used for showing snackbars on successful export.
