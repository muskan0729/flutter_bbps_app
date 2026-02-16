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

  final List<String> complaintTypes = ["Transaction"];

  final ComplaintStatusService complaintStatusService = ComplaintStatusService();

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
    complaintIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Check Complaint",
          style: TextStyle(fontWeight: FontWeight.bold),
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

        /// ✅ Header logo (right)
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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                _checkFormCard(),
                const SizedBox(height: 16),
                _statusCard(),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: const AppFooter(currentIndex: 3),
    );
  }

  /// ==================== TOP CARD (FORM) ====================
  Widget _checkFormCard() {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.search_rounded,
            title: "Check Complaint Status",
            subtitle: "Track your complaint using Complaint ID",
            trailing: Image.asset(
              _bharatConnectLogo,
              height: 26,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
          ),
          const SizedBox(height: 16),

          _dropdownField(
            label: "Complaint Type *",
            items: complaintTypes,
            value: complaintType,
            onChanged: (v) => setState(() => complaintType = v ?? ""),
          ),
          const SizedBox(height: 14),

          _textField(
            hint: "Enter Complaint ID *",
            controller: complaintIdController,
            prefixIcon: Icons.confirmation_number_rounded,
            onChanged: (val) => complaintId = val,
          ),

          const SizedBox(height: 18),

          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _checkStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF93C5FD),
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
                    : const Icon(Icons.manage_search_rounded),
                label: Text(
                  isLoading ? "Checking..." : "Check Status",
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkStatus() async {
    final id = complaintIdController.text.trim();
    complaintId = id;

    if (complaintType.isEmpty || id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields (*)")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final request = ComplaintStatusRequest(
        complaintType: complaintType,
        complaintId: id,
      );

      final response = await complaintStatusService.statusComplaintmodel(request);

      setState(() {
        complaintStatus = response;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complaint status checked!")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to check complaint status: $e")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// ==================== STATUS CARD (TABLE) ====================
  Widget _statusCard() {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.table_chart_rounded,
            title: "Complaint Status",
            subtitle: "Latest status details will appear here",
          ),
          const SizedBox(height: 14),

          _statusTable(),
        ],
      ),
    );
  }

  Widget _statusTable() {
    // If no data, show empty-state row
    if (complaintStatus == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE6EDF8)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: Colors.grey.shade700),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "No data found. Please enter Complaint Type and Complaint ID, then tap Check Status.",
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
          ],
        ),
      );
    }

    final cs = complaintStatus!;

    // Modern table UI (like your previous transaction table)
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6EDF8)),
      ),
      child: Column(
        children: [
          // Header row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                Expanded(flex: 3, child: _HeaderCell("COMPLAINT ID")),
                Expanded(flex: 3, child: _HeaderCell("STATUS")),
                Expanded(flex: 3, child: _HeaderCell("REMARKS")),
                Expanded(flex: 3, child: _HeaderCell("ASSIGNED")),
                Expanded(flex: 4, child: _HeaderCell("RESPONSE REASON")),
              ],
            ),
          ),

          // Body row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 980, // keeps columns aligned
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        cs.complaintId,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _statusChip(cs.complaintStatus),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        cs.complaintRemarks,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        cs.complaintAssigned.isEmpty
                            ? "N/A"
                            : cs.complaintAssigned,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        cs.complaintResponseReason,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ==================== COMMON UI ====================
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
    Widget? trailing,
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
        if (trailing != null) ...[
          const SizedBox(width: 12),
          trailing,
        ],
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

  /// ✅ Fixed dropdown: standard height + ellipsis
  Widget _dropdownField({
    required String label,
    required List<String> items,
    required String value,
    required Function(String?) onChanged,
  }) {
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
    Function(String)? onChanged,
  }) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: _inputDecoration(hint, prefixIcon: prefixIcon),
      ),
    );
  }

  Widget _statusChip(String status) {
    final s = status.toLowerCase().trim();

    Color bg;
    Color fg;
    IconData icon;

    if (s.contains("success") || s.contains("resolved") || s.contains("closed")) {
      bg = const Color(0xFFE8F7EE);
      fg = const Color(0xFF1B7A3A);
      icon = Icons.check_circle_rounded;
    } else if (s.contains("pending") || s.contains("in progress") || s.contains("processing")) {
      bg = const Color(0xFFFFF6E5);
      fg = const Color(0xFF9A6B00);
      icon = Icons.timelapse_rounded;
    } else {
      bg = const Color(0xFFFFE9E9);
      fg = const Color(0xFFB42318);
      icon = Icons.info_rounded;
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
            status.isEmpty ? "N/A" : status,
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
}

/// Header cell for modern table header
class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w900,
        color: Color(0xFF1F2A37),
      ),
    );
  }
}


