import 'package:flutter/material.dart';
import '../../widgets/app_footer.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_sidebar.dart';
import 'bbps_service_screen.dart';
import '../../../data/services/category_service.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final CategoryService _categoryService = CategoryService();

  // ✅ Theme
  static const Color _primary = Color(0xFF0033A0);
  static const Color _accent = Color(0xFF4B7BEC);

  // ✅ Assets
  static const String _appLogo = "assets/images/logo_app_icon_white.png";
  static const String _bharatConnectLogo =
      "assets/images/BharatConnectLogo_PNG.png";

  bool _isLoading = true;
  List<String> _categories = [];

  final TextEditingController _searchCtrl = TextEditingController();
  List<String> _filtered = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _searchCtrl.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_applyFilter);
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final response = await _categoryService.fetchUserCategories();

      if (!mounted) return;
      if (response != null && response.status) {
        setState(() {
          _categories = response.categories;
          _filtered = response.categories;
          _isLoading = false;
        });
      } else {
        setState(() {
          _categories = [];
          _filtered = [];
          _isLoading = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _categories = [];
        _filtered = [];
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = _categories;
      } else {
        _filtered = _categories
            .where((c) => c.toLowerCase().contains(q))
            .toList(growable: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;

        final bool isMobile = w < 600;
        final double pagePadding = isMobile ? 16 : (w < 1024 ? 22 : 28);
        final double maxContentWidth = w >= 1200 ? 1100 : double.infinity;

        // ✅ Responsive grid columns
        final int cols = w < 420
            ? 3
            : w < 600
                ? 4
                : w < 900
                    ? 6
                    : 8;

        // ✅ Tile ratio for better look
        final double ratio = w < 420 ? 1.05 : 1.15;

        return Scaffold(
          backgroundColor: AppColors.background,

          /// ✅ Premium AppBar + logo
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              "Services",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primary, _accent],
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
                    _appLogo,
                    height: 34,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// Sidebar
          drawer: const AppSidebar(),

          /// Body
          body: SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(pagePadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _headerCard(count: _categories.length),
                            const SizedBox(height: 14),
                            _searchBox(),
                            const SizedBox(height: 14),
                            _filtered.isEmpty
                                ? _emptyState()
                                : Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: _cardDecoration(),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _filtered.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: cols,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 14,
                                        childAspectRatio: ratio,
                                      ),
                                      itemBuilder: (context, index) {
                                        final category = _filtered[index];
                                        final meta = _categoryMeta(category);
                                        return _serviceTile(
                                          icon: meta.icon,
                                          label: category,
                                          color: meta.color,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => BbpsServiceScreen(
                                                  serviceName: category,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),

          /// Footer
          bottomNavigationBar: const AppFooter(currentIndex: 1),
        );
      },
    );
  }

  /// ✅ Header card with Bharat Connect logo
  Widget _headerCard({required int count}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFFE9EEF7)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [_primary.withOpacity(0.15), _accent.withOpacity(0.10)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.grid_view_rounded, color: _primary),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "All Services",
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1F2A37),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Choose category to continue",
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          /// ✅ Bharat Connect Logo
        

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F8FE),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFE6EDF8)),
            ),
            child: Text(
              "$count",
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: _primary,
              ),
            ),
          ),
            Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Image.asset(
              _bharatConnectLogo,
              height: 30,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Search
  Widget _searchBox() {
    return TextField(
      controller: _searchCtrl,
      decoration: InputDecoration(
        hintText: "Search services",
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE3EAF6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE3EAF6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _primary, width: 1.2),
        ),
        suffixIcon: _searchCtrl.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchCtrl.clear();
                  _applyFilter();
                },
                icon: const Icon(Icons.close_rounded),
              ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE9EEF7)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 36, color: Colors.grey.shade600),
            const SizedBox(height: 8),
            Text(
              "No services found",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Try changing the search keyword",
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Service Tile (standard)
  Widget _serviceTile({
    required IconData icon,
    required String label,
    required Color color,
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
          border: Border.all(color: const Color(0xFFE9EEF7)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: color.withOpacity(0.12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2A37),
                  height: 1.15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Card decoration
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
      border: Border.all(color: const Color(0xFFE9EEF7)),
    );
  }

  /// Category -> Icon & Color mapping
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