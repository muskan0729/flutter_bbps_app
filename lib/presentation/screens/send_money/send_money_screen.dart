import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart'; // Assuming you have predefined colors
import '../../widgets/app_footer.dart'; // Importing the footer widget

class SendMoneyScreen extends StatelessWidget {
  const SendMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Assuming you have a background color defined

      /// 🔹 App Bar
      appBar: AppBar(
        title: const Text(
          "Send Money",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 98, 134, 211), // Consistent color with other screens
        elevation: 0,
      ),

      /// 🔹 Page Body
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Sender & Receiver Details Section (Premium Style)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    // Receiver Field
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Receiver",
                        labelStyle: TextStyle(color: AppColors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Amount Field
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Amount",
                        labelStyle: TextStyle(color: AppColors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    // Pay Button
                    ElevatedButton(
                      onPressed: () {
                        // Handle Pay action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary, // Custom button color
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Pay",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      /// 🔹 FOOTER (Bottom Navigation)
      bottomNavigationBar: const AppFooter(currentIndex: 1), // Assuming SendMoney is the 2nd tab
    );
  }

  /// 🔹 Card Decoration for Premium Look
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}
