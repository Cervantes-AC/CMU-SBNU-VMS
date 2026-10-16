import 'package:flutter/foundation.dart';

import '../../data/audit_preview_repository.dart';
import '../../data/models/audit_event_preview.dart';

class AuditPreviewViewModel extends ChangeNotifier {
  AuditPreviewViewModel(this._repository);

  final AuditPreviewRepository _repository;

  List<AuditEventPreview> get events => _repository.events;
}
