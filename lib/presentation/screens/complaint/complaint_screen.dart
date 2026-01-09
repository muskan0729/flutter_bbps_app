import 'package:flutter/material.dart';
import '../../widgets/app_sidebar.dart';
import '../../widgets/app_footer.dart';
import '../../../data/services/complaint_services.dart';
import '../../../data/models/complaint_model.dart';


class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
// Dropdown & text fields
String complaintType = '';
String participationType = '';
String complaintDisposition = '';
final TextEditingController complaintDescController = TextEditingController();
final TextEditingController txnRefController = TextEditingController();

// Loading state
bool isLoading = false;

// Service instance
final ComplaintService complaintService = ComplaintService();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Complaint'),
        backgroundColor: Colors.blue,
      ),
      drawer: const AppSidebar(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 COMPLAINT FORM CARD
            _complaintFormCard(),

            const SizedBox(height: 20),

            /// 🔹 TRANSACTION HISTORY TABLE CARD
            _transactionHistoryCard(),
          ],
        ),
      ),

      bottomNavigationBar: const AppFooter(currentIndex: 4),
    );
  }

  /// ================= COMPLAINT FORM =================
  Widget _complaintFormCard() {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            icon: Icons.assignment,
            title: "Transaction Complaint",
          ),

          const SizedBox(height: 16),

        _dropdownField(
          "Complaint Type",
          ["Service", "Transaction", "Other"],
          complaintType,
          (val) => setState(() => complaintType = val ?? ''), 
        ),
        const SizedBox(height: 14),
        _dropdownField(
          "Participation Type",
          ["BILLER", "AGENT" ,"Biller"],
          participationType,
          (val) => setState(() => participationType = val ?? ''),
        ),

          const SizedBox(height: 20),

          _cardTitle(
            icon: Icons.chat_bubble_outline,
            title: "Complaint Reason",
            trailing: const Text(
              "Bharat Connect",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          _dropdownField(
            "Complaint Disposition",
            [ "Bill Paid but Amount not adjusted or still showing due amount", "Failed","Pending"],
            complaintDisposition,
            (val) => setState(() => complaintDisposition = val ?? ''),
          ),
      
      const SizedBox(height: 14),

      _textAreaField("Enter complaint details...", complaintDescController),
      const SizedBox(height: 14),
      TextField(
        controller: txnRefController,
        decoration: InputDecoration(
          hintText: "Enter Txn Ref ID",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

          const SizedBox(height: 20),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              // onPressed: () {},
          onPressed: isLoading
    ? null
    : () async {
        if (complaintType.isEmpty || complaintDisposition.isEmpty || txnRefController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please fill all required fields")),
          );
          return;
        }

        setState(() => isLoading = true);

        try {
          // Create the request model
          final request = ComplaintRequest(
            complaintType: complaintType,
            participationType: participationType.isEmpty ? "N/A" : participationType,
            agentId: "N/A", // or fill if available
            billerId: "N/A", // or fill if available
            servReason: "N/A", // or fill if available
            complainDesc: complaintDescController.text,
            txnRefId: txnRefController.text,
            complaintDisposition: complaintDisposition,
          );

          // Call the model-based service
          final response = await complaintService.registerComplaintModel(request);

          print("API Response: $response"); // debug response

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Complaint submitted successfully!")),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to submit complaint: $e")),
          );
        } finally {
          setState(() => isLoading = false);
        }
      },


              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.send),
              label: Text(isLoading ? "Submitting..." : "Submit Complaint"),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= TRANSACTION TABLE =================
  Widget _transactionHistoryCard() {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            icon: Icons.history,
            title: "Transaction History",
          ),

          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                Colors.grey.shade200,
              ),
              columns: const [
                DataColumn(label: Text("Txn ID")),
                DataColumn(label: Text("Date")),
                DataColumn(label: Text("Amount")),
                DataColumn(label: Text("Status")),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text("TXN12345")),
                  DataCell(Text("12/09/2025")),
                  DataCell(Text("₹1,200")),
                  DataCell(Text("Success")),
                ]),
                DataRow(cells: [
                  DataCell(Text("TXN12346")),
                  DataCell(Text("13/09/2025")),
                  DataCell(Text("₹500")),
                  DataCell(Text("Pending")),
                ]),
                DataRow(cells: [
                  DataCell(Text("TXN12347")),
                  DataCell(Text("14/09/2025")),
                  DataCell(Text("₹850")),
                  DataCell(Text("Failed")),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= COMMON WIDGETS =================
  Widget _cardWrapper({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _cardTitle({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.black87),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (trailing != null) trailing,
      ],
    );
  }

 Widget _dropdownField(String hint, List<String> items, String value, Function(String?) onChanged) {
  return DropdownButtonFormField<String>(
    value: value.isEmpty ? null : value,
    items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

Widget _textAreaField(String hint, TextEditingController controller) {
  return TextField(
    controller: controller,
    maxLines: 4,
    decoration: InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}




}
