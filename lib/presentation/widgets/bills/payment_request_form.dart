import 'package:flutter/material.dart';
import '../../../data/models/biller_info_model.dart';
import 'customer_details_form.dart';

class PaymentRequestForm extends StatefulWidget {
  final BillerInfoModel billerInfo;
  final bool requireCustomerDetails;
  final int defaultAmount;
  final bool isAdhocBiller;

  const PaymentRequestForm({
    super.key,
    required this.billerInfo,
    required this.requireCustomerDetails,
    required this.defaultAmount,
    required this.isAdhocBiller,
  });

  @override
  PaymentRequestFormState createState() => PaymentRequestFormState();
}

class PaymentRequestFormState extends State<PaymentRequestForm> {
  final formKey = GlobalKey<FormState>();
  final customerKey = GlobalKey<CustomerDetailsFormState>();

  final _remitterController = TextEditingController();
  final _amountController = TextEditingController();
  final _remarksController = TextEditingController();

  String _paymentMode = 'Cash';
  bool _quickPay = false;
  bool _splitPay = false;

  bool validate() {
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) return false;

    if (widget.requireCustomerDetails) {
      return customerKey.currentState?.validate() ?? false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();

    // ✅ Prefill amount from bill-fetch
    _amountController.text = widget.defaultAmount.toString();
  }

  Map<String, dynamic> getData() {
    final data = <String, dynamic>{
      'remitterName': _remitterController.text,
      'paymentMode': _paymentMode,
      'quickPay': _quickPay ? 'Y' : 'N',
      'splitPay': _splitPay ? 'Y' : 'N',
      'amount': int.tryParse(_amountController.text) ?? 0,
      'remarks': _remarksController.text,
    };

    if (widget.requireCustomerDetails) {
      data['customerDetails'] = customerKey.currentState?.getData() ?? {};
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final paymentModes =
        widget.billerInfo.biller.billerPaymentModes.paymentModeList;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _remitterController,
            decoration: const InputDecoration(
              labelText: 'Remitter Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,

            /// 🔒 LOCK when NOT adhoc
            enabled: widget.isAdhocBiller,

            validator: (v) {
              if (v == null || v.isEmpty) return 'Amount required';
              return null;
            },

            decoration: InputDecoration(
              labelText: 'Amount',
              border: const OutlineInputBorder(),

              /// UX hint
              suffixIcon: widget.isAdhocBiller
                  ? const Icon(Icons.edit)
                  : const Icon(Icons.lock),
            ),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: _paymentMode,
            decoration: const InputDecoration(
              labelText: 'Payment Mode',
              border: OutlineInputBorder(),
            ),
            items: paymentModes
                .map(
                  (e) => DropdownMenuItem(
                    value: e.paymentModeName,
                    child: Text(e.paymentModeName),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => _paymentMode = v ?? 'Cash'),
          ),

          SwitchListTile(
            title: const Text('Quick Pay'),
            value: _quickPay,
            onChanged: (v) => setState(() => _quickPay = v),
          ),
          SwitchListTile(
            title: const Text('Split Pay'),
            value: _splitPay,
            onChanged: (v) => setState(() => _splitPay = v),
          ),

          TextFormField(
            controller: _remarksController,
            decoration: const InputDecoration(
              labelText: 'Remarks',
              border: OutlineInputBorder(),
            ),
          ),

          if (widget.requireCustomerDetails) ...[
            const SizedBox(height: 24),
            CustomerDetailsForm(
              key: customerKey,
              mode: CustomerFormMode.payment,
            ),
          ],
        ],
      ),
    );
  }
}
