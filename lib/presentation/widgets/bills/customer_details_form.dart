import 'package:flutter/material.dart';

enum CustomerFormMode { billProcess, payment }

class CustomerDetailsForm extends StatefulWidget {
  final CustomerFormMode mode;
  const CustomerDetailsForm({super.key, required this.mode});

  @override
  CustomerDetailsFormState createState() => CustomerDetailsFormState();
}

class CustomerDetailsFormState extends State<CustomerDetailsForm> {
  final formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _panController = TextEditingController();
  final _aadharController = TextEditingController();

  bool validate() => formKey.currentState?.validate() ?? false;

  Map<String, dynamic> getData() {
    final data = <String, dynamic>{};
    void addIfNotEmpty(String key, String? value) {
      if (value != null && value.isNotEmpty) {
        data[key] = value;
      }
    }

    addIfNotEmpty('customerMobile', _mobileController.text);
    addIfNotEmpty('customerEmail', _emailController.text);
    addIfNotEmpty('customerPan', _panController.text);
    addIfNotEmpty('customerAadhar', _aadharController.text);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Details', // Consistent title regardless of mode
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _field(
            controller: _mobileController,
            label: 'Mobile Number',
            keyboard: TextInputType.phone,
            validator: (v) =>
                v == null || v.length != 10 ? 'Enter valid mobile' : null,
          ),
          const SizedBox(height: 12),
          _field(
            controller: _emailController,
            label: 'Email',
            keyboard: TextInputType.emailAddress,
            validator: (v) => v != null && v.isNotEmpty && !v.contains('@')
                ? 'Invalid email'
                : null,
          ),
          const SizedBox(height: 12),
          _field(controller: _panController, label: 'PAN'),
          const SizedBox(height: 12),
          _field(
            controller: _aadharController,
            label: 'Aadhaar',
            keyboard: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      validator: validator,
    );
  }
}
