import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_routes.dart';
import '../../widgets/app_footer.dart';
import '../../widgets/app_sidebar.dart';

class Morescreens extends StatefulWidget {
  const Morescreens({super.key});

  @override
  State<Morescreens> createState() => _MorescreensState();
}

class _MorescreensState extends State<Morescreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      /// AppBar
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "More",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0033A0), Color(0xFF4B7BEC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      /// Sidebar
      drawer: const AppSidebar(),

      /// Body (2x2 Grid)
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _moreGridCard(
              icon: Icons.report,
              title: "Transation History",
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.report),
            ),
            _moreGridCard(
              icon: Icons.support_agent,
              title: "Support",
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.support),
            ),
            _moreGridCard(
              icon: Icons.feedback,
              title: "Complaint",
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.complaint),
            ),
            _moreGridCard(
              icon: Icons.search,
              title: "Check Complaint",
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.checkComplaint),
            ),
          ],
        ),
      ),

      /// Footer
      bottomNavigationBar: const AppFooter(currentIndex: 3),
    );
  }

  /// 🔹 Grid Card Widget
  Widget _moreGridCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0033A0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF0033A0),
                size: 32,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
