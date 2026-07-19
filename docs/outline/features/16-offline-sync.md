# Offline Support & Synchronization

The offline-first architecture ensures the application remains functional without network connectivity.

- **Hive Local Cache** — All collections cached locally with TTL-based invalidation
- **Firestore Persistence** — Unlimited cache size for Firestore offline reads
- **Auto-Sync** — Background synchronization every 10 minutes when connected
- **Connectivity Monitoring** — Real-time network status via connectivity_plus
- **Offline Banner** — Visual indicator when operating in offline mode
- **Conflict Resolution** — Timestamp-based conflict resolution during sync
- **Last Sync Tracking** — Per-collection sync timestamps and error reporting
