import 'package:flutter/material.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/action_button.dart';
import '../../widgets/app_footer.dart';
import '../../../core/utils/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_sidebar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color _primary = Color(0xFF0033A0);
  static const Color _secondary = Color(0xFF1E5EFF);
  static const Color _lightBlue = Color(0xFF4B7BEC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      /// 🔹 Modern AppBar
    appBar: AppBar(
  elevation: 0,
  title: const Text(
    "Spay Wallet",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),

  /// ✅ Gradient Background
  flexibleSpace: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [_primary, _lightBlue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),

  /// ✅ Logo on Right Corner
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Center(
        child: Image.asset(
          "assets/images/logo_app_icon_white.png",
          height: 40,
        ),
      ),
    ),
  ],
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

      
            const SizedBox(height: 32),

            /// 🔹 Services Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Services",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _primary,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.bills),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Text(
                      "View all",
                      style: TextStyle(
                        color: _primary.withOpacity(0.85),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// ✅ PREMIUM SERVICES BOX (new)
            _servicesBox(context),

            const SizedBox(height: 24),

            /// 🔹 Trust Badge (outside box)
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

  /// ✅ PREMIUM SERVICES BOX
  Widget _servicesBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: _primary.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// top mini header inside box (premium touch)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [
                  _primary.withOpacity(0.10),
                  _lightBlue.withOpacity(0.10),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: const [
                Icon(Icons.grid_view_rounded, size: 18, color: _primary),
                SizedBox(width: 8),
                Text(
                  "Pay & Recharge",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: _primary,
                  ),
                ),
                Spacer(),
                Text(
                  "Secure",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _primary,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.verified_rounded, size: 16, color: _primary),
              ],
            ),
          ),

          const SizedBox(height: 14),

          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 14,
            crossAxisSpacing: 12,
            children: [
              _premiumServiceTile(
                icon: Icons.phone_android,
                label: "Mobile",
                accent: _secondary,
                onTap: () => Navigator.pushNamed(context, AppRoutes.bills),
              ),
              _premiumServiceTile(
                icon: Icons.tv,
                label: "DTH",
                accent: _lightBlue,
                onTap: () {},
              ),
              _premiumServiceTile(
                icon: Icons.flash_on,
                label: "Electricity",
                accent: _secondary,
                onTap: () {},
              ),
              _premiumServiceTile(
                icon: Icons.water_drop,
                label: "Water",
                accent: _lightBlue,
                onTap: () {},
              ),
              _premiumServiceTile(
                icon: Icons.local_gas_station,
                label: "Gas",
                accent: _secondary,
                onTap: () {},
              ),
              _premiumServiceTile(
                icon: Icons.wifi,
                label: "Broadband",
                accent: _lightBlue,
                onTap: () {},
              ),
              _premiumServiceTile(
                icon: Icons.credit_card,
                label: "Credit Card",
                accent: _secondary,
                onTap: () {},
              ),
              _premiumServiceTile(
                icon: Icons.more_horiz,
                label: "More",
                accent: _primary,
                onTap: () => Navigator.pushNamed(context, AppRoutes.bills),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// bottom hint line inside box
          Row(
            children: [
              Icon(
                Icons.lock_rounded,
                size: 14,
                color: _primary.withOpacity(0.55),
              ),
              const SizedBox(width: 6),
              Text(
                "Protected by encryption",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _primary.withOpacity(0.55),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ✅ Premium Service Tile (only your blue theme)
  Widget _premiumServiceTile({
    required IconData icon,
    required String label,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: _primary.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    accent.withOpacity(0.18),
                    accent.withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(icon, color: accent, size: 22),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: _primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Balance Card Decoration (Premium)
  BoxDecoration _balanceCardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      gradient: const LinearGradient(
        colors: [_primary, _secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: _lightBlue.withOpacity(0.25),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}