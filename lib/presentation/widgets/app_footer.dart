import 'package:flutter/material.dart';
import '../../core/utils/app_routes.dart';

class AppFooter extends StatelessWidget {
  final int currentIndex;

  const AppFooter({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0033A0),
        unselectedItemColor: Colors.grey.shade500,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        onTap: (index) {
          if (index == currentIndex) return;

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, AppRoutes.bills);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, AppRoutes.history);
              break;
            case 3:
              Navigator.pushReplacementNamed(context, AppRoutes.profile);
              break;
            case 4:
              Navigator.pushReplacementNamed(context, AppRoutes.more);
              break;
          }
        },
        items: [
          _navItem(
            icon: Icons.home,
            label: "Home",
            isActive: currentIndex == 0,
          ),
          _navItem(
            icon: Icons.receipt_long,
            label: "Bills",
            isActive: currentIndex == 1,
          ),
          _navItem(
            icon: Icons.history,
            label: "History",
            isActive: currentIndex == 2,
          ),
          _navItem(
            icon: Icons.person,
            label: "Profile",
            isActive: currentIndex == 3,
          ),
          _navItem(
            icon: Icons.more_horiz,
            label: "More",
            isActive: currentIndex == 4,
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _navItem({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return BottomNavigationBarItem(
      label: label,
      icon: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF0033A0).withOpacity(0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 4,
            width: isActive ? 18 : 0,
            decoration: BoxDecoration(
              color: const Color(0xFF0033A0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
