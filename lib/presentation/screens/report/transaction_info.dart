import 'package:flutter/material.dart';

class TransactionInfo extends StatelessWidget {
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
    required this.id
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Transaction Details"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
                // ================= ICON =================
                CircleAvatar(
                  radius: 36,
                  backgroundColor: isCredit
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  child: Icon(
                    isCredit
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    size: 32,
                    color: isCredit ? Colors.green : Colors.red,
                  ),
                ),

                const SizedBox(height: 16),

                // ================= AMOUNT =================
                Text(
                  amount.isNotEmpty ? amount : '₹0',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isCredit ? Colors.green : Colors.red,
                  ),
                ),

                const SizedBox(height: 8),

                const Divider(height: 32),
                _infoRow("Category", title),
                _infoRow("Sub title", subtitle),
                _infoRow("Request ID", id),
                _infoRow("Date", date),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= INFO ROW =================
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
