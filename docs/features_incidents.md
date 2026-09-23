# Incidents Feature Documentation

## Overview
The `incidents` feature in `lib/features/incidents` is responsible for handling emergency incident reporting, SOS alerting, tracking, and management within the NSRC VMS application. It provides a comprehensive interface for users to report emergencies and for officers/admins to review, track on a tactical map, and respond to incidents in real-time.

## Features
- **Reporting Incidents**: Users can file detailed incident reports with categories, severity, required assistance, narrative, optional photos, and automatically captured GPS coordinates.
- **SOS Emergency Alerting**: Dedicated, one-tap (with confirmation) SOS capabilities that mark incidents as critical and trigger immediate notifications to officers/admins with the user's location.
- **List and Tactical Map Views**: Users and officers can toggle between a standard chronological list view and a tactical map view that clusters incidents geographically.
- **Advanced Filtering and Search**: Users can narrow down incidents by type, status, severity, assistance type, date ranges, or text query.
- **Admin/Officer Controls**: Officers can change the status of incidents (Review, Respond, Resolve) and manage reports efficiently.
- **Real-Time Data**: Seamlessly integrates with Firebase Firestore streams to reflect updates instantly.

## Architecture & Functions

### State Management
- **Provider**: Consumes core services using `context.read()` and `context.watch()`. Services used include `AuthService` (for roles and user data), `FirestoreService` (for streaming and mutating incident records/audit logs), and `LocationService` (for GPS tagging).
- **Local State**: UI components manage local presentation states (e.g., search text, expanded cards, toggle modes) via standard `StatefulWidget` and `setState`. Animations for pulsing SOS buttons and markers use `AnimationController`.

### Key Components
- **`incidents_screen.dart`**: The main entry point. Sets up the stream for `incidentsVisibleTo`, computes statistics, handles the toggle between Map and List modes, and manages the search/filter state. Uses `AppShell` and `RouteGuard`.
- **`constants/incident_helpers.dart`**: Contains brand palette color definitions, helper functions for formatting dates and times, and mapping functions to retrieve corresponding colors, labels, and icons based on incident type, severity, and status.

### Subdirectories & UI/UX

#### `dialogs/`
- **`report_bottom_sheet.dart`**: A sliding bottom sheet form used for creating or editing incidents. Handles form validation, interacts with `ImagePicker` for photos, uploads media to Cloudinary (`CloudinaryService`), fetches device GPS (`LocationService`), and saves the final `Incident` model.

#### `widgets/`
- **`incident_header.dart`**: Editorial header containing the title, description, and `IncidentStatsBar` (Active, Emergencies, Last 24 Hours, and Resolved percentages).
- **`incident_list.dart` & `incident_card.dart`**: Renders a vertical, scrollable list of `IncidentCard` widgets. The card dynamically adjusts its borders, shadows, and content based on its `isSOS` flag and expanded state. Supports officer actions.
- **`incident_search_filters.dart`**: An expandable panel with rich filtering options including search fields, dropdowns for Status/Type/Severity/Assistance, date pickers, and sorting toggles.
- **`tactical_map_view.dart`**: A robust map implementation using `flutter_map` and `latlong2`. Plots active incidents, clusters multiple nearby markers, and renders pulsing custom SOS markers. Uses CARTO dark tiles.
- **`incident_detail_overlay.dart`**: A visually rich, floating modal overlay providing deep details into an incident—displaying the full narrative, responder information, a photo grid, GPS map launcher, and status action buttons.
- **`incident_sos_card.dart` & `sos_button.dart`**: Provide SOS triggering UI. The `SOSCard` offers a large, animated, categorized grid (Medical, Fire, Safety, Other) along with hotlines. It confirms with the user before dispatching the critical alert.
- **`view_mode_toggle.dart`**: A segmented control button that allows officers to switch between List and Map views.

## Connections & Interactivity
- **Models**: Depends heavily on `Incident`, `AuditLog`, and `User` models defined in `lib/data/models/`.
- **Services**: Relies on `lib/data/services/` for data persistence (`FirestoreService`), authentication (`AuthService`), geographical mapping (`LocationService`), media processing (`CloudinaryService`), and alerts (`NotificationService`).
- **Shared UI**: Integrates with standard app structures using `RouteGuard` for permission checks, `AppShell` for the scaffold, and `AppFeedback` for toasts and snackbars.
