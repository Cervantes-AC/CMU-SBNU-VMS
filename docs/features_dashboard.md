# Dashboard Feature Documentation

## Overview
The `dashboard` feature serves as the central hub and landing page of the NSRC VMS application. It provides a customized, role-specific experience for each user type, ensuring that the information and tools presented are highly relevant to the user's responsibilities.

## Architecture & Functions
The dashboard module uses a smart routing mechanism to delegate to specific screens based on the current user's role:

- **`DashboardScreen` / `DashboardRouter`**: Acts as the main entry point. It reads the current user's role from the `AuthService` and dynamically routes them to the appropriate dashboard implementation (`AdminDashboardScreen`, `OfficerDashboardScreen`, `MemberDashboardScreen`, or `OrganizationDashboardScreen`).

### Role-Specific Dashboards
1. **Admin Dashboard (`admin_dashboard.dart`)**:
   - **Focus**: System health, governance, and user management.
   - **Key Features**: Approving pending users, reviewing system logs and audit trails, monitoring overall application health, and observing detailed analytics (role distribution, user activity).

2. **Officer Dashboard (`officer_dashboard.dart`)**:
   - **Focus**: Operations management, team oversight, and emergency response.
   - **Key Features**: Coordinating active operations/events, managing volunteer deployment (QR duty records), overseeing active incidents/SOS alerts, and team readiness tracking.

3. **Member Dashboard (`member_dashboard.dart`)**:
   - **Focus**: Volunteer engagement and personal metrics.
   - **Key Features**: Viewing personal accumulated service hours, browsing upcoming events to join, monitoring personal readiness, and receiving active emergency/incident reports.

4. **Organization Dashboard (`organization_dashboard.dart`)**:
   - **Focus**: Incident overview and tactical planning.
   - **Key Features**: Displaying a tactical map view for active incidents, aggregating metrics on responded/resolved cases, and rapid access to SOS alerts.

### State Management & Data Handling
Each dashboard screen utilizes a `StatefulWidget` combined with `StreamSubscription`s to listen to real-time updates from various repositories (e.g., `UserRepository`, `EventRepository`, `IncidentRepository`, `QrDutyRepository`). Streams are used to keep metrics, event lists, and incident feeds consistently up to date without requiring manual refreshes, though a `RefreshIndicator` is typically included as a fallback.

## UI/UX Design
The UI follows a consistent layout pattern across all roles but varies the content to fit the context:
- **Hero/Header Cards**: A personalized welcome message highlighting primary responsibilities (e.g., "Mabuhay, [Name]").
- **Quick Action Bars**: A row of actionable buttons to quickly navigate to frequently used features (e.g., "Create Event", "Approve Users", "Duty Monitor").
- **Metrics/Stats Bars**: A horizontally scrolling or grid-based widget showing key numbers (e.g., Active SOS, Service Hours).
- **Priority Panels**: A section detailing urgent items that require immediate attention (e.g., pending users for Admins, unstaffed events for Officers).
- **Charts & Visualization**: Implemented in `widgets/dashboard_charts.dart`, utilizing `fl_chart` to render line charts for user activity, pie charts for role distributions, and linear progress indicators for user statuses.

All screens employ an animated entrance (`_entranceCtrl`) and shimmer effects (`_shimmerCtrl`) while loading data to provide a polished, responsive user experience.

## Connections & Interactions
The `dashboard` feature acts as a cross-roads module, interacting heavily with many other core and data components:
- **Core & Shared**: Relies on `AppShell` for the scaffold layout, `RouteGuard` for role-based access control, and `AppTheme` / responsive utilities for styling.
- **Data Repositories**: Imports strongly from the `data/repositories` layer (users, events, incidents, qr_duty, audit logs) to aggregate data across the entire system.
- **Other Features**: Features are deeply interlinked via route navigation. The dashboards frequently push to `AppRoutes.events`, `AppRoutes.incidents`, `AppRoutes.profile`, and `AppRoutes.userManagement` based on user interactions with dashboard widgets.
