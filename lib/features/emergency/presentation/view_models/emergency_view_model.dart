import 'package:flutter/foundation.dart';

import '../../data/emergency_repository.dart';
import '../../data/models/incident_draft.dart';

class EmergencyViewModel extends ChangeNotifier {
  EmergencyViewModel(this._repository);

  final EmergencyRepository _repository;

  List<IncidentDraft> get localIncidentDrafts =>
      _repository.localIncidentDrafts;

  void saveLocalIncidentDraft({
    required String category,
    required String description,
    required DateTime occurredAt,
  }) {
    _repository.saveLocalIncidentDraft(
      IncidentDraft(
        id: 'local-${DateTime.now().microsecondsSinceEpoch}',
        category: category,
        description: description.trim(),
        occurredAt: occurredAt,
      ),
    );
    notifyListeners();
  }

  void deleteLocalIncidentDraft(String id) {
    final exists = localIncidentDrafts.any((draft) => draft.id == id);
    if (!exists) return;
    _repository.deleteLocalIncidentDraft(id);
    notifyListeners();
  }
}
