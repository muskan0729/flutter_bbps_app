import 'package:flutter/material.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/action_button.dart';
import '../../widgets/app_footer.dart';
import '../../../core/utils/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_sidebar.dart';  // Import the AppSidebar (sidebar)

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      /// 🔹 App Bar
      appBar: AppBar(
        title: const Text(
          "BBPS App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 98, 134, 211),
        elevation: 0,
      ),

      /// 🔹 Sidebar (Drawer)
      drawer: const AppSidebar(),  // Add AppSidebar here for the sidebar navigation

      /// 🔹 Page Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            /// 🔹 Balance Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: _cardDecoration(),
              child: const BalanceCard(),
            ),

            const SizedBox(height: 30),

            /// 🔹 Top Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ActionButton(
                  icon: Icons.send,
                  label: "Send",
                  iconColor: const Color(0xFFFF6600),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.sendMoney),
                ),
                ActionButton(
                  icon: Icons.history,
                  label: "History",
                  iconColor: const Color(0xFF0033A0),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.history),
                ),
                ActionButton(
                  icon: Icons.person,
                  label: "Profile",
                  iconColor: Colors.grey,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.profile),
                ),
              ],
            ),

            const SizedBox(height: 32),

            /// 🔹 Services Title
            const Text(
              "Services",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0033A0),
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 Services Grid Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 20,
                crossAxisSpacing: 12,
                children: [
                  _serviceTile(
                    icon: Icons.phone_android,
                    label: "Mobile",
                    color: Colors.orange,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.bills),
                  ),
                  _serviceTile(
                    icon: Icons.tv,
                    label: "DTH",
                    color: Colors.red,
                    onTap: () {},
                  ),
                  _serviceTile(
                    icon: Icons.flash_on,
                    label: "Electricity",
                    color: Colors.amber,
                    onTap: () {},
                  ),
                  _serviceTile(
                    icon: Icons.water_drop,
                    label: "Water",
                    color: Colors.blue,
                    onTap: () {},
                  ),
                  _serviceTile(
                    icon: Icons.local_gas_station,
                    label: "Gas",
                    color: Colors.deepOrange,
                    onTap: () {},
                  ),
                  _serviceTile(
                    icon: Icons.wifi,
                    label: "Broadband",
                    color: Colors.purple,
                    onTap: () {},
                  ),
                  _serviceTile(
                    icon: Icons.credit_card,
                    label: "Credit Card",
                    color: Colors.green,
                    onTap: () {},
                  ),
                  _serviceTile(
                    icon: Icons.more_horiz,
                    label: "More",
                    color: Colors.grey,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.bills),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// 🔹 FOOTER (Bottom Navigation)
      bottomNavigationBar: const AppFooter(currentIndex: 0),
    );
  }

  /// 🔹 Service Tile Widget
  Widget _serviceTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Common Card Decoration
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
