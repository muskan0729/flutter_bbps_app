
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import '../../../core/utils/share_receipt.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final Map<String, dynamic> response;

  const PaymentSuccessScreen({
    super.key,
    required this.response,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  final ShareReceipt shareReceipt = ShareReceipt();
  final ScreenshotController screenshotController = ScreenshotController();

  late Map<String, dynamic> paymentResponse;
  late double amount;
  late List<Map<String, dynamic>> inputParams;

  // ✅ Theme (same as your app)
  static const Color _primary = Color(0xFF0033A0);
  static const Color _accent = Color(0xFF4B7BEC);
  static const Color _bg = Color(0xFFF5F7FB);

  // ✅ Logos
  static const String _spayLogo = "assets/images/logo_app_icon_white.png";
  static const String _bharatLogo = "assets/images/BharatConnectLogo_PNG.png";

  @override
  void initState() {
    super.initState();

    paymentResponse = widget.response['response'] ?? {};

    amount =
        (double.tryParse(paymentResponse['respAmount']?.toString() ?? '0') ?? 0) /
            100;

    inputParams = List<Map<String, dynamic>>.from(
      paymentResponse['inputParams']?['input'] ?? [],
    );
  }

  Future<void> _share() async {
    try {
      await shareReceipt.shareTransaction(
        screenshotController: screenshotController,
        transactionId: paymentResponse['txnRefId']?.toString() ?? '',
      );
    } catch (e) {
      debugPrint('Share error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Share failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final txnId = paymentResponse['txnRefId']?.toString() ?? '-';
    final status = paymentResponse['responseReason']?.toString() ?? 'Success';

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Payment Successful",
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Image.asset(
                _spayLogo,
                height: 34,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: _share,
            tooltip: "Share receipt",
          ),
        ],
      ),
      body: Column(
        children: [
          /// ✅ Screenshot Area (only receipt part)
          Expanded(
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                color: Colors.white, // important for receipt background
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 650),
                      child: Column(
                        children: [
                          /// ✅ Top Branding Row (Spay + Bharat Connect)
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          colors: [
                                            _primary.withOpacity(0.15),
                                            _accent.withOpacity(0.12),
                                          ],
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.receipt_long_rounded,
                                        color: _primary,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "SPay Receipt",
                                          style: TextStyle(
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF1F2A37),
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          "Payment Confirmation",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF6B7280),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                _bharatLogo,
                                height: 28,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const SizedBox(),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          /// ✅ Success Badge
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE8F7EE),
                            ),
                            child: const Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xFF1B7A3A),
                              size: 56,
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            "Payment Completed",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF111827),
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "₹ ${amount.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1B7A3A),
                            ),
                          ),

                          const SizedBox(height: 14),

                          /// ✅ Txn Chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F8FE),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: const Color(0xFFE6EDF8)),
                            ),
                            child: Text(
                              "Txn ID: $txnId",
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: _primary,
                                fontSize: 12.5,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// ✅ Details Card (premium)
                          _cardWrapper(
                            child: Column(
                              children: [
                                _row("Status", status),
                                _row("Customer Name",
                                    paymentResponse['respCustomerName']),
                                _row("Transaction ID",
                                    paymentResponse['txnRefId']),
                                _row("Approval Ref No",
                                    paymentResponse['approvalRefNumber']),
                                if ((paymentResponse['respBillDate'] ?? "")
                                    .toString()
                                    .isNotEmpty)
                                  _row("Bill Date", paymentResponse['respBillDate']),
                                if ((paymentResponse['respDueDate'] ?? "")
                                    .toString()
                                    .isNotEmpty)
                                  _row("Due Date", paymentResponse['respDueDate']),
                                if (inputParams.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  const Divider(height: 1),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Additional Details",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  ...inputParams.map(
                                    (item) => _row(
                                      item['paramName']?.toString() ?? 'N/A',
                                      item['paramValue'],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          /// ✅ Footer note (inside screenshot)
                          Text(
                            "Thank you for using SPay. Keep this receipt for your records.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// ✅ Bottom buttons (NOT in screenshot)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _share,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _primary,
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.share_rounded),
                      label: const Text(
                        "Share",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [_primary, _accent],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Done",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9EEF7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _row(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF6B7280),
                fontSize: 12.5,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 7,
            child: Text(
              value?.toString() ?? '-',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}