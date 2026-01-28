import 'package:flutter/material.dart';

class BillProcessResponseView extends StatelessWidget {
  final Map<String, dynamic> billProcessResponse;

  const BillProcessResponseView({super.key, required this.billProcessResponse});

  @override
  Widget build(BuildContext context) {
    final response = billProcessResponse['result']?['decryptedResponse'] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text(
        //   'Bill Details',
        //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        // ),
        // const SizedBox(height: 12),

        // SelectableText(
        //   response.toString(),
        //   style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
        // ),
      ],
    );
  }
}
