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

  bool _isLoading = true;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final response = await _categoryService.fetchUserCategories();

    if (response != null && response.status) {
      setState(() {
        _categories = response.categories;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      /// 🔹 App Bar
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Services",
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "All Services",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0033A0),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// 🔹 Services Grid
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: _cardDecoration(),
                    child: GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 12,
                      children: _categories.map((category) {
                        final meta = _categoryMeta(category);
                        return _serviceTile(
                          icon: meta.icon,
                          label: category,
                          color: meta.color,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BbpsServiceScreen(serviceName: category),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

      /// 🔹 Footer
      bottomNavigationBar: const AppFooter(currentIndex: 1),
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
      borderRadius: BorderRadius.circular(14),
      child: Column(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /// 🔹 Card Decoration
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

  /// 🔹 Category → Icon & Color Mapping
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
      // "LPG Gas": _CategoryMeta(Icons.home, Colors.deepOrange),
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

/// 🔹 Helper Class
class _CategoryMeta {
  final IconData icon;
  final Color color;

  const _CategoryMeta(this.icon, this.color);
}
