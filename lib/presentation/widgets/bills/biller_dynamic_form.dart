import 'package:flutter/material.dart';
import '../../../data/models/bbps/input_param_model.dart';

class BillerDynamicForm extends StatefulWidget {
  final List<InputParamGroup> inputGroups;

  const BillerDynamicForm({super.key, required this.inputGroups});

  @override
  State<BillerDynamicForm> createState() => BillerDynamicFormState();
}

class BillerDynamicFormState extends State<BillerDynamicForm> {
  final formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (final group in widget.inputGroups) {
      for (final param in group.paramsList) {
        _controllers[param.paramName ?? ''] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  bool validate() => formKey.currentState?.validate() ?? false;

  Map<String, String> getData() {
    final data = <String, String>{};
    _controllers.forEach((k, v) => data[k] = v.text);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Biller Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...widget.inputGroups.expand(
            (group) => group.paramsList.map(_buildField),
          ),
        ],
      ),
    );
  }

  Widget _buildField(InputParam param) {
    if (param.visible == false) return const SizedBox.shrink();

    // Dropdown
    if (param.values != null && param.values!.isNotEmpty) {
      final items = param.values!.split(',');

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: param.paramName,
            border: const OutlineInputBorder(),
          ),
          items: items
              .map((v) => DropdownMenuItem(value: v, child: Text(v)))
              .toList(),
          validator: param.isOptional
              ? null
              : (v) => v == null ? 'Required' : null,
          onChanged: (value) {
            _controllers[param.paramName]?.text = value ?? '';
          },
        ),
      );
    }

    // Text field
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: _controllers[param.paramName],
        decoration: InputDecoration(
          labelText: param.paramName,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (!param.isOptional && (value == null || value.isEmpty)) {
            return 'Required';
          }
          if (param.minLength != null &&
              value != null &&
              value.length < param.minLength!) {
            return 'Min ${param.minLength} characters';
          }
          if (param.maxLength != null &&
              value != null &&
              value.length > param.maxLength!) {
            return 'Max ${param.maxLength} characters';
          }
          if (param.regEx != null &&
              value != null &&
              !RegExp(param.regEx!).hasMatch(value)) {
            return 'Invalid format';
          }
          return null;
        },
      ),
    );
  }
}
