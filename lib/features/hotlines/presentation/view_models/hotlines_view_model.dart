import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/types/app_types.dart';
import '../../data/hotlines_repository.dart';
import '../../data/models/hotline_entry.dart';

class HotlinesViewModel extends ChangeNotifier {
  HotlinesViewModel({required this.repository});

  final HotlinesRepository repository;

  LoadStatus _status = LoadStatus.initial;
  AppFailure? _error;
  List<HotlineEntry> _hotlines = [];
  List<HotlineEntry> _verified = [];

  LoadStatus get status => _status;
  AppFailure? get error => _error;
  List<HotlineEntry> get hotlines => _hotlines;
  List<HotlineEntry> get verified => _verified;
  bool get isLoading => _status == LoadStatus.loading;

  void init() {
    _status = LoadStatus.loading;
    notifyListeners();

    repository.hotlines.listen(
      (hotlines) {
        _hotlines = hotlines;
        _verified = hotlines.where((h) => h.isVerified).toList();
        _status = LoadStatus.loaded;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _status = LoadStatus.error;
        _error = e is AppFailure ? e : UnknownFailure();
        notifyListeners();
      },
    );
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> verifyHotline(String id, String verifiedBy) async {
    final result = await repository.verifyHotline(id, verifiedBy);
    if (!result.success) {
      _error = result.error;
    }
    notifyListeners();
  }
}

HotlinesViewModel createHotlinesViewModel(HotlinesRepository repository) {
  return HotlinesViewModel(repository: repository);
}

HotlinesViewModel hotlinesViewModelOf(BuildContext context) {
  return Provider.of<HotlinesViewModel>(context, listen: false);
}
