import 'package:flutter/material.dart';
import '../../widgets/app_sidebar.dart';
import '../../widgets/app_footer.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Support'),
        backgroundColor: Colors.blue,
      ),
      drawer: const AppSidebar(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                const Text(
                  "Review Transaction Activity",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                /// Transaction ID
                _inputField(
                  hint: "Transaction Reference Id / Request Id",
                ),

                const SizedBox(height: 16),

                /// OR Divider
                Center(
                  child: Text(
                    "OR",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Mobile Number
                _inputField(
                  hint: "Mobile Number",
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 16),

                /// Date Pickers
                Row(
                  children: [
                    Expanded(
                      child: _dateField(context, "mm/dd/yyyy"),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dateField(context, "mm/dd/yyyy"),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// Check Status Button
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4F46E5),
                        Color(0xFF06B6D4),
                      ],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      "Check Status",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// Clear Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B5563),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Clear",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: const AppFooter(currentIndex: 4),
    );
  }

  /// 🔹 Input Field
  Widget _inputField({
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// 🔹 Date Picker Field
  Widget _dateField(BuildContext context, String hint) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: const Icon(Icons.calendar_today, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onTap: () async {
        await showDatePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          initialDate: DateTime.now(),
        );
      },
    );
  }
}
