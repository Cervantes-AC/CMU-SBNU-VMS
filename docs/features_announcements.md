# Announcements Feature Documentation

## Overview
The `announcements` feature module provides a broadcasting system for the NSRC VMS application. It allows authorized users (Officers and above) to post, edit, and delete announcements, while all members can view, search, and filter the broadcast feed. 

## Features
- **Priority-Based Broadcasts**: Announcements are categorized into High, Medium, and Low priorities, with distinct visual cues.
- **Search & Filtering**: Real-time client-side filtering by text (title, content, author) and priority level.
- **Statistics**: A quick-glance statistics bar summarizing the total count of announcements and counts per priority level.
- **Access Control**: Role-based access control where members can view the feed, but only officers and higher can create, edit, or delete posts.
- **Audit Logging**: Creation, updates, and deletions of announcements are automatically logged for auditing purposes.
- **Notifications**: Creating a new announcement triggers a push notification to members.
- **Modal Support**: The feature can be accessed as a dedicated screen or via a full-screen modal dialog.

## Functions & Architecture

### State Management & Services
This module heavily relies on standard Provider-based dependency injection to access services:
- **`FirestoreService`**: Used to stream the list of announcements in real-time, save/update/delete announcements, and record audit logs.
- **`AuthService`**: Used to determine the current user's role (to conditionally render creation, edit, and delete controls) and to attach the user's ID/name to new posts.
- **`NotificationService`**: Used to dispatch notifications when a new announcement is posted.

### Key Components
- **`AnnouncementsScreen`** (`announcements_screen.dart`): The main screen for the feature, wrapped in a `RouteGuard` requiring at least `UserRole.member`. It coordinates the stream from Firestore, applies client-side filters, and renders the stats, filter bar, and list of cards.
- **`AnnouncementCard`** (`widgets/announcement_card.dart`): Displays a single announcement. Features an expandable/collapsible content area. For officers, it renders Edit and Delete action buttons. Deleting prompts a confirmation and logs to `AuditLog`.
- **`AnnouncementFilterBar`** (`widgets/announcement_filter_bar.dart`): Contains a text field for search and a horizontally scrollable list of filter chips for priority.
- **`AnnouncementFormSheet`** (`widgets/announcement_form_sheet.dart`): A bottom sheet form used for both creating and editing announcements. Validates input and communicates with `FirestoreService` and `NotificationService`.
- **`AnnouncementStatsBar`** (`widgets/announcement_stats_bar.dart`): A horizontal visual breakdown of current announcement counts.
- **`AnnouncementsDialog`** (`widgets/announcements_dialog.dart`): An alternative presentation of the announcements feed in a custom full-screen popup modal, duplicating the core UI layout of the main screen for quick access from other parts of the app.

## UI/UX
- **Visual Hierarchy**: High priority items use bold red accents (`kRed`) and stronger shadows to draw attention, while medium uses amber, and low uses muted colors.
- **Animations**: `AnimationController` and `Staggered` animations are used on the main screen to provide a smooth entrance effect. Cross-fading is used in `AnnouncementCard` for reading more/less content.
- **Loading & Empty States**: Implements skeleton loaders (`SkeletonList`) during initial data fetch and custom empty state graphics when no announcements match the filter criteria.
- **Glassmorphism**: Cards use a glassmorphism effect (e.g., `Glass.bg(cs)`) to blend with the app's modern theme.

## Connections
This module interacts tightly with several other parts of the application:
- **Core Data & Models**: Imports `Announcement`, `User`, and `AuditLog` models from `lib/data/models`.
- **Core Services**: Depends on `FirestoreService`, `AuthService`, and `NotificationService` from `lib/data/services`.
- **Shared UI/Layouts**: Utilizes `AppShell` for consistent page framing, `RouteGuard` for route-level access control, and helper widgets like `AppFeedback` for snackbars.
- **Theming**: Adheres to the global color palette (`AppColors`, `kGreen`, `kRed`, `kMuted`) and `Theme.of(context).colorScheme` for dark/light mode support.
