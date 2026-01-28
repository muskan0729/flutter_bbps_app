import 'package:flutter/material.dart';
import '../../../data/models/biller_info_model.dart';
import '../../widgets/bills/bill_process_response_view.dart';
import '../../widgets/bills/payment_request_form.dart';
import '../../../data/models/bbps/bill_process/bill_process_result.dart';

class PaymentScreen extends StatefulWidget {
  final BillerInfoModel billerInfo;
  final Map<String, dynamic> billProcessResponse;
  final BillProcessResult billProcessResult;

  /// ✅ customer details captured during bill-process (if any)
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

  bool get _requireCustomerDetails {
    return widget.billerInfo.biller.billerFetchRequiremet.toUpperCase() ==
        'NOT_SUPPORTED';
  }

  // void _onProceed() {
  //   final form = _paymentKey.currentState;
  //   if (form == null || !form.validate()) return;

  //   final paymentData = form.getData();

  //   final payload = <String, dynamic>{
  //     'billerId': widget.billerInfo.biller.billerId,

  //     /// required by API
  //     'remitterName': paymentData['remitterName'],
  //     'customerMobile': widget.billProcessResult.inputParams['Mobile Number'],
  //     'customerEmail': '',
  //     'customerAdhaar': '',
  //     'customerPan': '',

  //     /// payment fields (FLAT)
  //     'paymentMode': paymentData['paymentMode'],
  //     'quickPay': paymentData['quickPay'],
  //     'splitPay': paymentData['splitPay'],
  //     'remarks': paymentData['remarks'],

  //     /// required for amount validation
  //     'amount': paymentData['amount'],
  //   };

  //   debugPrint('📤 FINAL API PAYLOAD');
  //   debugPrint(payload.toString());
  // }

  void _onProceed() {
    final form = _paymentKey.currentState;
    if (form == null || !form.validate()) return;

    final paymentData = form.getData();

    /// 🔑 Decide customer source
    final Map<String, dynamic> customerData =
        widget.billProcessCustomerDetails ??
        (paymentData['customerDetails'] as Map<String, dynamic>? ?? {});

    final payload = <String, dynamic>{
      'billerId': widget.billerInfo.biller.billerId,

      /// remitter
      'remitterName': paymentData['remitterName'],

      /// customer identity (ALWAYS REQUIRED FOR PAYMENT)
      'customerMobile': customerData['customerMobile'],
      'customerEmail': customerData['customerEmail'],
      'customerPan': customerData['customerPan'],
      'customerAdhaar': customerData['customerAadhar'],

      /// payment
      'paymentMode': paymentData['paymentMode'],
      'quickPay': paymentData['quickPay'],
      'splitPay': paymentData['splitPay'],
      'remarks': paymentData['remarks'],

      /// amount
      'amount': paymentData['amount'],
    };

    /// remove empty values
    payload.removeWhere((_, v) => v == null || v.toString().isEmpty);

    debugPrint('📤 FINAL API PAYLOAD');
    debugPrint(payload.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_requireCustomerDetails) ...[
              BillProcessResponseView(
                billProcessResponse: widget.billProcessResponse,
              ),
              const SizedBox(height: 24),
            ],

            PaymentRequestForm(
              key: _paymentKey,
              billerInfo: widget.billerInfo,
              requireCustomerDetails: _requireCustomerDetails,
              defaultAmount: widget.billProcessResult.billAmount,
              isAdhocBiller: widget.billerInfo.biller.billerAdhoc,
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _onProceed,
              child: const Text('Proceed to Pay'),
            ),
          ],
        ),
      ),
    );
  }
}
