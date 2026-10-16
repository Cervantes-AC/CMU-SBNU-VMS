import 'package:flutter/foundation.dart';

import '../../data/announcements_repository.dart';
import '../../data/models/announcement.dart';

class AnnouncementsViewModel extends ChangeNotifier {
  AnnouncementsViewModel(this._repository);

  final AnnouncementsRepository _repository;

  List<Announcement> get announcements => _repository.announcements;

  void saveDraft({
    String? id,
    required String title,
    required String message,
    required String audience,
  }) {
    if (id == null) {
      _repository.saveDraft(
        Announcement(
          id: 'local-${DateTime.now().microsecondsSinceEpoch}',
          title: title.trim(),
          message: message.trim(),
          audience: audience,
          dateLabel: 'Local preview',
          kind: AnnouncementKind.draft,
          isDraft: true,
        ),
      );
    } else {
      final index = announcements.indexWhere((item) => item.id == id);
      if (index < 0 || !announcements[index].isDraft) return;
      _repository.updateDraft(
        announcements[index].copyWith(
          title: title.trim(),
          message: message.trim(),
          audience: audience,
          dateLabel: 'Draft updated locally',
        ),
      );
    }
    notifyListeners();
  }

  void setDraftArchived(String id, bool archived) {
    final index = announcements.indexWhere((item) => item.id == id);
    if (index < 0 || !announcements[index].isDraft) return;
    _repository.setDraftArchived(id, archived);
    notifyListeners();
  }
}
