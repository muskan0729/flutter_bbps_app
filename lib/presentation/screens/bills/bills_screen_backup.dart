import 'package:flutter/material.dart';
import '../../widgets/app_footer.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_sidebar.dart'; // Import the AppSidebar
import 'bbps_service_screen.dart';
import '../../../data/services/category_service.dart';

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      /// 🔹 App Bar
      appBar: AppBar(
        title: const Text(
          "Amaan Bills",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 98, 134, 211),
        elevation: 0,
      ),

      /// 🔹 Sidebar (Drawer)
      drawer:
          const AppSidebar(), // Add the AppSidebar here for the sidebar navigation
      /// 🔹 Body
      body: SingleChildScrollView(
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
                children: _services
                    .map(
                      (service) => _serviceTile(
                        icon: service.icon,
                        label: service.title,
                        color: service.color,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  BbpsServiceScreen(serviceName: service.title),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),

      /// 🔹 Footer
      bottomNavigationBar: const AppFooter(currentIndex: 1),
    );
  }

  /// 🔹 Service Tile (same as Home)
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
}

//// 🔹 Service Model
class _ServiceItem {
  final String title;
  final IconData icon;
  final Color color;

  const _ServiceItem(this.title, this.icon, this.color);
}

//// 🔹 ALL BBPS SERVICES (Mapped to Material Icons)
const List<_ServiceItem> _services = [
  _ServiceItem("Agent Collection", Icons.badge, Colors.indigo),
  _ServiceItem("Broadband Postpaid", Icons.wifi, Colors.purple),
  _ServiceItem("Cable TV", Icons.tv, Colors.red),
  _ServiceItem("Clubs", Icons.groups, Colors.teal),
  _ServiceItem("Credit Card", Icons.credit_card, Colors.green),
  _ServiceItem("Donation", Icons.volunteer_activism, Colors.pink),
  _ServiceItem("DTH", Icons.satellite_alt, Colors.deepOrange),
  _ServiceItem("eChallan", Icons.receipt_long, Colors.brown),
  _ServiceItem("Education Fees", Icons.school, Colors.blue),
  _ServiceItem("Electricity", Icons.bolt, Colors.amber),
  _ServiceItem("EV Recharge", Icons.battery_charging_full, Colors.green),
  _ServiceItem("Fastag", Icons.directions_car, Colors.blueGrey),
  _ServiceItem("Gas", Icons.local_gas_station, Colors.deepOrange),
  _ServiceItem("Housing Society", Icons.apartment, Colors.indigo),
  _ServiceItem("Insurance", Icons.security, Colors.green),
  _ServiceItem("Landline Postpaid", Icons.phone, Colors.blue),
  _ServiceItem("Loan Repayment", Icons.account_balance, Colors.brown),
  _ServiceItem("LPG Gas", Icons.fireplace, Colors.redAccent),
  _ServiceItem("Mobile Postpaid", Icons.receipt, Colors.teal),
  _ServiceItem("Mobile Prepaid", Icons.phone_android, Colors.orange),
  _ServiceItem("Municipal Services", Icons.location_city, Colors.blueGrey),
  _ServiceItem("Municipal Taxes", Icons.description, Colors.brown),
  _ServiceItem("NPS", Icons.person, Colors.indigo),
  _ServiceItem("NCMC Recharge", Icons.train, Colors.deepPurple),
  _ServiceItem("Prepaid Meter", Icons.power, Colors.amber),
  _ServiceItem("Recurring Deposit", Icons.savings, Colors.green),
  _ServiceItem("Rental", Icons.house, Colors.blue),
  _ServiceItem("Subscription", Icons.autorenew, Colors.purple),
  _ServiceItem("Water", Icons.water_drop, Colors.blue),
];
