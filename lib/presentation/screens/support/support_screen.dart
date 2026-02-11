import 'package:flutter/material.dart';
import '../../widgets/app_sidebar.dart';
import '../../widgets/app_footer.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  // Theme colors
  static const Color _primary = Color(0xFF0033A0);
  static const Color _accent = Color(0xFF4B7BEC);
  static const Color _bg = Color(0xFFF5F7FB);

  // Assets
  static const String _appLogo = "assets/images/logo_app_icon_white.png";
  static const String _bharatConnectLogo =
      "assets/images/BharatConnectLogo_PNG.png";

  final TextEditingController txnIdController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  DateTime? fromDate;
  DateTime? toDate;

  @override
  void dispose() {
    txnIdController.dispose();
    mobileController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) {
    // dd/MM/yyyy (India standard)
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return "$dd/$mm/$yyyy";
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final initial = isFrom ? (fromDate ?? now) : (toDate ?? now);

    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: now,
      initialDate: initial,
    );

    if (picked == null) return;

    setState(() {
      if (isFrom) {
        fromDate = picked;
        fromDateController.text = _fmt(picked);
      } else {
        toDate = picked;
        toDateController.text = _fmt(picked);
      }
    });
  }

  void _clear() {
    setState(() {
      txnIdController.clear();
      mobileController.clear();
      fromDateController.clear();
      toDateController.clear();
      fromDate = null;
      toDate = null;
    });
  }

  void _checkStatus() {
    // TODO: Call your API here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Check Status clicked")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Support",
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
                _cardWrapper(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(
                        icon: Icons.support_agent_rounded,
                        title: "Review Transaction Activity",
                        subtitle: "Search by Txn Ref / Request ID or Mobile + Date",
                        trailing: Image.asset(
                          _bharatConnectLogo,
                          height: 26,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const SizedBox(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _textField(
                        hint: "Transaction Reference Id / Request Id",
                        controller: txnIdController,
                        prefixIcon: Icons.receipt_long_rounded,
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                        ],
                      ),

                      const SizedBox(height: 14),

                      _textField(
                        hint: "Mobile Number",
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_rounded,
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: _dateField(
                              hint: "From Date",
                              controller: fromDateController,
                              onTap: () => _pickDate(isFrom: true),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _dateField(
                              hint: "To Date",
                              controller: toDateController,
                              onTap: () => _pickDate(isFrom: false),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: _checkStatus,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 102, 128, 214),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                icon: const Icon(Icons.manage_search_rounded),
                                label: const Text(
                                  "Check Status",
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            height: 48,
                            child: OutlinedButton.icon(
                              onPressed: _clear,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF374151),
                                side: const BorderSide(color: Color(0xFFE3EAF6)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text(
                                "Clear",
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Optional: Result/Info card placeholder (keeps UI premium)
                _cardWrapper(
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: Colors.grey.shade700),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Enter details above and tap Check Status to view results.",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
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

  Widget _textField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    IconData? prefixIcon,
  }) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: _inputDecoration(hint, prefixIcon: prefixIcon),
      ),
    );
  }

  Widget _dateField({
    required String hint,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: _inputDecoration(hint, prefixIcon: Icons.calendar_today_rounded)
            .copyWith(
          suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
      ),
    );
  }
}