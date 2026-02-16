import 'package:flutter/material.dart';
import '../../../data/models/biller_info_model.dart';
import '../../widgets/bills/bill_process_response_view.dart';
import '../../widgets/bills/payment_request_form.dart';
import '../../../data/models/bbps/bill_process/bill_process_result.dart';
import '../../../data/services/bill_payment_service.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final BillerInfoModel billerInfo;
  final Map<String, dynamic> billProcessResponse;
  final BillProcessResult billProcessResult;
  final Map<String, dynamic>? billProcessCustomerDetails;

  const PaymentScreen({
    super.key,
    required this.billerInfo,
    required this.billProcessResponse,
    required this.billProcessResult,
    this.billProcessCustomerDetails,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _paymentKey = GlobalKey<PaymentRequestFormState>();
  BillProcessService billProcessService = BillProcessService();

  static const Color _primary = Color(0xFF0033A0);
  static const Color _accent = Color(0xFF4B7BEC);
  static const Color _bg = Color(0xFFF5F7FB);

  static const String _spayLogo = "assets/images/logo_app_icon_white.png";
  static const String _bharatLogo =
      "assets/images/BharatConnectLogo_PNG.png";

  bool _isPaying = false;

  bool get _requireCustomerDetails {
    return widget.billerInfo.biller.billerFetchRequiremet.toUpperCase() ==
        'NOT_SUPPORTED';
  }

  Future<void> _onProceed() async {
    final form = _paymentKey.currentState;
    if (form == null || !form.validate()) return;

    final paymentData = form.getData();

    final Map<String, dynamic> customerData =
        widget.billProcessCustomerDetails ??
            (paymentData['customerDetails'] as Map<String, dynamic>? ?? {});

    final payload = {
      'billerId': widget.billerInfo.biller.billerId,
      'remitterName': paymentData['remitterName'],
      'customerMobile': customerData['customerMobile'],
      'customerEmail': customerData['customerEmail'],
      'customerPan': customerData['customerPan'],
      'customerAdhaar': customerData['customerAadhar'],
      'paymentMode': paymentData['paymentMode'],
      'quickPay': paymentData['quickPay'],
      'splitPay': paymentData['splitPay'],
      'remarks': paymentData['remarks'],
      // 'amount': paymentData['amount'] >0 ? 0 : paymentData['amount'],
      'amount': paymentData['amount'],
    };

    payload.removeWhere((k, v) => v == null || v.toString().isEmpty);

    setState(() => _isPaying = true);

    try {
      final res = await billProcessService.processPayment(payload);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(response: res),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: $e")),
      );
    } finally {
      if (mounted) setState(() => _isPaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,

      /// 🔵 PREMIUM APP BAR WITH SPAY LOGO
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Payment",
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset(
              _spayLogo,
              height: 36,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported, color: Colors.white),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔷 SUMMARY CARD WITH BHARAT CONNECT LOGO
            Container(
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
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.billerInfo.biller.billerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Review details before payment",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Bharat Connect Logo
                  Image.asset(
                    _bharatLogo,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            if (!_requireCustomerDetails)
              BillProcessResponseView(
                billProcessResponse: widget.billProcessResponse,
              ),

            const SizedBox(height: 16),

            PaymentRequestForm(
              key: _paymentKey,
              billerInfo: widget.billerInfo,
              requireCustomerDetails: _requireCustomerDetails,
              defaultAmount: widget.billProcessResult.billAmount,
              isAdhocBiller: widget.billerInfo.biller.billerAdhoc,
            ),

            const SizedBox(height: 20),

            /// 🔷 BEAUTIFUL GRADIENT BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [_primary, _accent],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                ),
                child: ElevatedButton.icon(
                  onPressed: _isPaying ? null : _onProceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                  ),
                  icon: _isPaying
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.lock_rounded),
                  label: Text(
                    _isPaying ? "Processing..." : "Proceed to Pay",
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}