// lib/models/transaction_model.dart

class TransactionModel {
  final String title;
  final String description;
  final double amount;
  final String date;

  TransactionModel({
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
  });

  /// Create TransactionModel from JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : (json['amount'] as double? ?? 0.0),
      date: json['date'] ?? '',
    );
  }

  /// Convert TransactionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'date': date,
    };
  }
}
