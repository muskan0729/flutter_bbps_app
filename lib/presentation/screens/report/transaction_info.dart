import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import '../../../core/utils/share_receipt.dart';

class TransactionInfo extends StatefulWidget {
  final String title;
  final String subtitle;
  final String amount;
  final String date;
  final bool isCredit;
  final String id;

  const TransactionInfo({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.isCredit,
    required this.id,
  });

  @override
  State<TransactionInfo> createState() => _TransactionInfoState();
}

class _TransactionInfoState extends State<TransactionInfo> {
  final ScreenshotController screenshotController = ScreenshotController();
  final ShareReceipt shareReceipt = ShareReceipt();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Spay Wallet",
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
                  transactionId: widget.id,
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to share receipt'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Screenshot(
          controller: screenshotController,
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: widget.isCredit
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    child: Icon(
                      widget.isCredit
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      size: 32,
                      color:
                      widget.isCredit ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.amount.isNotEmpty ? widget.amount : '₹0',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color:
                      widget.isCredit ? Colors.green : Colors.red,
                    ),
                  ),
                  const Divider(height: 32),
                  _infoRow("Category", widget.title),
                  _infoRow("Sub title", widget.subtitle),
                  _infoRow("Request ID", widget.id),
                  _infoRow("Date", widget.date),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
