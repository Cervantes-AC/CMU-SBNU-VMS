import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/types/app_types.dart';
import '../../data/sos_repository.dart';
import '../../data/models/sos_alert.dart';

class SosViewModel extends ChangeNotifier {
  SosViewModel({required this.repository});

  final SosRepository repository;

  LoadStatus _status = LoadStatus.initial;
  AppFailure? _error;
  List<SosAlert> _alerts = [];
  List<SosAlert> _myAlerts = [];
  SosAlert? _selected;
  bool _isSubmitting = false;

  LoadStatus get status => _status;
  AppFailure? get error => _error;
  List<SosAlert> get alerts => _alerts;
  List<SosAlert> get myAlerts => _myAlerts;
  SosAlert? get selected => _selected;
  bool get isLoading => _status == LoadStatus.loading;
  bool get isSubmitting => _isSubmitting;

  void init() {
    _status = LoadStatus.loading;
    notifyListeners();

    repository.alerts.listen((alerts) {
      _alerts = alerts;
      _status = LoadStatus.loaded;
      _error = null;
      notifyListeners();
    }, onError: (e) {
      _status = LoadStatus.error;
      _error = e is AppFailure ? e : UnknownFailure();
      notifyListeners();
    });

    repository.getMyAlerts('current_user').listen((myAlerts) {
      _myAlerts = myAlerts;
      notifyListeners();
    });
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void select(SosAlert alert) {
    _selected = alert;
    notifyListeners();
  }

  Future<bool> submitAlert(SosAlert alert) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    final result = await repository.createAlert(alert);
    _isSubmitting = false;
    if (result.hasData) {
      _alerts.add(result.data!);
      _myAlerts.add(result.data!);
      notifyListeners();
      return true;
    } else {
      _error = result.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateAlertStatus(String id, {
    required SosLifecycleStatus lifecycleStatus,
    SosDeliveryState? deliveryState,
    String? assignedHandlerUid,
    String? actorUid,
  }) async {
    final result = await repository.updateAlertStatus(
      id,
      lifecycleStatus: lifecycleStatus,
      deliveryState: deliveryState,
      assignedHandlerUid: assignedHandlerUid,
      actorUid: actorUid,
    );
    if (result.hasData) {
      final idx = _alerts.indexWhere((a) => a.id == id);
      if (idx >= 0) {
        _alerts[idx] = result.data!;
      }
      final midx = _myAlerts.indexWhere((a) => a.id == id);
      if (midx >= 0) {
        _myAlerts[midx] = result.data!;
      }
    } else {
      _error = result.error;
    }
    notifyListeners();
  }
}

SosViewModel createSosViewModel(SosRepository repository) {
  return SosViewModel(repository: repository);
}

SosViewModel sosViewModelOf(BuildContext context) {
  return Provider.of<SosViewModel>(context, listen: false);
}
