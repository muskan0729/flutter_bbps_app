import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart'; // Assuming you have some predefined colors
import '../../widgets/app_footer.dart'; // Importing your custom footer widget
import '../../widgets/app_sidebar.dart'; // Import the sidebar (AppSidebar)

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Assuming you have a background color defined

      /// 🔹 App Bar
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 98, 134, 211), // Consistent color with other screens
        elevation: 0,
      ),

      /// 🔹 Sidebar (Drawer)
      drawer: const AppSidebar(), // Add AppSidebar here for the sidebar navigation

      /// 🔹 Page Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            /// 🔹 Profile Picture and Details Section
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,  // Profile picture radius
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Placeholder image
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "John Doe",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0033A0), // Consistent color theme
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Premium User",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0033A0), // Accent color for Premium Text
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            /// 🔹 Account Balance Section (Premium Design)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: _cardDecoration(), // Stylish card with shadow
              child: Column(
                children: [
                  const Text(
                    "Current Balance",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0033A0), // Consistent accent color
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "₹25,000",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green, // Premium green color for balance
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// 🔹 Settings and Actions Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Change Password Button
                _profileActionButton(
                  context: context,
                  label: "Change Password",
                  icon: Icons.lock,
                  onTap: () {
                    // Handle the tap
                  },
                ),
                const SizedBox(height: 16),
                // Edit Profile Button
                _profileActionButton(
                  context: context,
                  label: "Edit Profile",
                  icon: Icons.edit,
                  onTap: () {
                    // Handle the tap
                  },
                ),
                const SizedBox(height: 16),
                // Logout Button
                _profileActionButton(
                  context: context,
                  label: "Logout",
                  icon: Icons.exit_to_app,
                  onTap: () {
                    // Handle the tap
                  },
                ),
              ],
            ),
          ],
        ),
      ),

      /// 🔹 FOOTER (Bottom Navigation)
      bottomNavigationBar: const AppFooter(currentIndex: 3), // Assuming Profile is the 3rd tab
    );
  }

  /// 🔹 Profile Action Button Widget
  Widget _profileActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF0033A0), size: 28),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Common Card Decoration for Premium Look
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}
