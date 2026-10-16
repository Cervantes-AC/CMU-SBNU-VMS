import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';


/// Overview repository - reads from feature APIs to assemble dashboard data.
class OverviewRepository {
  OverviewRepository();
}

/// Placeholder - overview reads directly from feature repositories.
OverviewRepository createOverviewRepository() {
  return OverviewRepository();
}

OverviewRepository overviewRepositoryOf(BuildContext context) {
  return Provider.of<OverviewRepository>(context, listen: false);
}
