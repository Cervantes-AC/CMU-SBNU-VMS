import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/types/app_types.dart';
import '../../data/audit_repository.dart';
import '../../data/models/audit_event.dart';

class AuditViewModel extends ChangeNotifier {
  AuditViewModel({required this.repository});

  final AuditRepository repository;

  LoadStatus _status = LoadStatus.initial;
  AppFailure? _error;
  List<AuditEvent> _events = [];

  LoadStatus get status => _status;
  AppFailure? get error => _error;
  List<AuditEvent> get events => _events;
  bool get isLoading => _status == LoadStatus.loading;

  void init() {
    _status = LoadStatus.loading;
    notifyListeners();

    repository.events.listen(
      (events) {
        _events = events;
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

  Future<void> writeEvent({
    required String actorUid,
    required String action,
    required String recordType,
    required String recordId,
    required String outcome,
    Map<String, dynamic>? changedFields,
  }) async {
    final result = await repository.writeEvent(
      actorUid: actorUid,
      action: action,
      recordType: recordType,
      recordId: recordId,
      outcome: outcome,
      changedFields: changedFields,
    );
    if (!result.success) {
      _error = result.error;
    }
    notifyListeners();
  }
}

AuditViewModel createAuditViewModel(AuditRepository repository) {
  return AuditViewModel(repository: repository);
}

AuditViewModel auditViewModelOf(BuildContext context) {
  return Provider.of<AuditViewModel>(context, listen: false);
}
