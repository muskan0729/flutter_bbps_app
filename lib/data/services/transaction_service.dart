// lib/services/transaction_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/config.dart';
import '../models/transaction_model.dart';

class TransactionService {
  /// Fetch transactions from API
  Future<List<TransactionModel>> fetchTransactions() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/transactions'),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => TransactionModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch transactions. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching transactions: $e");
      return []; // Return empty list on error
    }
  }

  /// Dummy transactions (for testing without API)
  Future<List<TransactionModel>> getDummyTransactions() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      TransactionModel(
        title: 'Groceries',
        description: 'Payment for groceries',
        amount: 50.75,
        date: '2023-12-01',
      ),
      TransactionModel(
        title: 'Rent',
        description: 'Monthly rent payment',
        amount: 1200.00,
        date: '2023-12-01',
      ),
      TransactionModel(
        title: 'Phone Bill',
        description: 'Payment for phone bill',
        amount: 30.50,
        date: '2023-12-05',
      ),
      TransactionModel(
        title: 'Coffee',
        description: 'Coffee at cafe',
        amount: 5.25,
        date: '2023-12-07',
      ),
      TransactionModel(
        title: 'Shopping',
        description: 'Shopping online',
        amount: 150.00,
        date: '2023-12-10',
      ),
    ];
  }
}
