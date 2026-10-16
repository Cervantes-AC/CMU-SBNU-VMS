import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/types/app_types.dart';
import '../../data/announcements_repository.dart';
import '../../data/models/announcement.dart';

class AnnouncementsViewModel extends ChangeNotifier {
  AnnouncementsViewModel({required this.repository});

  final AnnouncementsRepository repository;

  LoadStatus _status = LoadStatus.initial;
  AppFailure? _error;
  List<Announcement> _announcements = [];
  List<Announcement> _published = [];

  LoadStatus get status => _status;
  AppFailure? get error => _error;
  List<Announcement> get announcements => _announcements;
  List<Announcement> get published => _published;
  bool get isLoading => _status == LoadStatus.loading;

  void init() {
    _status = LoadStatus.loading;
    notifyListeners();

    repository.announcements.listen((anns) {
      _announcements = anns;
      _published = anns.where((a) => a.isPublished && !a.isExpired).toList();
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

  Future<void> createAnnouncement(Announcement announcement) async {
    _status = LoadStatus.loading;
    _error = null;
    notifyListeners();

    final result = await repository.createAnnouncement(announcement);
    if (result.hasData) {
      _announcements.add(result.data!);
      if (result.data!.isPublished) _published.add(result.data!);
      _status = LoadStatus.loaded;
    } else {
      _status = LoadStatus.error;
      _error = result.error;
    }
    notifyListeners();
  }

  Future<void> archiveAnnouncement(String id) async {
    final result = await repository.archiveAnnouncement(id);
    if (result.success) {
      _announcements.removeWhere((a) => a.id == id);
      _published.removeWhere((a) => a.id == id);
    } else {
      _error = result.error;
    }
    notifyListeners();
  }
}

AnnouncementsViewModel createAnnouncementsViewModel(AnnouncementsRepository repository) {
  return AnnouncementsViewModel(repository: repository);
}

AnnouncementsViewModel announcementsViewModelOf(BuildContext context) {
  return Provider.of<AnnouncementsViewModel>(context, listen: false);
}
