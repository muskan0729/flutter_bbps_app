import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(transaction.title),
      trailing: Text(
        "₹${transaction.amount}",
        style: TextStyle(
          color: transaction.amount < 0 ? Colors.red : Colors.green,
        ),
      ),
    );
  }
}
