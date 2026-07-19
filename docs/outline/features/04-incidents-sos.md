# Incident Reporting & SOS Emergency System

The incident system supports both standard incident reports and emergency SOS alerts. All reports include optional GPS location capture and media attachments.

## Standard Incidents

- Report creation with type, narrative, severity, and optional media attachments
- GPS location capture via geolocator for precise incident positioning
- Status workflow: Submitted → Under Review → Responded → Resolved
- Tactical map view using flutter_map with OpenStreetMap tiles
- Filterable incident list by status, type, and date range

## SOS Emergency

- One-tap SOS button triggers immediate emergency alert
- Repeated FCM broadcast rounds (3 rounds with 5-second delays)
- Audio alarm playback with vibration patterns
- Global SOS banner overlay visible across the application
- Cloud Function `broadcastIncidentAlerts` sends push notifications to all users (excluding reporter)
