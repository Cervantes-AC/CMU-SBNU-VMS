# Development Areas

The plans are split into numbered areas. These folder names describe intended ownership and do not require moving the existing Flutter project layout. Add files as approved work is implemented; do not create empty source folders to match the plan.

1. [Frontend](01-frontend.md)
2. [Backend](02-backend.md)
3. [Databases](03-databases.md)
4. [APIs](04-apis.md)
5. [Auth and Security](05-auth-and-security.md)
6. [Deployments and DevOps](06-deployments-and-devops.md)
7. [Testing](07-testing.md)
8. [Tools](08-tools.md)

## Shared starting point

- The current Flutter app is a starter screen; most features are not implemented.
- Firebase is declared but not initialized by the app. Firestore rules currently deny client access.
- Android is the first intended platform. Hosting and production deployment are not approved.
- `docs/nsrc_vms/` is reference material only; do not copy its credentials, data, or backend configuration.
- Use synthetic data and local development. Confirm product, privacy, and security decisions before dependent implementation.
