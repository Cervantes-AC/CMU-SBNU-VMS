import 'package:flutter/foundation.dart';

import '../../data/models/volunteer_preview.dart';
import '../../data/volunteers_repository.dart';

class VolunteersViewModel extends ChangeNotifier {
  VolunteersViewModel(this._repository);

  final VolunteersRepository _repository;
  String _query = '';
  String _college = 'All colleges';

  String get query => _query;
  String get college => _college;
  List<VolunteerPreview> get volunteers => _repository.volunteers;
  List<OrganizationPreview> get organizations => _repository.organizations;
  List<String> get colleges =>
      volunteers.map((person) => person.college).toSet().toList()..sort();

  List<VolunteerPreview> get filteredVolunteers {
    final query = _query.trim().toLowerCase();
    return volunteers.where((person) {
      final matchesQuery =
          query.isEmpty ||
          '${person.name} ${person.college}'.toLowerCase().contains(query);
      final matchesCollege =
          _college == 'All colleges' || person.college == _college;
      return matchesQuery && matchesCollege;
    }).toList();
  }

  void setQuery(String value) {
    if (_query == value) return;
    _query = value;
    notifyListeners();
  }

  void setCollege(String value) {
    if (_college == value) return;
    _college = value;
    notifyListeners();
  }
}
