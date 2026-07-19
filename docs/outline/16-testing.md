# Testing Strategy

## Mock Data & Seeding

The `seed/` directory contains scripts for populating the Firestore database with test data:

- **seed.js** — Firebase Admin SDK script with mock user data from `mock-users.json`
- **seed-rest.js** — REST API alternative for environments without Admin SDK access
- **seed-cli.js** — Interactive CLI tool for selective data seeding
