# QR Duty Monitoring

QR code-based time tracking for volunteer duty hours. Officers generate QR codes for events, and members scan them to log time-in and time-out.

- **QR Code Generation** — Officers generate unique QR tokens per event/session
- **QR Code Scanning** — Members use mobile_scanner to scan and log duty
- **Time-In/Time-Out** — Dual-mode scanning with automatic timestamping
- **Duty Records** — Firestore-backed records with user, event, type, timestamp, and location
- **Monitoring Dashboard** — Overview of all duty records with filtering and export
