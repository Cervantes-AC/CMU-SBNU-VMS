import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/performance/performance.dart';
import '../../../core/platform/device_info.dart';

/// Responsive sticky topbar.
///
/// On mobile the search field is hidden and the menu button opens the nav dialog.
/// On desktop/tablet the full search field and title are shown.
class AppTopbar extends StatefulWidget {
  const AppTopbar({
    super.key,
    required this.activeSection,
    required this.onMenu,
    required this.onSearch,
    required this.onNotifications,
  });

  final String activeSection;
  final VoidCallback onMenu;
  final ValueChanged<String> onSearch;
  final VoidCallback onNotifications;

  @override
  State<AppTopbar> createState() => _AppTopbarState;
}

class _AppTopbarState extends State<AppTopbar> {
  final _searchController = TextEditingController();
  bool _hasQuery = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final device = DeviceInfo.of(context);
    final height = device.isMobile ? 56 : 79;

    return Container(
      height: height,
      padding: responsivePadding(
        context,
        mobile: const EdgeInsets.symmetric(horizontal: 12),
        tablet: const EdgeInsets.symmetric(horizontal: 20),
        desktop: const EdgeInsets.symmetric(horizontal: 37),
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFBF8),
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E6E0), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Menu / drawer toggle.
          _MenuButton(onPressed: widget.onMenu),
          if (!device.isMobile) ...[
            const SizedBox(width: 12),
            _PageTitle(activeSection: widget.activeSection),
            const Spacer(),
            _SearchField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _hasQuery = value.isNotEmpty);
                widget.onSearch(value);
              },
              hasQuery: _hasQuery,
            ),
            const SizedBox(width: 13),
            _IconButton(
              tooltip: 'Notifications',
              icon: Icons.notifications_none,
              badge: true,
              onPressed: widget.onNotifications,
            ),
            const SizedBox(width: 3),
            _CMULockup(),
          ] else ...[
            // Mobile: title only (no spacer/lockup/search).
            Expanded(
              child: _PageTitle(activeSection: widget.activeSection),
            ),
          ],
        ],
      );
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final device = DeviceInfo.of(context);
    return SizedBox(
      width: device.isMobile ? 40 : 34,
      height: device.isMobile ? 40 : 34,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          Icons.menu,
          size: device.isMobile ? 24 : 21,
        ),
        label: const SizedBox.shrink(),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.muted,
          backgroundColor: AppTheme.surface,
          side: const BorderSide(color: AppTheme.line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle({required this.activeSection});

  final String activeSection;

  @override
  Widget build(BuildContext context) {
    final device = DeviceInfo.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SBNU / ',
              style: GoogleFonts.dmSans(
                fontSize: device.isMobile ? 8 : 9,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF929B95),
                letterSpacing: 1.2,
                height: 1,
              ),
            ),
            Text(
              activeSection,
              style: GoogleFonts.dmSans(
                fontSize: device.isMobile ? 8 : 9,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF929B95),
                letterSpacing: 1.2,
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          activeSection,
          style: GoogleFonts.manrope(
            fontSize: device.isMobile ? 16 : 19,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF15231B),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.hasQuery,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    final device = DeviceInfo.of(context);
    return SizedBox(
      width: device.isMobile ? 0 : 244,
      height: device.isMobile ? 0 : 38,
      child: !device.isMobile
          ? TextField(
              controller: controller,
              onChanged: onChanged,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF26342C),
                height: 1,
              ),
              decoration: InputDecoration(
                hintText: 'Search anything...',
                hintStyle: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9BA49E),
                  height: 1,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 15,
                  color: Color(0xFF8E9991),
                ),
                suffixIcon: hasQuery
                    ? GestureDetector(
                        onTap: () {
                          controller.clear();
                          onChanged('');
                        },
                        child: const Icon(
                          Icons.clear,
                          size: 16,
                          color: Color(0xFF9BA49E),
                        ),
                      )
                    : const SizedBox(width: 15),
                filled: true,
                fillColor: AppTheme.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.line),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.line),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.forest, width: 1.5),
                ),
                isDense: true,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.tooltip,
    required this.icon,
    this.badge = false,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final bool badge;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 38,
          height: 38,
          child: OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 17),
            label: const SizedBox.shrink(),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF4E5E54),
              backgroundColor: AppTheme.surface,
              side: const BorderSide(color: AppTheme.line),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        if (badge)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Color(0xFFD6463B),
                shape: BoxShape.circle,
                border: BorderSide(color: AppTheme.surface, width: 1),
              ),
            ),
          ),
      ],
    );
  }
}

class _CMULockup extends StatelessWidget {
  const _CMULockup();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.only(left: 13),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: AppTheme.line, width: 1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/images/cmu_logo.svg',
                fit: BoxFit.contain,
                semanticLabel: 'CMU logo',
                cacheWidth: 35,
                cacheHeight: 35,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Central Mindanao',
                style: GoogleFonts.dmSans(
                  fontSize: 8,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF738078),
                  letterSpacing: 0.5,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                'University',
                style: GoogleFonts.manrope(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF22482F),
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
