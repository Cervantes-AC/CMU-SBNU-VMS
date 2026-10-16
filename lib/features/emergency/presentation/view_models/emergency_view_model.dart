import 'package:flutter/foundation.dart';

import '../../data/emergency_repository.dart';
import '../../data/models/incident_draft.dart';
import '../../data/models/incident_preview_record.dart';

class EmergencyViewModel extends ChangeNotifier {
  EmergencyViewModel(this._repository);

  final EmergencyRepository _repository;

  List<IncidentDraft> get localIncidentDrafts =>
      _repository.localIncidentDrafts;
  List<IncidentPreviewRecord> get sampleIncidentRecords =>
      _repository.sampleIncidentRecords;

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

  void updateLocalIncidentDraft({
    required String id,
    required String category,
    required String description,
    required DateTime occurredAt,
  }) {
    final index = localIncidentDrafts.indexWhere((draft) => draft.id == id);
    if (index < 0) return;
    _repository.updateLocalIncidentDraft(
      localIncidentDrafts[index].copyWith(
        category: category,
        description: description.trim(),
        occurredAt: occurredAt,
      ),
    );
    notifyListeners();
  }
}
