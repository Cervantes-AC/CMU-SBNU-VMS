# Executive Summary

The CMU-SBNU Volunteer Management System (NSRC VMS) is a comprehensive, cross-platform application built with Flutter and Firebase for Central Mindanao University's School-based NSRC Unit. The system digitizes and streamlines volunteer operations including event management, attendance tracking, incident reporting with emergency SOS capabilities, duty monitoring via QR codes, report generation, analytics dashboards, and full administrative control over user accounts and organizational data.

The application serves four distinct user roles — Admin, Officer, Member, and Organization — each with tailored dashboards, feature access, and permission levels. Security is enforced at every layer: Firebase Authentication with optional Multi-Factor Authentication, Cloud Firestore security rules with role-based access control, client-side input sanitization, rate limiting, and a comprehensive immutable audit trail.

Key differentiators include an offline-first architecture using Hive for local caching with automatic background synchronization, an SOS emergency system with repeated FCM broadcasts and alarm audio, QR code-based duty tracking, and a glassmorphism design system with three selectable themes.
