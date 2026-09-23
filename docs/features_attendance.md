# Features/Attendance

## Features
This folder handles the attendance monitoring and tracking system for the application. It provides distinct functionalities tailored for different user roles (officers and members).
- **Officer View:** Officers can select events, view assigned volunteers, and mark their attendance statuses (Present, Absent, Excused), either individually or in bulk.
- **Member View:** Members can view their own QR duty records (time-in and time-out events), their total accumulated service hours, and view filtering by week or month.

## Functions & Architecture
- **State Management:** The module relies heavily on `Provider` (`context.read`, `context.watch`) to interface with underlying services and repositories. `StreamBuilder` widgets are used in the officer view to reactively display real-time updates from Firestore (events, users, attendance).
- **Key Screens:**
  - `AttendanceScreen` (`attendance_screen.dart`): Guarded by `RouteGuard` requiring `UserRole.officer`. Acts as the central dashboard for officers to monitor attendance. It fetches real-time streams for events, users, and attendance records, computes statistics, handles searching, and executes bulk attendance actions.
  - `MemberAttendanceScreen` (`member_attendance_screen.dart`): Guarded by `RouteGuard` requiring `UserRole.member`. Fetches the current user's `QrDutyRecord`s via `QrDutyRepository`. It computes and displays the user's total, weekly, and monthly service hours based on matched time-in and time-out records.
- **Sub-widgets (`widgets/` directory):**
  - `AttendanceEventPicker` (`attendance_event_picker.dart`): Provides a stylized dropdown to select an event. Upon selection, it displays an informative card detailing the event (activity type, status, schedule, venue, volunteer count) and a prompt to use QR scanning if the event is ongoing.
  - `AttendanceStatsBar` (`attendance_stats_bar.dart`): Takes an `AttendanceStats` object to display key metrics (Expected, Present, Absent, Excused, Pending) alongside an aggregated attendance rate percentage, presented via individual stat tiles and a segmented progress bar.
  - `AttendanceVolunteerCard` (`attendance_volunteer_card.dart`): Displays an individual volunteer's information (avatar, name, student ID) and their current attendance status. Includes quick-action buttons to mark the volunteer's status, which triggers a Firestore update and logs the action in the `AuditLog`.

## UI/UX
- **Structure:** Encapsulated within the `AppShell` component for consistent layout. Pages utilize `PageHeader`, customized card decorations, and `EmptyState` indicators when data is sparse.
- **Interactions:**
  - Smooth staggered entrance animations using an `AnimationController` to load list items sequentially.
  - Skeleton loaders are utilized while streams initially resolve.
  - Instant visual feedback is provided via `showFeedback` (snackbars) after saving data.
- **Visuals:** Follows a strict color-coded convention: Green (Present/Time In/Success), Red (Absent/Error), Gold/Amber/Orange (Excused/Time Out/Pending/Ongoing), and Blue (General Info/Expected counts).

## Connections
- **Core/Shared Modules:** Integrates with `core/utils/` (`responsive.dart`, `ui_helpers.dart`) for scaling and styling, and `shared/` (`app_shell.dart`, `route_guard.dart`, `app_feedback.dart`, `status_helpers.dart`) for global UI behaviors.
- **Data Models:** Consumes models from `data/models/` including `event.dart`, `user.dart`, `attendance.dart`, `audit_log.dart`, and `qr_duty_record.dart`.
- **Services/Repositories:** Directly depends on `FirestoreService` (for streams, saving attendance, and logging audits), `AuthService` (to identify the current user), and `QrDutyRepository` (to load member-specific duty records).
