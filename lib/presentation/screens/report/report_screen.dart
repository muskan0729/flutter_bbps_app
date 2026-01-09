import 'package:flutter/material.dart';
import '../../widgets/app_sidebar.dart';
import '../../widgets/app_footer.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Report'),
        backgroundColor: Colors.blue,
      ),
      drawer: const AppSidebar(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 FILTER SECTION
            _filterSection(),

            const SizedBox(height: 20),

            /// 🔹 REPORT TABLE
            _reportTable(),
          ],
        ),
      ),

      bottomNavigationBar: const AppFooter(currentIndex: 4),
    );
  }

  /// ================= FILTER SECTION =================
  Widget _filterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filters",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: _dropdown("Report Type")),
              const SizedBox(width: 12),
              Expanded(child: _dropdown("Status")),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(child: _dateField("From Date")),
              const SizedBox(width: 12),
              Expanded(child: _dateField("To Date")),
            ],
          ),

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Apply Filter"),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= REPORT TABLE =================
  Widget _reportTable() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Report Data",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                Colors.grey.shade200,
              ),
              columns: const [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("Date")),
                DataColumn(label: Text("Type")),
                DataColumn(label: Text("Amount")),
                DataColumn(label: Text("Status")),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text("RPT001")),
                  DataCell(Text("10/09/2025")),
                  DataCell(Text("Payment")),
                  DataCell(Text("₹1,500")),
                  DataCell(Text("Success")),
                ]),
                DataRow(cells: [
                  DataCell(Text("RPT002")),
                  DataCell(Text("11/09/2025")),
                  DataCell(Text("Refund")),
                  DataCell(Text("₹500")),
                  DataCell(Text("Pending")),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= COMMON =================
  Widget _dropdown(String hint) {
    return DropdownButtonFormField<String>(
      items: const [],
      onChanged: (value) {},
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _dateField(String hint) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: hint,
        suffixIcon: const Icon(Icons.calendar_today, size: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onTap: () async {},
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
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
