import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/utils/app_routes.dart';

// Importing all screens that will be navigated to through the sidebar
import '../screens/home/home_screen.dart'; // Dashboard Screen
import '../screens/bills/bills_screen.dart'; // Services Screen
import '../screens/report/report_screen.dart'; // Report Screen
import '../screens/support/support_screen.dart'; // Support Screen
import '../screens/complaint/complaint_screen.dart'; // Complaint Screen
import '../screens/check_complaint/check_complaint_screen.dart'; // Check Complaint Screen

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Simple Drawer Header with Profile Picture
          const DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30, // Profile picture size
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Placeholder for profile image
                ),
                SizedBox(height: 10),
                Text(
                  'User ABC', // Username
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Mumbai', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),

          // List of simple menu items
          _buildDrawerItem(
            context,
            title: 'Dashboard',
            icon: Icons.dashboard,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            title: 'Report',
            icon: Icons.message,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ReportScreen()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            title: 'Services',
            icon: Icons.home,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BillsScreen()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            title: 'Support',
            icon: Icons.transfer_within_a_station,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SupportScreen()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            title: 'Complaint',
            icon: Icons.store,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ComplaintScreen()),
              );
            },
          ),
                   _buildDrawerItem(
            context,
            title: 'Check Complaint',
            icon: Icons.info,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CheckComplaintScreen()),
              );
            },
          ),

          // Logout Button at the bottom
          _buildLogoutItem(context),
        ],
      ),
    );
  }

  // Simple Drawer Item with Icon and Text
  Widget _buildDrawerItem(BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.blueAccent), // Icon color
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }

  // Simple Logout Button at the bottom
Widget _buildLogoutItem(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 10.0),
    child: ListTile(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      },
      leading: const Icon(Icons.exit_to_app, color: Colors.red),
      title: const Text(
        "Logout",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.red,
        ),
      ),
    ),
  );
}

}
