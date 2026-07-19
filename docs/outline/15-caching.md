# Caching & Offline-First Strategy

## CacheService

The CacheService (`lib/core/cache/cache_service.dart`) provides TTL-based caching using Hive for complex objects and SharedPreferences for simple key-value pairs. It supports collection-level and document-level caching with automatic invalidation.

## SyncService

The SyncService (`lib/core/sync/sync_service.dart`) runs a background loop every 10 minutes, fetching the latest data from Firestore and updating the local cache. It tracks per-collection sync timestamps, reports errors, and respects network connectivity status.

## Repository Layer

Each of the 7 repositories (Event, Incident, User, Attendance, Announcement, AuditLog, QrDuty) implements a cache-first read strategy: check local cache → serve if fresh → fetch from Firestore if stale → update cache. Writes go to Firestore first, then update cache.
