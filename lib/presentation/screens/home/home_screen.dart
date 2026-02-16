import 'package:flutter/material.dart';
import 'package:my_flutter_app/presentation/screens/bills/bbps_service_screen.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/app_footer.dart';
import '../../../core/utils/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_sidebar.dart';
import '../../../data/services/category_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color _primary = Color(0xFF0033A0);
  static const Color _secondary = Color(0xFF1E5EFF);
  static const Color _lightBlue = Color(0xFF4B7BEC);

  final CategoryService _categoryService = CategoryService();

  bool _isLoadingServices = true;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadHomeServices();
  }

  Future<void> _loadHomeServices() async {
    try {
      final res = await _categoryService.fetchUserCategories();

      if (!mounted) return;

      setState(() {
        _categories = (res != null && res.status) ? res.categories : [];
        _isLoadingServices = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _categories = [];
        _isLoadingServices = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;

        // ✅ Responsive padding
        final pagePadding = w < 600 ? 16.0 : (w < 1024 ? 22.0 : 28.0);

        // ✅ Keep content premium on large screens
        final contentMaxWidth = w < 1024 ? w : 1100.0;

        return Scaffold(
          backgroundColor: AppColors.background,

          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              "Spay Wallet",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primary, _secondary],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Image.asset(
                    "assets/images/logo_app_icon_white.png",
                    height: 36,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          drawer: const AppSidebar(),

          body: SingleChildScrollView(
            padding: EdgeInsets.all(pagePadding),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentMaxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // ✅ Balance card
                    Container(
                      padding: EdgeInsets.all(w < 600 ? 18 : 24),
                      decoration: _balanceCardDecoration(),
                      child: const BalanceCard(),
                    ),

                    const SizedBox(height: 28),

                    // ✅ Services Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Services",
                          style: TextStyle(
                            fontSize: w < 600 ? 18 : 20,
                            fontWeight: FontWeight.w700,
                            color: _primary,
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.bills),
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

                    // ✅ Dynamic services box (API)
                    _servicesBoxDynamic(context, width: w),

                    const SizedBox(height: 24),

                    const Row(
                      children: [
                        Icon(Icons.lock, size: 16, color: Colors.grey),
                        SizedBox(width: 6),
                        Text(
                          "Wallet secured with encryption",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          bottomNavigationBar: const AppFooter(currentIndex: 0),
        );
      },
    );
  }

  /// ✅ SERVICES BOX (Dynamic from API) -> show 8 + More
  Widget _servicesBoxDynamic(BuildContext context, {required double width}) {
    // ✅ Responsive columns
    final int cols = width < 420
        ? 3
        : width < 600
            ? 4
            : width < 900
                ? 6
                : 8;

    final double childAspect = width < 420 ? 0.95 : 1.05;

    // take only first 8
    final List<String> top8 = _categories.length > 11
        ? _categories.take(11).toList()
        : List<String>.from(_categories);

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
        border: Border.all(color: _primary.withOpacity(0.08), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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
            child: const Row(
              children: [
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

          if (_isLoadingServices)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (top8.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.widgets_outlined,
                        size: 34, color: Colors.grey.shade600),
                    const SizedBox(height: 8),
                    Text(
                      "No services available",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: _loadHomeServices,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            )
          else
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                mainAxisSpacing: 14,
                crossAxisSpacing: 12,
                childAspectRatio: childAspect,
              ),
              children: [
                ...top8.map((category) {
                  final meta = _categoryMeta(category);
                  return _premiumServiceTile(
                    icon: meta.icon,
                    label: category,
                    accent: meta.color, // dynamic accent
                    onTap: () {
                      // open the specific category page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BbpsServiceScreen(serviceName: category),
                        ),
                      );
                    },
                  );
                }),

                // ✅ More tile (always show after 8)
                _premiumServiceTile(
                  icon: Icons.more_horiz,
                  label: "More",
                  accent: _primary,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.bills),
                ),
              ],
            ),

          const SizedBox(height: 10),

          Row(
            children: [
              Icon(Icons.lock_rounded,
                  size: 14, color: _primary.withOpacity(0.55)),
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
          border: Border.all(color: _primary.withOpacity(0.08), width: 1),
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
                  colors: [accent.withOpacity(0.18), accent.withOpacity(0.08)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(icon, color: accent, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: _primary,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  /// ✅ Same mapping as BillsScreen (icon + color)
  _CategoryMeta _categoryMeta(String category) {
    const map = {
      "Fastag": _CategoryMeta(Icons.directions_car, Colors.blueGrey),
      "Donation": _CategoryMeta(Icons.volunteer_activism, Colors.pink),
      "Cable TV": _CategoryMeta(Icons.tv, Colors.red),
      "Agent Collection": _CategoryMeta(Icons.badge, Colors.indigo),
      "Broadband Postpaid": _CategoryMeta(Icons.wifi, Colors.purple),
      "Clubs and Associations": _CategoryMeta(Icons.groups, Colors.teal),
      "Credit Card": _CategoryMeta(Icons.credit_card, Colors.green),
      "DTH": _CategoryMeta(Icons.satellite_alt, Colors.deepOrange),
      "eChallan": _CategoryMeta(Icons.receipt_long, Colors.brown),
      "Education Fees": _CategoryMeta(Icons.school, Colors.blue),
      "Electricity": _CategoryMeta(Icons.bolt, Colors.amber),
      "EV Recharge": _CategoryMeta(Icons.battery_charging_full, Colors.green),
      "Gas": _CategoryMeta(Icons.local_gas_station, Colors.deepOrange),
      "Housing Society": _CategoryMeta(Icons.apartment, Colors.indigo),
      "Insurance": _CategoryMeta(Icons.security, Colors.green),
      "Landline Postpaid": _CategoryMeta(Icons.phone, Colors.blue),
      "Loan Repayment": _CategoryMeta(Icons.account_balance, Colors.brown),
      "LPG Gas": _CategoryMeta(Icons.fireplace, Colors.redAccent),
      "Mobile Postpaid": _CategoryMeta(Icons.receipt, Colors.teal),
      "Mobile Prepaid": _CategoryMeta(Icons.phone_android, Colors.orange),
      "Municipal Services": _CategoryMeta(Icons.location_city, Colors.blueGrey),
      "Municipal Taxes": _CategoryMeta(Icons.description, Colors.brown),
      "National Pension System": _CategoryMeta(Icons.person, Colors.indigo),
      "NCMC Recharge": _CategoryMeta(Icons.train, Colors.deepPurple),
      "Prepaid Meter": _CategoryMeta(Icons.power, Colors.amber),
      "Recurring Deposit": _CategoryMeta(Icons.savings, Colors.green),
      "Rental": _CategoryMeta(Icons.house, Colors.blue),
      "Subscription": _CategoryMeta(Icons.autorenew, Colors.purple),
    };

    return map[category] ??
        const _CategoryMeta(Icons.receipt_long, Colors.grey);
  }
}

class _CategoryMeta {
  final IconData icon;
  final Color color;
  const _CategoryMeta(this.icon, this.color);
}