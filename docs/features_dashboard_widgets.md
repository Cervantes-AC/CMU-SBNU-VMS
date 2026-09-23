# Comprehensive Documentation for `widgets`

**Path:** `lib/features/dashboard/widgets/`

## Files

### 📄 `dashboard_charts.dart`
**Key Imports:**
- `import 'package:fl_chart/fl_chart.dart';`
- `import '../../../data/models/audit_log.dart';`
- `import '../../../data/models/user.dart';`

**Defined Types & Details:**

#### `UserActivityChart` extends StatelessWidget
- **Fields / Properties:**
  - `users`
  - `logs`
  - `dailyCounts`
  - `key`
- **Methods:**
  - `UserActivityChart()`
  - `build()`

#### `RoleDistributionChart` extends StatelessWidget
- **Fields / Properties:**
  - `users`
  - `roleCounts`
  - `count`
- **Methods:**
  - `RoleDistributionChart()`
  - `build()`

#### `StatusDistributionChart` extends StatelessWidget
- **Fields / Properties:**
  - `users`
  - `statusCounts`
  - `count`
  - `pct`
- **Methods:**
  - `StatusDistributionChart()`
  - `build()`

---

