import 'package:flutter/material.dart';

import '../../data/models/user.dart';
import 'admin_dashboard.dart';
import 'member_dashboard.dart';
import 'officer_dashboard.dart';

/// Chooses the role dashboard for the signed-in approved user.
///
/// The app layer passes the current profile; this router never fetches data
/// or decides authorization (the route guard and backend rules do).
class DashboardRouter extends StatelessWidget {
  const DashboardRouter({
    super.key,
    required this.profile,
    required this.onSignOut,
    this.onProfileLoading,
  });

  final UserProfile? profile;
  final VoidCallback onSignOut;
  final Widget? onProfileLoading;

  @override
  Widget build(BuildContext context) {
    final current = profile;
    if (current == null) {
      return onProfileLoading ??
          const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
    }
    return switch (current.role) {
      UserRole.member => MemberDashboard(
          displayName: current.displayName, onSignOut: onSignOut),
      UserRole.officer => OfficerDashboard(
          displayName: current.displayName, onSignOut: onSignOut),
      UserRole.admin => AdminDashboard(
          displayName: current.displayName, onSignOut: onSignOut),
    };
  }
}
