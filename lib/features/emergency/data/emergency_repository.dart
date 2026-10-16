import 'models/incident_draft.dart';

abstract interface class EmergencyRepository {
  List<IncidentDraft> get localIncidentDrafts;
  void saveLocalIncidentDraft(IncidentDraft draft);
  void deleteLocalIncidentDraft(String id);
}

/// Holds fictional incident preview text in memory for this app session only.
class PreviewEmergencyRepository implements EmergencyRepository {
  final List<IncidentDraft> _localIncidentDrafts = [];

  @override
  List<IncidentDraft> get localIncidentDrafts =>
      List.unmodifiable(_localIncidentDrafts);

  @override
  void saveLocalIncidentDraft(IncidentDraft draft) {
    if (!draft.id.startsWith('local-')) return;
    _localIncidentDrafts.insert(0, draft);
  }

  @override
  void deleteLocalIncidentDraft(String id) {
    if (!id.startsWith('local-')) return;
    _localIncidentDrafts.removeWhere((draft) => draft.id == id);
  }
}
