import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/types/app_types.dart';
import '../../data/organizations_repository.dart';
import '../../data/models/organization.dart';

class OrganizationsViewModel extends ChangeNotifier {
  OrganizationsViewModel({required this.repository});

  final OrganizationsRepository repository;

  LoadStatus _status = LoadStatus.initial;
  AppFailure? _error;
  List<Organization> _organizations = [];
  Organization? _selected;

  LoadStatus get status => _status;
  AppFailure? get error => _error;
  List<Organization> get organizations => _organizations;
  Organization? get selected => _selected;
  bool get isLoading => _status == LoadStatus.loading;

  void init() {
    _status = LoadStatus.loading;
    notifyListeners();

    repository.organizations.listen((orgs) {
      _organizations = orgs;
      _status = LoadStatus.loaded;
      _error = null;
      notifyListeners();
    }, onError: (e) {
      _status = LoadStatus.error;
      _error = e is AppFailure ? e : UnknownFailure();
      notifyListeners();
    });
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void select(Organization org) {
    _selected = org;
    notifyListeners();
  }

  Future<void> createOrganization(Organization org) async {
    _status = LoadStatus.loading;
    _error = null;
    notifyListeners();

    final result = await repository.createOrganization(org);
    if (result.hasData) {
      _organizations.add(result.data!);
      _status = LoadStatus.loaded;
    } else {
      _status = LoadStatus.error;
      _error = result.error;
    }
    notifyListeners();
  }
}

OrganizationsViewModel createOrganizationsViewModel(OrganizationsRepository repository) {
  return OrganizationsViewModel(repository: repository);
}

OrganizationsViewModel organizationsViewModelOf(BuildContext context) {
  return Provider.of<OrganizationsViewModel>(context, listen: false);
}
