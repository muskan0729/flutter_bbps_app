import 'package:flutter/material.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/action_button.dart';
import '../../widgets/app_footer.dart';
import '../../../core/utils/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_sidebar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      /// 🔹 Modern AppBar
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Spay Wallet",
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

      /// 🔹 Sidebar
      drawer: const AppSidebar(),

      /// 🔹 Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            /// 🔹 Wallet Balance (Hero Card)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: _balanceCardDecoration(),
              child: const BalanceCard(),
            ),

            const SizedBox(height: 28),

            /// 🔹 Quick Actions
            Row(
              children: [
                Expanded(
                  child: ActionButton(
                    icon: Icons.send,
                    label: "Send",
                    iconColor: Colors.deepOrange,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.sendMoney),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ActionButton(
                    icon: Icons.history,
                    label: "History",
                    iconColor: Colors.indigo,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.history),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ActionButton(
                    icon: Icons.person,
                    label: "Profile",
                    iconColor: Colors.grey,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.profile),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            /// 🔹 Services Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Services",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "View all",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔹 Services Grid
            Container(
              padding: const EdgeInsets.all(10),
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

            const SizedBox(height: 24),

            /// 🔹 Trust Badge
            Row(
              children: const [
                Icon(Icons.lock, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  "Wallet secured with encryption",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      /// 🔹 Bottom Navigation
      bottomNavigationBar: const AppFooter(currentIndex: 0),
    );
  }

  /// 🔹 Service Tile
  Widget _serviceTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Normal Card Decoration (Material 3)
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// 🔹 Balance Card Decoration (Premium)
  BoxDecoration _balanceCardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      gradient: const LinearGradient(
        colors: [
          Color(0xFF0033A0),
          Color(0xFF1E5EFF),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.withOpacity(0.25),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}
