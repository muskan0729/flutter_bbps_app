import 'package:flutter/material.dart';
import '../../widgets/app_sidebar.dart';
import '../../widgets/app_footer.dart';
import '../../../data/services/check_complaint_service.dart';
import '../../../data/models/complaint_status_model.dart';


class CheckComplaintScreen extends StatefulWidget {
   const CheckComplaintScreen({super.key});

    @override
  State<CheckComplaintScreen> createState() => _CheckComplaintScreenState();
}

class _CheckComplaintScreenState extends State<CheckComplaintScreen> {
  ComplaintStatusResponse? complaintStatus;
  String complaintType = "";
  String complaintId = "";
   bool isLoading = false;
   final TextEditingController complaintIdController = TextEditingController();
    List<String> complaintTypes = [
      "Transaction",
    
    ];
   final ComplaintStatusService complaintStatusService = ComplaintStatusService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Check Complaint'),
        backgroundColor: Colors.blue,
      ),
      drawer: const AppSidebar(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(20),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Header
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Check Complaint Status – Tracking",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      children: const [
                        Icon(Icons.sync_alt, color: Colors.blue),
                        Text(
                          "Bharat\nConnect",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Complaint Type
                const Text("Complaint Type"),
                const SizedBox(height: 6),
                _dropdownField("Select Type"),

                const SizedBox(height: 16),

                /// Complaint ID
                const Text("Enter Complaint ID"),
                const SizedBox(height: 6),
                _inputField("Enter your Complaint ID"),

                const SizedBox(height: 20),

                /// Check Status Button
                ElevatedButton(
                  // onPressed: () {},
                          // onPressed: () {},
                  onPressed: isLoading
            ? null
            : () async {
                if (complaintType.isEmpty || complaintId.isEmpty ) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all required fields")),
                  );
                  return;
                }

                setState(() => isLoading = true);

                try {
                  // Create the request model
                  final request = ComplaintStatusRequest(
                    complaintType: complaintType,
                    complaintId: complaintId,

                  );

                  // Call the model-based service
                  // final response = await ComplaintStatusService.statusComplaintmodel(request);
                  final response = await complaintStatusService.statusComplaintmodel(request);
                  setState(() {
                  complaintStatus = response;
                });


                  print("API Response: $response"); // debug response

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Complaint status checked!")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to check complaint status: $e")),
                  );
                } finally {
                  setState(() => isLoading = false);
                }
              },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Check Status"),
                ),

                const SizedBox(height: 20),

                const Divider(),

                const SizedBox(height: 12),

                /// Complaint Status Table
                const Text(
                  "Complaint Status",
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
                      const Color(0xFFF3ECFF),
                    ),
                    columns: const [
                      DataColumn(label: Text("COMPLAINT ID")),
                      DataColumn(label: Text("COMPLAINT STATUS")),
                      DataColumn(label: Text("REMARKS")),
                      DataColumn(label: Text("COMPLAINT ASSIGNED")),
                      DataColumn(label: Text("COMPLAINT RESPONSE REASON")),
                    ],
rows: complaintStatus == null
    ? const [
        DataRow(cells: [
          DataCell(Text("No data found")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
        ]),
      ]
    : [
        DataRow(cells: [
          DataCell(Text(complaintStatus!.complaintId)),
          DataCell(Text(complaintStatus!.complaintStatus)),
          DataCell(Text(complaintStatus!.complaintRemarks)),
          DataCell(Text(
              complaintStatus!.complaintAssigned.isEmpty
                  ? "N/A"
                  : complaintStatus!.complaintAssigned)),
          DataCell(Text(complaintStatus!.complaintResponseReason)),
        ]),
      ],

                ),
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: const AppFooter(currentIndex: 4),
    );
  }

  /// 🔹 Widgets
 Widget _dropdownField(String hint) {
  return DropdownButtonFormField<String>(
    value: complaintType.isEmpty ? null : complaintType,
    items: complaintTypes
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ),
        )
        .toList(),
    onChanged: (value) {
      setState(() => complaintType = value ?? "");
    },
    decoration: InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}


 Widget _inputField(String hint) {
  return TextField(
    controller: complaintIdController,
    onChanged: (val) => complaintId = val,
    decoration: InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}


  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
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
