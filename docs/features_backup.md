# Feature: Backup Management

This document details the architecture, UI/UX, and connections of the `backup` feature module located in `lib/features/backup`.

## Features
The Backup Management module provides an interface for administrators to manage system backups. It supports manual triggers for Database, Uploads, and Full System backups. It also provides a dashboard to view overall backup statistics and a real-time historical list of past backup operations with options to verify backup integrity or delete specific records.

## Functions & Architecture
- **`BackupManagementScreen`**: A `StatefulWidget` serving as the main view.
- **State Management**:
  - Leverages `provider` to access `BackupService` (`context.read<BackupService>()`).
  - Implements a listener on `BackupService` to call `setState` locally whenever the service state changes (e.g., when a backup is in progress or stats change).
  - Uses a `StreamBuilder` directly querying `FirebaseFirestore.instance.collection('backupRecords')` to fetch and render the recent backup history in real-time, sorting by `createdAt` descending.
- **Key Methods**:
  - `_createBackup`: Triggers `_service.createBackup` with the respective type and initiated user, then shows a notification based on success/failure.
  - `_verifyIntegrity`: Calls `_service.verifyBackupIntegrity` and shows a SnackBar with the result.
  - `_deleteBackup`: Prompts the user with a confirmation dialog, then calls `_service.deleteBackup` if confirmed, showing a SnackBar result.

## UI/UX
- **Access Control**: Wrapped in a `RouteGuard` requiring the `UserRole.admin` role and `Feature.backupManagement` feature access.
- **Layout**: Uses `AppShell` for the overall page layout with a `SingleChildScrollView`.
- **Animations**: Components are animated sequentially upon entry using a `staggered` animation helper.
- **Components**:
  - **Header**: `PageHeader` indicating the section purpose.
  - **StatsBar**: Displays total backups, completed, failed counts, and total size (fetched via `_service.loadStats()`).
  - **Quick Actions**: Three distinct buttons for specific backup types (Database, Uploads, Full System). Includes a `LinearProgressIndicator` when a backup is currently running (`_service.isRunning`).
  - **Backup History**: A list displaying individual backup records containing their type, status, size, duration, and date. Failed backups show inline error messages. Completed backups display a verify and delete button. Skeleton loading and empty states are elegantly handled.

## Connections
This feature relies heavily on various other parts of the application:
- **`core/utils`**: Relies on `ui_helpers.dart` for visual constants (`kGreen`, `kRed`, `kSectionGap`), scaled padding, and animation utilities.
- **`data/models`**: Uses `BackupRecord` and `User` models.
- **`data/services`**:
  - `AuthService`: Fetches the current user to append their name when initiating a backup.
  - `BackupService`: Core business logic for triggering and managing backups.
  - `CrudNotifications`: Reused for consistent success/error UI alerts.
- **`shared`**: Depends on global UI components like `AppShell`, `RouteGuard`, `PageHeader`, `StatsBar`, `FeatureBackdrop`, `SkeletonList`, and `EmptyState`.
