import 'package:flutter/material.dart';
import '../../widgets/app_sidebar.dart';
import '../../widgets/app_footer.dart';
import '../../screens/report/transaction_info.dart';
import '../../../data/services/auth_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  /// Original API data
  List<Map<String, dynamic>> apiData = [];

  /// Filtered UI data
  List<Map<String, dynamic>> displayData = [];

  bool _initialized = false;

  String? _selectedReportType;
  String? _selectedStatus;

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  AuthService _authService=AuthService();

  
  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      // appBar: AppBar(title: const Text('Report')),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Report",
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

      drawer: const AppSidebar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _filterSection(),
            // Text(),
            const SizedBox(height: 20),
            _reportTable(context),
          ],
        ),
      ),
      bottomNavigationBar: const AppFooter(currentIndex: 4),
    );
  }

  // ================= FILTER SECTION =================
  Widget _filterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Filters",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          Row(
            children: [
              // Expanded(child: _dropdownReportType("Report Type")),
              // const SizedBox(width: 12),
              Expanded(child: _dropdownStatus("Status")),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(child: _dateField("From Date", _fromDateController)),
              const SizedBox(width: 12),
              Expanded(child: _dateField("To Date", _toDateController)),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    displayData = applyFilters();
                  });
                },
                child: const Text("Apply Filter"),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _clearFilters,
                child: const Text("Clear Filter"),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedStatus = null;
      _selectedReportType = null;
      _fromDateController.clear();
      _toDateController.clear();
      displayData = List.from(apiData);
    });
  }

  // ================= REPORT TABLE =================
  Widget _reportTable(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _authService.getTransaction(3),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red)),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data found'));
        }

        if (!_initialized) {
          apiData = snapshot.data!;
          displayData = List.from(apiData);
          print(displayData);
          _initialized = true;
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: _boxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Report Data",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              ...displayData.map((element) {
                return _transactionCard(
                  context,
                  id: element['request_id'] ?? 'N/A',
                  title: element['category'] ?? 'N/A',
                  subtitle: element['blr_id'] ?? 'N/A',
                  amount: '₹${((num.tryParse(element['respAmount']?.toString() ?? '0') ?? 0) / 100).toStringAsFixed(2)}',
                  date: element['created_at'] != null
                      ? _formatDate(DateTime.parse(element['created_at']))
                      : '',
                  isCredit: element['txnStatus'] == '000',
                );
              }),

            ],
          ),
        );
      },
    );
  }

  // ================= DATE FIELD =================
  Widget _dateField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today, size: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          controller.text =
              "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        }
      },
    );
  }

  Widget _dropdownStatus(String hint) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedStatus,
      items: const [
        DropdownMenuItem(value: "000", child: Text("Success")),
        DropdownMenuItem(value: "001", child: Text("Failed")),
      ],
      onChanged: (value) => setState(() => _selectedStatus = value),
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ================= FILTER LOGIC =================
  List<Map<String, dynamic>> applyFilters() {
    return apiData.where((element) {
      if (_selectedStatus != null &&
          element['txnStatus'] != _selectedStatus) {
        return false;
      }

      if (_selectedReportType != null &&
          element['category'] != _selectedReportType) {
        return false;
      }

      if (_fromDateController.text.isNotEmpty &&
          _toDateController.text.isNotEmpty &&
          element['created_at'] != null) {
        final from = DateTime.parse(_fromDateController.text);
        final to = DateTime.parse(_toDateController.text);
        final elementDate = DateTime.parse(element['created_at']);

        if (elementDate.isBefore(from) || elementDate.isAfter(to)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // ================= TRANSACTION CARD =================
  Widget _transactionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String amount,
    required String date,
    required String id,
    required bool isCredit,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          amount,
          style: TextStyle(
            color: isCredit ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TransactionInfo(
                title: title,
                subtitle: subtitle,
                amount: amount,
                date: date,
                isCredit: isCredit,
                id: id,
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= UTIL =================
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

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }
}
