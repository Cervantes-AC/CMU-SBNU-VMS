# AI Accomplishment Reports

**Path:** `lib/features/ai_accomplishment_reports`

## 1. Features
This module provides an AI-powered accomplishment reports generator for the School-based NSRC Unit (SBNU). It is an officer-level feature designed to consolidate and summarize operational data into professional, structured reports. 
Key features include:
- **Report Types:** Generates three primary types of reports: Overall Summary, Event Attendance, and Incident Reports.
- **Advanced Filtering:** Extensive filtering capabilities by predefined or custom date ranges, incident status, event types, SOS alerts, search queries, and sorting preferences.
- **Multi-Source Data Aggregation:** Aggregates and analyzes data across events, incidents, attendance, QR duty records, users, and audit logs.
- **AI Enhancement:** Leverages the Groq API (`GroqService`) to enhance and polish template-generated plain-text reports into professional documentation.
- **Export Capabilities:** Supports in-app viewing with markdown rendering, copying to clipboard, downloading as PDF, and direct printing.
- **Model Selection:** Allows officers to quickly swap out the underlying Groq AI model for generation.

## 2. Functions & Architecture
The module follows a layered approach, separating UI from filtering state and report generation logic.
- **`AIAccomplishmentReportsScreen` (`ai_accomplishment_reports_screen.dart`):** The primary view. It fetches required data from multiple repositories concurrently, manages the `ReportFilterState`, and connects the UI components. It orchestrates the generation by first building a local template report and then dispatching it to Groq for enhancement.
- **State Management (`models/report_filter_state.dart`):** The `ReportFilterState` class is an immutable snapshot holding all active filter values (category, date range, tactical filters). It is designed cleanly without redundant fields, making it the single source of truth for querying data.
- **Report Generation (`utils/report_generator.dart`):** The core engine that compiles filtered data into a structured plain-text (Markdown-style) report. It handles domain-specific logic, such as calculating attendance rates, summarizing QR duty records, and outlining incident response performance.
- **Data Filtering & Utilities (`utils/report_data_filter.dart`, `utils/report_date_utils.dart`):** Pure utility functions to apply `ReportFilterState` criteria to raw lists of events and incidents and resolve human-readable date presets into concrete `DateTime` ranges.
- **PDF Export (`utils/report_pdf_exporter.dart`):** Utilizes `pdf` and `printing` packages to translate the generated markdown text into styled, printable PDF documents.

## 3. UI/UX
The interface is structured like an analytics dashboard within the standard `AppShell`. It focuses on progressive disclosure:
- **Filtering Steps:** The user interface is broken into modular widgets:
  - `ReportFocusSelector`: For selecting the report category (Overall, Attendance, Incidents).
  - `ReportTimeSelector`: For selecting date presets or custom ranges.
  - `ReportTacticalFilters`: Context-aware filters that adapt based on the selected report category (e.g., event picker for attendance, SOS toggles for incidents).
- **Live Feedback:** `ReportStatsBar` displays real-time counts (e.g., matching events, incidents, SOS alerts) based on the currently applied filters, providing immediate context before generation.
- **Generation & Feedback:** `ReportGenerateButton` visually indicates loading states. While loading, `ReportLoadingPanel` displays an animated progress indicator. 
- **Output Presentation:** `ReportOutputPanel` handles the final display. It renders the markdown content using a custom, lightweight markdown parser (`_MarkdownText`) and provides quick action buttons (Copy, PDF, Print, Clear).
- **AI Model Picker:** A small `_GroqModelChip` in the header opens a bottom sheet (`_ModelPickerSheet`) to let users intuitively switch AI models.
- **Animations:** The screen utilizes staggered entrance animations (`staggered` helper) for a polished, smooth loading experience.

## 4. Connections
The module is deeply integrated with the core and data layers of the application:
- **Data Repositories:** Reads heavily from `EventRepository`, `IncidentRepository`, `AttendanceRepository`, `UserRepository`, `QrDutyRepository`, and `AuditLogRepository` to gather the comprehensive data needed for the reports.
- **Domain Models:** Consumes `Event`, `Incident`, `Attendance`, `AppUser`, `QrDutyRecord`, and `AuditLog`.
- **Services:** Relies on `GroqService` and `GroqConfig` (via `Provider`) to execute the AI-enhancement step.
- **Security & Routing:** Wrapped in a `RouteGuard` that strictly requires `UserRole.officer` and `Feature.aiAccomplishmentReports` permissions to access.
- **Shared Components:** Uses `AppShell` for the scaffold and `AppFeedback` for toast notifications.
