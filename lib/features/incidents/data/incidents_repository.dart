import 'models/incident_draft.dart';
import 'models/incident_preview_record.dart';

abstract interface class IncidentsRepository {
  List<IncidentDraft> get localIncidentDrafts;
  List<IncidentPreviewRecord> get sampleIncidentRecords;
  void saveLocalIncidentDraft(IncidentDraft draft);
  void updateLocalIncidentDraft(IncidentDraft draft);
  void deleteLocalIncidentDraft(String id);
}

/// Holds fictional incident preview text in memory for this app session only.
class PreviewIncidentsRepository implements IncidentsRepository {
  static const _sampleIncidentRecords = [
    IncidentPreviewRecord(
      id: 'sample-incident-001',
      category: 'Facility or environment',
      severity: IncidentPreviewSeverity.low,
      status: IncidentPreviewStatus.underReview,
    ),
    IncidentPreviewRecord(
      id: 'sample-incident-002',
      category: 'Safety concern',
      severity: IncidentPreviewSeverity.medium,
      status: IncidentPreviewStatus.actionInProgress,
    ),
    IncidentPreviewRecord(
      id: 'sample-incident-003',
      category: 'Transport',
      severity: IncidentPreviewSeverity.low,
      status: IncidentPreviewStatus.resolved,
    ),
  ];

  final List<IncidentDraft> _localIncidentDrafts = [];

  @override
  List<IncidentDraft> get localIncidentDrafts =>
      List.unmodifiable(_localIncidentDrafts);

  @override
  List<IncidentPreviewRecord> get sampleIncidentRecords =>
      _sampleIncidentRecords;

  @override
  void saveLocalIncidentDraft(IncidentDraft draft) {
    if (!draft.id.startsWith('local-')) return;
    _localIncidentDrafts.insert(0, draft);
  }

  @override
  void updateLocalIncidentDraft(IncidentDraft draft) {
    if (!draft.id.startsWith('local-')) return;
    final index = _localIncidentDrafts.indexWhere(
      (item) => item.id == draft.id,
    );
    if (index < 0) return;
    _localIncidentDrafts[index] = draft;
  }

  @override
  void deleteLocalIncidentDraft(String id) {
    if (!id.startsWith('local-')) return;
    _localIncidentDrafts.removeWhere((draft) => draft.id == id);
  }
}
