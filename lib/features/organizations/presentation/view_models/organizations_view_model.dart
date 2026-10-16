import 'package:flutter/foundation.dart';

import '../../data/models/organization_preview.dart';
import '../../data/organizations_repository.dart';

class OrganizationsViewModel extends ChangeNotifier {
  OrganizationsViewModel(this._repository);

  final OrganizationsRepository _repository;

  List<OrganizationPreview> get organizations => _repository.organizations;
}
