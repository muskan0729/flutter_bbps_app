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

  @override
  void initState() {
    super.initState();

    paymentResponse = widget.response['response'] ?? {};

    amount =
        (double.tryParse(paymentResponse['respAmount']?.toString() ?? '0') ??
            0) /
            100;

    inputParams = List<Map<String, dynamic>>.from(
      paymentResponse['inputParams']?['input'] ?? [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Payment Successful",
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
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              try {
                await shareReceipt.shareTransaction(
                  screenshotController: screenshotController,
                  transactionId:
                  paymentResponse['txnRefId']?.toString() ?? '',
                );
              } catch (e) {
                debugPrint('Share error: $e');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          /// ✅ Screenshot Area (WHITE background)
          Expanded(
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                color: Colors.white, // <-- important
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Success Icon
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Payment Completed',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        '₹ ${amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Details Card
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _row(
                                  'Status',
                                  paymentResponse['responseReason']),
                              _row(
                                  'Customer Name',
                                  paymentResponse[
                                  'respCustomerName']),
                              _row(
                                  'Transaction ID',
                                  paymentResponse['txnRefId']),
                              _row(
                                  'Approval Ref No',
                                  paymentResponse[
                                  'approvalRefNumber']),
                              if (paymentResponse['respBillDate'] !=
                                  null &&
                                  paymentResponse['respBillDate']
                                      .toString()
                                      .isNotEmpty)
                                _row(
                                  'Bill Date',
                                  paymentResponse['respBillDate'],
                                ),
                              if (paymentResponse['respDueDate'] !=
                                  null &&
                                  paymentResponse['respDueDate']
                                      .toString()
                                      .isNotEmpty)
                                _row(
                                  'Due Date',
                                  paymentResponse['respDueDate'],
                                ),
                              if (inputParams.isNotEmpty)
                                const Divider(),
                              ...inputParams.map(
                                    (item) => _row(
                                  item['paramName']
                                      ?.toString() ??
                                      'N/A',
                                  item['paramValue'],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// ❌ Not part of screenshot
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 16,
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

  Widget _row(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          Flexible(
            child: Text(
              value?.toString() ?? '-',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
