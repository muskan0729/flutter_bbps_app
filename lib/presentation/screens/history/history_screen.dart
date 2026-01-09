import 'package:flutter/material.dart';
import '../../../data/services/transaction_service.dart';
import '../../widgets/transaction_tile.dart';
import '../../widgets/app_footer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/transaction_model.dart';
import '../../widgets/app_sidebar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<TransactionModel> transactions = [];
  List<TransactionModel> filteredTransactions = [];
  String searchQuery = '';
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  // Fetch transactions from API or load dummy data
  Future<void> _loadTransactions() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final allTransactions = await TransactionService().fetchTransactions();

      if (allTransactions.isEmpty) {
        print('No transactions found. Loading dummy data.');
        await _loadDummyTransactions();
      } else {
        setState(() {
          transactions = allTransactions;
          filteredTransactions = transactions;
        });
      }
    } catch (e) {
      print('Error loading transactions: $e');
      await _loadDummyTransactions();
      setState(() {
        hasError = true; // Optional: indicate that API failed
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Load dummy transactions
  Future<void> _loadDummyTransactions() async {
    final dummyTransactions = await TransactionService().getDummyTransactions();
    setState(() {
      transactions = dummyTransactions;
      filteredTransactions = dummyTransactions;
    });
    print('Dummy Data Loaded: $dummyTransactions');
  }

  // Filter transactions based on search query
  void _filterTransactions(String query) {
    setState(() {
      searchQuery = query;
      filteredTransactions = transactions
          .where((transaction) =>
              transaction.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

    print('Filtered Transactions: $filteredTransactions');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // App Bar
      appBar: AppBar(
        title: const Text(
          "Transactions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 98, 134, 211),
        elevation: 0,
      ),

      // Sidebar Drawer
      drawer: const AppSidebar(),

      // Body
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Page Title
            const Text(
              "Transaction History",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0033A0),
              ),
            ),
            const SizedBox(height: 16),

            // Search Bar
            TextField(
              onChanged: _filterTransactions,
              decoration: InputDecoration(
                hintText: "Search transactions...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Transaction List / Loading / Error
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredTransactions.isEmpty
                      ? Center(
                          child: Text(
                            hasError
                                ? "Failed to load transactions. Showing dummy data."
                                : "No transactions found",
                            style: const TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredTransactions.length,
                          itemBuilder: (_, index) {
                            final transaction = filteredTransactions[index];
                            return TransactionTile(transaction: transaction);
                          },
                        ),
            ),
          ],
        ),
      ),

      // Footer
      bottomNavigationBar: const AppFooter(currentIndex: 2),
    );
  }
}
