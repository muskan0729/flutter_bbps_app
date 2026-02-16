import 'package:flutter/material.dart';
import '../../core/utils/app_routes.dart';

class AppFooter extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTapIndex;

  const AppFooter({
    super.key,
    required this.currentIndex,
    this.onTapIndex,
  });

  static const Color _primary = Color(0xFF0033A0);

  void _handleTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    // Swipe mode
    if (onTapIndex != null) {
      onTapIndex!(index);
      return;
    }

    // Route mode
    String route;

    switch (index) {
      case 0:
        route = AppRoutes.home;
        break;
      case 1:
        route = AppRoutes.bills;
        break;
      case 2:
        route = AppRoutes.report;
        break;
      case 3:
        route = AppRoutes.profile;
        break;
      default:
        return;
    }

    Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final bool tiny = w < 360;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, -8),
            ),
          ],
          border: Border.all(color: const Color(0xFFE9EEF7)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: _primary,
          unselectedItemColor: Colors.grey.shade500,
          showSelectedLabels: !tiny,
          showUnselectedLabels: !tiny,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          onTap: (i) => _handleTap(context, i),
          items: [
            _navItem(icon: Icons.home_rounded, label: "Home", i: 0),
            _navItem(icon: Icons.receipt_long_rounded, label: "Services", i: 1),
            _navItem(icon: Icons.history_rounded, label: "Transation History", i: 2),
            _navItem(icon: Icons.person_rounded, label: "Profile", i: 3),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem({
    required IconData icon,
    required String label,
    required int i,
  }) {
    final bool active = currentIndex == i;

    return BottomNavigationBarItem(
      label: label,
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: active ? _primary.withOpacity(0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: active
                    ? _primary.withOpacity(0.18)
                    : Colors.transparent,
              ),
            ),
            child: Icon(
              icon,
              size: 22,
              color: active ? _primary : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            height: 4,
            width: active ? 18 : 0,
            decoration: BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ],
      ),
    );
  }
}