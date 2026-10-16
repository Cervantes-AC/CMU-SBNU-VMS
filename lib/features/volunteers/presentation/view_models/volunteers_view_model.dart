import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/types/app_types.dart';
import '../../data/volunteers_repository.dart';
import '../../data/models/volunteer.dart';

class VolunteersViewModel extends ChangeNotifier {
  VolunteersViewModel({required this.repository});

  final VolunteersRepository repository;

  LoadStatus _status = LoadStatus.initial;
  AppFailure? _error;
  List<VolunteerProfile> _volunteers = [];
  VolunteerProfile? _selected;
  String _collegeFilter = 'All';

  LoadStatus get status => _status;
  AppFailure? get error => _error;
  List<VolunteerProfile> get volunteers => _volunteers;
  VolunteerProfile? get selected => _selected;
  String get collegeFilter => _collegeFilter;
  bool get isLoading => _status == LoadStatus.loading;

  List<VolunteerProfile> get filteredVolunteers {
    if (_collegeFilter == 'All') return _volunteers;
    return _volunteers.where((v) => v.college == _collegeFilter).toList();
  }

  void init() {
    _status = LoadStatus.loading;
    notifyListeners();

    repository.volunteers.listen(
      (vols) {
        _volunteers = vols;
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

  void select(VolunteerProfile profile) {
    _selected = profile;
    notifyListeners();
  }

  void setCollegeFilter(String college) {
    _collegeFilter = college;
    notifyListeners();
  }

  List<String> get colleges {
    return _volunteers
        .map((v) => v.college)
        .whereType<String>()
        .toSet()
        .toList()
      ..insert(0, 'All');
  }

  Future<void> createOrUpdateProfile(VolunteerProfile profile) async {
    _status = LoadStatus.loading;
    _error = null;
    notifyListeners();

    final result = await repository.createOrUpdateProfile(profile);
    if (result.hasData) {
      final idx = _volunteers.indexWhere((v) => v.uid == profile.uid);
      if (idx >= 0) {
        _volunteers[idx] = result.data!;
      } else {
        _volunteers.add(result.data!);
      }
      _status = LoadStatus.loaded;
    } else {
      _status = LoadStatus.error;
      _error = result.error;
    }
    notifyListeners();
  }
}

VolunteersViewModel createVolunteersViewModel(VolunteersRepository repository) {
  return VolunteersViewModel(repository: repository);
}

VolunteersViewModel volunteersViewModelOf(BuildContext context) {
  return Provider.of<VolunteersViewModel>(context, listen: false);
}
