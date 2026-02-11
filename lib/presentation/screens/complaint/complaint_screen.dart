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

  // Theme colors
  static const Color _primary = Color(0xFF0033A0);
  static const Color _accent = Color(0xFF4B7BEC);
  static const Color _bg = Color(0xFFF5F7FB);

  // Assets
  static const String _appLogo = "assets/images/logo_app_icon_white.png";
  static const String _bharatConnectLogo =
      "assets/images/BharatConnectLogo_PNG.png";

  @override
  void dispose() {
    complaintDescController.dispose();
    txnRefController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Complaint",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_primary, _accent],
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
                _appLogo,
                height: 40,
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            _complaintFormCard(),
            const SizedBox(height: 18),
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
          _sectionHeader(
            icon: Icons.assignment_rounded,
            title: "Transaction Complaint",
            subtitle: "Raise a complaint for your bill payment / transaction",
          ),
          const SizedBox(height: 16),

          _dropdownField(
            "Complaint Type *",
            ["Service", "Transaction", "Other"],
            complaintType,
            (val) => setState(() => complaintType = val ?? ''),
          ),
          const SizedBox(height: 14),

          _dropdownField(
            "Participation Type",
            ["BILLER", "AGENT", "Biller"],
            participationType,
            (val) => setState(() => participationType = val ?? ''),
          ),

          const SizedBox(height: 20),

          /// ✅ Complaint Reason header with Bharat Connect logo
          _titleRow(
            icon: Icons.chat_bubble_outline_rounded,
            title: "Complaint Reason",
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  _bharatConnectLogo,
                  height: 24,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),

          const SizedBox(height: 14),

          _dropdownField(
            "Complaint Disposition *",
            [
              "Bill Paid but Amount not adjusted or still showing due amount",
              "Failed",
              "Pending",
            ],
            complaintDisposition,
            (val) => setState(() => complaintDisposition = val ?? ''),
          ),

          const SizedBox(height: 14),
          _textAreaField("Enter complaint details...", complaintDescController),

          const SizedBox(height: 14),
          _textField(
            hint: "Enter Txn Ref ID *",
            controller: txnRefController,
            prefixIcon: Icons.receipt_long_rounded,
          ),

          const SizedBox(height: 20),

          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _submitComplaint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 102, 128, 214),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.green.shade200,
                  disabledForegroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(
                  isLoading ? "Submitting..." : "Submit Complaint",
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitComplaint() async {
    if (complaintType.isEmpty ||
        complaintDisposition.isEmpty ||
        txnRefController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields (*)")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final request = ComplaintRequest(
        complaintType: complaintType,
        participationType:
            participationType.isEmpty ? "N/A" : participationType,
        agentId: "N/A",
        billerId: "N/A",
        servReason: "N/A",
        complainDesc: complaintDescController.text.trim(),
        txnRefId: txnRefController.text.trim(),
        complaintDisposition: complaintDisposition,
      );

      await complaintService.registerComplaintModel(request);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complaint submitted successfully!")),
      );

      setState(() {
        complaintType = '';
        participationType = '';
        complaintDisposition = '';
        complaintDescController.clear();
        txnRefController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit complaint: $e")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// ================= TRANSACTION TABLE =================
  Widget _transactionHistoryCard() {
    final txns = [
      {
        "id": "TXN12345",
        "date": "12/09/2025",
        "amount": "₹1,200",
        "status": "Success"
      },
      {
        "id": "TXN12346",
        "date": "13/09/2025",
        "amount": "₹500",
        "status": "Pending"
      },
      {
        "id": "TXN12347",
        "date": "14/09/2025",
        "amount": "₹850",
        "status": "Failed"
      },
    ];

    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.history_rounded,
            title: "Transaction History",
            subtitle: "Select a transaction and raise a complaint",
          ),
          const SizedBox(height: 14),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE6EDF8)),
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F8FE),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE6EDF8)),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(flex: 3, child: _HeaderCell("Txn ID")),
                      Expanded(flex: 3, child: _HeaderCell("Date")),
                      Expanded(flex: 2, child: _HeaderCell("Amount")),
                      Expanded(flex: 2, child: _HeaderCell("Status")),
                    ],
                  ),
                ),
                ...List.generate(txns.length, (i) {
                  final t = txns[i];
                  final bool alt = i.isOdd;

                  return InkWell(
                    onTap: () {
                      txnRefController.text = (t["id"] ?? "").toString();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Txn selected: ${t["id"]}")),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: alt ? const Color(0xFFFBFCFF) : Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: i == txns.length - 1
                                ? Colors.transparent
                                : const Color(0xFFE6EDF8),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              (t["id"] ?? "").toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text((t["date"] ?? "").toString()),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              (t["amount"] ?? "").toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child:
                                  _statusChip((t["status"] ?? "").toString()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Tip: Tap a transaction row to auto-fill Txn Ref ID.",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    final s = status.toLowerCase().trim();

    Color bg;
    Color fg;
    IconData icon;

    if (s == "success") {
      bg = const Color(0xFFE8F7EE);
      fg = const Color(0xFF1B7A3A);
      icon = Icons.check_circle_rounded;
    } else if (s == "pending") {
      bg = const Color(0xFFFFF6E5);
      fg = const Color(0xFF9A6B00);
      icon = Icons.timelapse_rounded;
    } else {
      bg = const Color(0xFFFFE9E9);
      fg = const Color(0xFFB42318);
      icon = Icons.cancel_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= COMMON UI =================
  Widget _cardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFFE9EEF7)),
      ),
      child: child,
    );
  }

  Widget _sectionHeader({
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade700,
                    height: 1.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _titleRow({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.black87, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
        ),
        const Spacer(),
        if (trailing != null) trailing,
      ],
    );
  }

  InputDecoration _inputDecoration(String labelOrHint, {IconData? prefixIcon}) {
    const borderColor = Color(0xFFE3EAF6);

    return InputDecoration(
      labelText: labelOrHint,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      filled: true,
      fillColor: const Color(0xFFF7F9FE),
      prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primary, width: 1.2),
      ),
    );
  }

  /// ✅ FIXED dropdown: no height jump, ellipsis, standard look always
  Widget _dropdownField(
    String label,
    List<String> items,
    String value,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value.isEmpty ? null : value,
      isExpanded: true,
      isDense: true,
      menuMaxHeight: 320,
      selectedItemBuilder: (context) {
        return items.map((e) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              e,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList();
      },
      items: items
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: _inputDecoration(label),
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
    );
  }

  Widget _textField({
    required String hint,
    required TextEditingController controller,
    IconData? prefixIcon,
  }) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        decoration: _inputDecoration(hint, prefixIcon: prefixIcon),
      ),
    );
  }

  Widget _textAreaField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLines: 4,
      decoration: _inputDecoration(hint),
    );
  }
}

/// Small header cell widget for table header
class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w900,
        color: Color(0xFF1F2A37),
      ),
    );
  }
}