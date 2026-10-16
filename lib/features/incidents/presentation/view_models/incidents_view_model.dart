import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/types/app_types.dart';
import '../../data/incidents_repository.dart';
import '../../data/models/incident.dart';

class IncidentsViewModel extends ChangeNotifier {
  IncidentsViewModel({required this.repository});

  final IncidentsRepository repository;

  LoadStatus _status = LoadStatus.initial;
  AppFailure? _error;
  List<Incident> _incidents = [];
  List<Incident> _myIncidents = [];
  Incident? _selected;

  LoadStatus get status => _status;
  AppFailure? get error => _error;
  List<Incident> get incidents => _incidents;
  List<Incident> get myIncidents => _myIncidents;
  Incident? get selected => _selected;
  bool get isLoading => _status == LoadStatus.loading;

  void init() {
    _status = LoadStatus.loading;
    notifyListeners();

    repository.incidents.listen(
      (incidents) {
        _incidents = incidents;
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

    repository.getMyIncidents('current_user').listen((myIncidents) {
      _myIncidents = myIncidents;
      notifyListeners();
    });
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void select(Incident incident) {
    _selected = incident;
    notifyListeners();
  }

  Future<void> submitIncident(Incident incident) async {
    _status = LoadStatus.loading;
    _error = null;
    notifyListeners();

    final result = await repository.submitIncident(incident);
    if (result.hasData) {
      _incidents.add(result.data!);
      _status = LoadStatus.loaded;
    } else {
      _status = LoadStatus.error;
      _error = result.error;
    }
    notifyListeners();
  }

  Future<void> updateStatus(
    String id, {
    required IncidentStatus newStatus,
    required String actorUid,
    String? note,
    String? actionType,
  }) async {
    final result = await repository.updateIncidentStatus(
      id,
      newStatus: newStatus,
      actorUid: actorUid,
      note: note,
      actionType: actionType,
    );
    if (result.hasData) {
      final idx = _incidents.indexWhere((i) => i.id == id);
      if (idx >= 0) {
        _incidents[idx] = result.data!;
      }
    } else {
      _error = result.error;
    }
    notifyListeners();
  }
}

IncidentsViewModel createIncidentsViewModel(IncidentsRepository repository) {
  return IncidentsViewModel(repository: repository);
}

IncidentsViewModel incidentsViewModelOf(BuildContext context) {
  return Provider.of<IncidentsViewModel>(context, listen: false);
}
