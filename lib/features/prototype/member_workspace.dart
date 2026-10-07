import 'package:flutter/material.dart';

/// Interactive, frontend-only member workspace prototype.
///
/// All content is synthetic and every interaction is local to this screen.
/// This is not an authenticated or production application shell.
class MemberWorkspace extends StatefulWidget {
  const MemberWorkspace({super.key});

  @override
  State<MemberWorkspace> createState() => _MemberWorkspaceState();
}

class _MemberWorkspaceState extends State<MemberWorkspace> {
  int _selectedIndex = 0;
  String _eventFilter = 'All';
  String _eventQuery = '';
  final Set<String> _joinedEvents = {'Community First Aid Orientation'};
  final TextEditingController _searchController = TextEditingController();

  static const _green = Color(0xFF245B4B);
  static const _ink = Color(0xFF1C2B2A);
  static const _muted = Color(0xFF65736D);
  static const _line = Color(0xFFE4EAE4);
  static const _canvas = Color(0xFFF5F7F3);

  static const _destinations = [
    _Destination(
      'Overview',
      Icons.space_dashboard_outlined,
      Icons.space_dashboard_rounded,
    ),
    _Destination('Events', Icons.event_outlined, Icons.event_rounded),
    _Destination(
      'My attendance',
      Icons.fact_check_outlined,
      Icons.fact_check_rounded,
    ),
    _Destination(
      'Announcements',
      Icons.campaign_outlined,
      Icons.campaign_rounded,
    ),
    _Destination(
      'My profile',
      Icons.person_outline_rounded,
      Icons.person_rounded,
    ),
  ];

  static const _events = [
    _DemoEvent(
      title: 'Community First Aid Orientation',
      date: 'Oct 18, 2026',
      time: '8:00 AM – 12:00 PM',
      place: 'CMU Sports Complex',
      category: 'Training',
      color: Color(0xFFE6F1E9),
      icon: Icons.health_and_safety_outlined,
    ),
    _DemoEvent(
      title: 'Campus Clean-up Drive',
      date: 'Oct 24, 2026',
      time: '6:30 AM – 10:00 AM',
      place: 'University Oval',
      category: 'Community',
      color: Color(0xFFF1EBDD),
      icon: Icons.volunteer_activism_outlined,
    ),
    _DemoEvent(
      title: 'Emergency Preparedness Workshop',
      date: 'Nov 02, 2026',
      time: '1:00 PM – 4:00 PM',
      place: 'College of Human Ecology',
      category: 'Training',
      color: Color(0xFFE9E9F5),
      icon: Icons.shield_outlined,
    ),
    _DemoEvent(
      title: 'Blood Donation Support',
      date: 'Nov 08, 2026',
      time: '7:00 AM – 1:00 PM',
      place: 'University Convention Center',
      category: 'Community',
      color: Color(0xFFF6E7E5),
      icon: Icons.favorite_border_rounded,
    ),
  ];

  static const _announcements = [
    _DemoAnnouncement(
      label: 'UNIT UPDATE',
      title: 'Volunteer orientation schedule is now available',
      body:
          'Review the upcoming orientation dates and bring your university ID.',
      date: 'October 10, 2026',
      icon: Icons.campaign_rounded,
      color: Color(0xFFE6F1E9),
    ),
    _DemoAnnouncement(
      label: 'REMINDER',
      title: 'Update your availability for October activities',
      body:
          'Keeping your availability current helps officers plan event assignments.',
      date: 'October 08, 2026',
      icon: Icons.event_available_rounded,
      color: Color(0xFFF1EBDD),
    ),
    _DemoAnnouncement(
      label: 'INFORMATION',
      title: 'Member help desk hours',
      body:
          'The unit help desk is available on weekdays during regular campus hours.',
      date: 'October 05, 2026',
      icon: Icons.info_outline_rounded,
      color: Color(0xFFE9E9F5),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDemoMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          width: 440,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 940;
    final content = _buildPage();

    return Scaffold(
      backgroundColor: _canvas,
      body: SafeArea(
        child: Row(
          children: [
            if (wide) _buildSidebar(),
            Expanded(
              child: Column(
                children: [
                  _buildTopBar(wide: wide),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1220),
                        child: content,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: wide ? null : _buildBottomNavigation(),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 246,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: _line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 18, 24),
            child: _brandLockup(compact: false),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 0, 16, 10),
            child: Text(
              'WORKSPACE',
              style: TextStyle(
                color: _muted,
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          for (var index = 0; index < _destinations.length; index++)
            _navigationItem(index),
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F6F1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.science_outlined, size: 18, color: _green),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Prototype mode\nSample information only',
                    style: TextStyle(
                      color: _ink,
                      height: 1.4,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar({required bool wide}) {
    return Container(
      height: 76,
      padding: EdgeInsets.symmetric(horizontal: wide ? 32 : 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _line)),
      ),
      child: Row(
        children: [
          if (!wide) ...[
            _brandLockup(compact: true),
            const Spacer(),
          ] else
            const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5DE),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 15,
                  color: Color(0xFF805C13),
                ),
                SizedBox(width: 6),
                Text(
                  'DEMO PREVIEW',
                  style: TextStyle(
                    color: Color(0xFF805C13),
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFE6F1E9),
            child: Text(
              'JD',
              style: TextStyle(color: _green, fontWeight: FontWeight.w800),
            ),
          ),
          if (wide) ...[
            const SizedBox(width: 10),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jordan Dela Cruz',
                  style: TextStyle(fontWeight: FontWeight.w700, color: _ink),
                ),
                Text(
                  'Member preview',
                  style: TextStyle(fontSize: 11, color: _muted),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _brandLockup({required bool compact}) {
    return Row(
      mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
      children: [
        _logo('assets/images/cmu_logo.png', 'CMU logo'),
        const SizedBox(width: 6),
        _logo('assets/images/SBNU LOGO.png', 'SBNU logo'),
        if (!compact) ...[
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Volunteer\nWorkspace',
              style: TextStyle(
                color: _ink,
                fontWeight: FontWeight.w800,
                height: 1.15,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _logo(String path, String label) => Container(
    width: 34,
    height: 34,
    padding: const EdgeInsets.all(2),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Image.asset(path, fit: BoxFit.contain, semanticLabel: label),
  );

  Widget _buildBottomNavigation() => NavigationBar(
    selectedIndex: _selectedIndex,
    onDestinationSelected: (index) => setState(() => _selectedIndex = index),
    destinations: [
      for (final destination in _destinations)
        NavigationDestination(
          icon: Icon(destination.icon),
          selectedIcon: Icon(destination.selectedIcon),
          label: destination.label == 'My attendance'
              ? 'Attendance'
              : destination.label == 'Announcements'
              ? 'Updates'
              : destination.label == 'My profile'
              ? 'Profile'
              : destination.label,
        ),
    ],
  );

  Widget _navigationItem(int index) {
    final destination = _destinations[index];
    final selected = index == _selectedIndex;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: ListTile(
        selected: selected,
        selectedTileColor: const Color(0xFFEAF2EC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          selected ? destination.selectedIcon : destination.icon,
          color: selected ? _green : _muted,
          size: 20,
        ),
        title: Text(
          destination.label,
          style: TextStyle(
            color: selected ? _green : _muted,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        onTap: () => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 1:
        return _eventsPage();
      case 2:
        return _attendancePage();
      case 3:
        return _announcementsPage();
      case 4:
        return _profilePage();
      default:
        return _dashboardPage();
    }
  }

  Widget _pageScroll(List<Widget> children) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(24, 26, 24, 36),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    ),
  );

  Widget _pageHeading(String eyebrow, String title, String subtitle) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        eyebrow.toUpperCase(),
        style: const TextStyle(
          color: _green,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          fontSize: 10,
        ),
      ),
      const SizedBox(height: 7),
      Text(
        title,
        style: const TextStyle(
          color: _ink,
          fontSize: 27,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.7,
        ),
      ),
      const SizedBox(height: 5),
      Text(subtitle, style: const TextStyle(color: _muted, height: 1.45)),
    ],
  );

  Widget _sectionHeading(String title, {String? action, VoidCallback? onTap}) =>
      Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: _ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (action != null)
            TextButton(
              onPressed: onTap,
              child: Text(action, style: const TextStyle(color: _green)),
            ),
        ],
      );

  Widget _dashboardPage() => _pageScroll([
    _pageHeading(
      'Sunday, October 11, 2026',
      'Good morning, Jordan',
      'Here’s your volunteer activity at a glance.',
    ),
    const SizedBox(height: 22),
    _welcomeCard(),
    const SizedBox(height: 24),
    _metricGrid(),
    const SizedBox(height: 28),
    _sectionHeading(
      'Your next event',
      action: 'Browse events',
      onTap: () => setState(() => _selectedIndex = 1),
    ),
    const SizedBox(height: 10),
    _eventCard(_events.first, showAction: true),
    const SizedBox(height: 24),
    _sectionHeading(
      'Latest updates',
      action: 'All updates',
      onTap: () => setState(() => _selectedIndex = 3),
    ),
    const SizedBox(height: 10),
    _announcementCard(_announcements.first),
    const SizedBox(height: 16),
    _announcementCard(_announcements[1]),
  ]);

  Widget _welcomeCard() => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: _green,
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
        colors: [Color(0xFF245B4B), Color(0xFF36725E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        final message = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'YOUR CONTRIBUTION MATTERS',
              style: TextStyle(
                color: Color(0xFFD6E9D9),
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 9),
            const Text(
              'Ready for what’s next?',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 21,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Explore upcoming activities and find a way to help.',
              style: TextStyle(color: Color(0xFFE2EEE5), height: 1.45),
            ),
            const SizedBox(height: 15),
            FilledButton.tonalIcon(
              onPressed: () => setState(() => _selectedIndex = 1),
              icon: const Icon(Icons.arrow_forward_rounded, size: 17),
              label: const Text('Explore events'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _green,
              ),
            ),
          ],
        );
        if (compact) return message;
        return Row(
          children: [
            Expanded(child: message),
            const SizedBox(width: 20),
            const Icon(
              Icons.volunteer_activism_outlined,
              size: 88,
              color: Color(0x70FFFFFF),
            ),
          ],
        );
      },
    ),
  );

  Widget _metricGrid() => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 820
          ? 4
          : constraints.maxWidth >= 510
          ? 2
          : 1;
      final gap = 12.0;
      final itemWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
      const items = [
        _Metric(
          'Events joined',
          '04',
          Icons.event_available_outlined,
          Color(0xFFE6F1E9),
          Color(0xFF245B4B),
        ),
        _Metric(
          'Service hours',
          '18.5',
          Icons.schedule_rounded,
          Color(0xFFE9E9F5),
          Color(0xFF4C4B7A),
        ),
        _Metric(
          'Upcoming',
          '02',
          Icons.upcoming_outlined,
          Color(0xFFF1EBDD),
          Color(0xFF805C13),
        ),
        _Metric(
          'Unit updates',
          '03',
          Icons.mark_email_unread_outlined,
          Color(0xFFF6E7E5),
          Color(0xFF9A5148),
        ),
      ];
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final item in items)
            SizedBox(
              width: itemWidth,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: _line),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: item.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, size: 20, color: item.color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.value,
                            style: const TextStyle(
                              color: _ink,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            item.label,
                            style: const TextStyle(color: _muted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    },
  );

  Widget _eventsPage() {
    final filtered = _events.where((event) {
      final matchesFilter =
          _eventFilter == 'All' || event.category == _eventFilter;
      final query = _eventQuery.toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          event.title.toLowerCase().contains(query) ||
          event.place.toLowerCase().contains(query);
      return matchesFilter && matchesQuery;
    }).toList();

    return _pageScroll([
      _pageHeading(
        'Get involved',
        'Upcoming events',
        'Explore activities and keep track of the ones you join.',
      ),
      const SizedBox(height: 20),
      TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _eventQuery = value),
        decoration: InputDecoration(
          hintText: 'Search events or locations',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _eventQuery.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _eventQuery = '');
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _line),
          ),
        ),
      ),
      const SizedBox(height: 12),
      Wrap(
        spacing: 8,
        children: [
          for (final filter in ['All', 'Training', 'Community'])
            ChoiceChip(
              label: Text(filter),
              selected: filter == _eventFilter,
              onSelected: (_) => setState(() => _eventFilter = filter),
              selectedColor: const Color(0xFFE3EEE6),
            ),
        ],
      ),
      const SizedBox(height: 10),
      Text(
        '${filtered.length} activities',
        style: const TextStyle(color: _muted, fontSize: 12),
      ),
      const SizedBox(height: 10),
      if (filtered.isEmpty)
        _emptyState(
          Icons.event_busy_outlined,
          'No events match your search',
          'Try another keyword or category.',
        )
      else
        for (final event in filtered) ...[
          _eventCard(event, showAction: true),
          const SizedBox(height: 12),
        ],
    ]);
  }

  Widget _eventCard(_DemoEvent event, {required bool showAction}) {
    final joined = _joinedEvents.contains(event.title);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(17),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;
          final details = Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _tag(event.category, event.color, _green),
                    if (joined) _tag('Joined', const Color(0xFFE6F1E9), _green),
                  ],
                ),
                const SizedBox(height: 9),
                Text(
                  event.title,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 9),
                _iconLine(
                  Icons.calendar_today_outlined,
                  '${event.date} · ${event.time}',
                ),
                const SizedBox(height: 5),
                _iconLine(Icons.location_on_outlined, event.place),
                if (compact && showAction) ...[
                  const SizedBox(height: 13),
                  _joinButton(event, joined, expanded: true),
                ],
              ],
            ),
          );
          final leading = Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: event.color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(event.icon, color: _green, size: 22),
          );
          if (compact) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [leading, const SizedBox(width: 13), details],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leading,
              const SizedBox(width: 14),
              details,
              if (showAction) ...[
                const SizedBox(width: 12),
                _joinButton(event, joined),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _joinButton(_DemoEvent event, bool joined, {bool expanded = false}) =>
      OutlinedButton(
        onPressed: () {
          setState(() {
            if (joined) {
              _joinedEvents.remove(event.title);
            } else {
              _joinedEvents.add(event.title);
            }
          });
          _showDemoMessage(
            joined
                ? 'Removed from your local preview list.'
                : 'Added to your local preview list. No request was sent.',
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: joined ? _muted : _green,
          side: const BorderSide(color: _line),
          minimumSize: Size(expanded ? double.infinity : 96, 40),
        ),
        child: Text(joined ? 'Joined' : 'Join'),
      );

  Widget _attendancePage() => _pageScroll([
    _pageHeading(
      'Your contribution',
      'My attendance',
      'A personal preview of event participation and service hours.',
    ),
    const SizedBox(height: 20),
    Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2EC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(Icons.schedule_rounded, color: _green, size: 25),
          SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '18.5 hours',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Sample service summary · October 2026',
                  style: TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    const SizedBox(height: 23),
    _sectionHeading('Recent activity'),
    const SizedBox(height: 8),
    for (final record in const [
      _AttendanceRecord('Campus Safety Walk', 'Oct 03, 2026', '4.0 hrs', true),
      _AttendanceRecord(
        'Volunteer Orientation',
        'Sep 19, 2026',
        '6.5 hrs',
        true,
      ),
      _AttendanceRecord(
        'Community Garden Day',
        'Sep 12, 2026',
        '5.0 hrs',
        true,
      ),
      _AttendanceRecord(
        'Unit Planning Session',
        'Sep 04, 2026',
        '3.0 hrs',
        false,
      ),
    ]) ...[_attendanceRecord(record), const SizedBox(height: 10)],
    const SizedBox(height: 10),
    const Text(
      'Attendance records shown here are illustrative. Service totals in the finished app must come from verified records.',
      style: TextStyle(color: _muted, fontSize: 12, height: 1.5),
    ),
  ]);

  Widget _attendanceRecord(_AttendanceRecord record) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: record.verified
                ? const Color(0xFFE6F1E9)
                : const Color(0xFFF1EBDD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            record.verified
                ? Icons.check_rounded
                : Icons.hourglass_empty_rounded,
            color: record.verified ? _green : const Color(0xFF805C13),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.title,
                style: const TextStyle(
                  color: _ink,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${record.date} · ${record.verified ? 'Verified' : 'Pending review'}',
                style: const TextStyle(color: _muted, fontSize: 11),
              ),
            ],
          ),
        ),
        Text(
          record.hours,
          style: const TextStyle(
            color: _ink,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );

  Widget _announcementsPage() => _pageScroll([
    _pageHeading(
      'Stay in the loop',
      'Announcements',
      'Updates and reminders for the unit, shown with sample content.',
    ),
    const SizedBox(height: 20),
    for (final announcement in _announcements) ...[
      _announcementCard(announcement, roomy: true),
      const SizedBox(height: 12),
    ],
  ]);

  Widget _announcementCard(_DemoAnnouncement item, {bool roomy = false}) =>
      Container(
        padding: EdgeInsets.all(roomy ? 19 : 15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _line),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(item.icon, color: _green, size: 21),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _tag(item.label, item.color, _green),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: _ink,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.body,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.date,
                    style: const TextStyle(color: _muted, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _profilePage() => _pageScroll([
    _pageHeading(
      'Your account',
      'My profile',
      'Profile details in this screen are fictional sample content.',
    ),
    const SizedBox(height: 20),
    Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xFFE6F1E9),
            child: Text(
              'JD',
              style: TextStyle(
                color: _green,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Jordan Dela Cruz',
            style: TextStyle(
              color: _ink,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Member · Synthetic profile',
            style: TextStyle(color: _muted, fontSize: 12),
          ),
          const SizedBox(height: 20),
          const Divider(color: _line),
          _profileField(
            Icons.alternate_email_rounded,
            'Email',
            'jordan.delacruz@example.test',
          ),
          _profileField(
            Icons.school_outlined,
            'College',
            'College of Human Ecology',
          ),
          _profileField(Icons.badge_outlined, 'Member ID', 'DEMO-0248'),
          _profileField(
            Icons.verified_user_outlined,
            'Account status',
            'Preview only · not authenticated',
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () => _showDemoMessage(
                'Profile editing is not connected in this frontend prototype.',
              ),
              icon: const Icon(Icons.edit_outlined, size: 17),
              label: const Text('Edit profile'),
            ),
          ),
        ],
      ),
    ),
  ]);

  Widget _profileField(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 11),
    child: Row(
      children: [
        Icon(icon, size: 18, color: _muted),
        const SizedBox(width: 12),
        SizedBox(
          width: 108,
          child: Text(
            label,
            style: const TextStyle(color: _muted, fontSize: 12),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: _ink,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _tag(String label, Color background, Color foreground) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: foreground,
        fontSize: 9,
        fontWeight: FontWeight.w800,
      ),
    ),
  );

  Widget _iconLine(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 14, color: _muted),
      const SizedBox(width: 6),
      Expanded(
        child: Text(text, style: const TextStyle(color: _muted, fontSize: 11)),
      ),
    ],
  );

  Widget _emptyState(IconData icon, String title, String body) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Icon(icon, size: 30, color: _muted),
        const SizedBox(height: 9),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _ink,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          body,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _muted, fontSize: 12),
        ),
      ],
    ),
  );
}

class _Destination {
  const _Destination(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _Metric {
  const _Metric(this.label, this.value, this.icon, this.background, this.color);

  final String label;
  final String value;
  final IconData icon;
  final Color background;
  final Color color;
}

class _DemoEvent {
  const _DemoEvent({
    required this.title,
    required this.date,
    required this.time,
    required this.place,
    required this.category,
    required this.color,
    required this.icon,
  });

  final String title;
  final String date;
  final String time;
  final String place;
  final String category;
  final Color color;
  final IconData icon;
}

class _DemoAnnouncement {
  const _DemoAnnouncement({
    required this.label,
    required this.title,
    required this.body,
    required this.date,
    required this.icon,
    required this.color,
  });

  final String label;
  final String title;
  final String body;
  final String date;
  final IconData icon;
  final Color color;
}

class _AttendanceRecord {
  const _AttendanceRecord(this.title, this.date, this.hours, this.verified);

  final String title;
  final String date;
  final String hours;
  final bool verified;
}
