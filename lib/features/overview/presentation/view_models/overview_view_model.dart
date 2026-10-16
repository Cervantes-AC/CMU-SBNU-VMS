import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../data/overview_repository.dart';

/// Overview ViewModel - assembles dashboard state from feature APIs.
class OverviewViewModel extends ChangeNotifier {
  OverviewViewModel({required this.repository});

  final OverviewRepository repository;
}

OverviewViewModel createOverviewViewModel(OverviewRepository repository) {
  return OverviewViewModel(repository: repository);
}

OverviewViewModel overviewViewModelOf(BuildContext context) {
  return Provider.of<OverviewViewModel>(context, listen: false);
}
