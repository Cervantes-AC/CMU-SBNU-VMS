# Analytics Feature Documentation

## Overview
The `analytics` feature provides a Firebase Realtime Analytics dashboard designed for administrative strategic monitoring and control. It displays live data visualizations of volunteers, events, incidents, and attendance. Because it relies on Firestore streams, the dashboard automatically and instantly updates whenever the underlying data changes, providing a live operational picture.

## Features
- **Real-time Data Streams:** Connects directly to Firestore streams to keep all metrics and charts updated in real-time.
- **Key Performance Indicators (KPIs):** Displays high-level stats at a glance (Total Volunteers, Events, Incidents, and Service Hours).
- **Interactive Charts:** Uses the `fl_chart` package to render a variety of charts:
  - Line charts for trend analysis (e.g., Incident Trends over 7/30 days).
  - Pie charts for distributions (Event Status, Volunteer Competencies).
  - Bar charts for categorical data (Service Hours Distribution, Incident Categories, Attendance Performance).
  - Radar charts for overall performance metrics.
- **Role-based Access:** Protected by a `RouteGuard` requiring `UserRole.admin` and `Feature.analytics` permissions.

## Functions & Architecture

### State Management & Lifecycle
- **`AnalyticsScreen` (`analytics_screen.dart`):** The primary view, structured as a `StatefulWidget`. It initializes and manages several `StreamSubscription` objects for the different data types.
  - **`_setupRealtimeAnalytics()`:** Called in `initState`, this method attaches listeners to the repository streams.
  - **`_sync()`:** A helper method that safely calls `setState()` when new data arrives, toggling off the `_isLoading` flag once all required data (users, events, incidents, attendance) is initially fetched.
  - **`_setStreamError()`:** Updates the state to display a fallback error banner if any stream drops or fails.
  - **Disposal:** All stream subscriptions and the staggered entrance `AnimationController` are carefully cleaned up in the `dispose()` method.

### Key Classes & Widgets
- **`AnalyticsKpiBar` (`widgets/analytics_kpi_bar.dart`):** Renders a row of 4 gradient-styled cards showing the most critical numerical statistics.
- **`AnalyticsChartCard` (`widgets/analytics_chart_card.dart`):** A generic wrapper widget providing consistent card styling, a title, subtitle, an icon, and an optional legend.
- **`analytics_charts.dart`:** Contains all the individual `fl_chart` implementations:
  - `ServiceHoursBarChart`, `EventStatusPieChart`, `IncidentTypeChart`, `CompetencyPieChart`, `AttendanceBarChart`, `IncidentTrendChart`, `PerformanceRadarChart`.
  - These are implemented as `StatelessWidget`s (except for `CompetencyPieChart`, which is stateful to handle touch interactions) that take domain models as input and map them to chart coordinates/sections.

## UI/UX
- **Loading & Error States:** Uses a `CircularProgressIndicator` while initial data loads. If data fetching fails, an `EmptyState` or `_LiveErrorBanner` is presented to the user.
- **Staggered Animations:** The page uses a `SingleTickerProviderStateMixin` and a staggered animation helper to gracefully fade and slide in the dashboard sections (Header -> KPIs -> Trend Chart -> Pie/Bar Charts -> Radar Chart) on load.
- **Responsive Layout:** Uses a `_TwoColumnGrid` widget which utilizes a `LayoutBuilder`. On wide screens (width > 600), it arranges charts in a two-column row format. On smaller screens, it falls back to a single column.
- **Live Status Indicator:** A small banner (`_FirebaseLiveStatus`) indicates the timestamp of the last successful stream sync, giving administrators confidence that the data is current.

## Connections
This module interacts heavily with other layers in the application:
- **Models (`lib/data/models/`):** Consumes `AppUser`, `Event`, `Incident`, and `Attendance` data structures.
- **Repositories (`lib/data/repositories/`):** Reads from `UserRepository`, `EventRepository`, `IncidentRepository`, and `AttendanceRepository` via `provider` (`context.read<T>()`) to obtain the realtime streams.
- **Core (`lib/core/`):** Relies on `AppColors` and utility functions from `ui_helpers.dart` (such as `staggered` and `kPagePaddingScaled`).
- **Shared (`lib/shared/`):** Wrapped in `AppShell` for the global scaffolding and `RouteGuard` for administrative access control.
