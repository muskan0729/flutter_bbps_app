import 'package:flutter/material.dart';
import '../../../data/models/biller_info_model.dart';
import '../../../data/services/biller_service.dart';
import '../../widgets/bills/customer_details_form.dart';
import '../../widgets/bills/biller_info_raw_view.dart';
import '../../widgets/bills/biller_dynamic_form.dart';
import '../../../data/services/bill_process_service.dart';
import 'payment_screen.dart';
import '../../../data/models/bbps/bill_process/bill_process_result.dart';

class BillerInfoScreen extends StatefulWidget {
  final String billerId;

  const BillerInfoScreen({super.key, required this.billerId});

  @override
  State<BillerInfoScreen> createState() => _BillerInfoScreenState();
}

class _BillerInfoScreenState extends State<BillerInfoScreen> {
  final BillerService _billerService = BillerService();
  final BillProcessService _billProcessService = BillProcessService();
  final _customerFormKey = GlobalKey<CustomerDetailsFormState>();
  final _billerFormKey = GlobalKey<BillerDynamicFormState>();

  bool get _shouldShowCustomerForm {
    final requirement = _billerInfo?.biller.billerFetchRequiremet.toUpperCase();

    return requirement == 'MANDATORY' || requirement == 'OPTIONAL';
  }

  bool _loading = true;
  BillerInfoModel? _billerInfo;

  @override
  void initState() {
    super.initState();
    _fetchBillerInfo();
  }

  Future<void> _fetchBillerInfo() async {
    final info = await _billerService.getBillerInfo(widget.billerId);
    setState(() {
      _billerInfo = info;
      _loading = false;
    });
  }

  Future<void> _onProceed() async {
    final billerState = _billerFormKey.currentState;
    final customerState = _customerFormKey.currentState;

    if (billerState == null) return;

    final isBillerValid = billerState.validate();
    final isCustomerValid = _shouldShowCustomerForm
        ? customerState?.validate() ?? false
        : true;

    if (!isBillerValid || !isCustomerValid) {
      debugPrint('❌ Validation failed');
      return;
    }

    final billerParams = billerState.getData();

    final payload = <String, dynamic>{
      'billerId': _billerInfo!.biller.billerId,
      ...billerParams, // flatten biller params
    };

    // 🔑 IMPORTANT: inject customerMobile if available
    Map<String, dynamic>? customerData;

    if (_shouldShowCustomerForm) {
      customerData = customerState!.getData();

      if (customerData['customerMobile']?.isNotEmpty == true) {
        payload['customerMobile'] = customerData['customerMobile'];
      }
    }

    try {
      final response = await _billProcessService.processBill(payload);

      debugPrint('✅ BBPS API SUCCESS');
      debugPrint(response.toString());

      /// ✅ SAFETY CHECK
      final decrypted = response['result']?['decryptedResponse'];
      final billProcessResult = BillProcessResult.fromApi(decrypted);
      final responseCode = decrypted?['responseCode'];

      if (response['status'] == true && responseCode == '000') {
        if (!mounted) return;
        print('Data sent to PaymentScreen: Biller info  \n $_billerInfo ,');
        debugPrint(' biller response  \n $response.toString() biller process\n,$billProcessResult ,\n cust data $customerData');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentScreen(
              billerInfo: _billerInfo!,
              billProcessResponse: response,
              billProcessResult: billProcessResult,
              billProcessCustomerDetails: customerData,
            ),
          ),
        );
      } else {
        throw Exception(decrypted?['responseReason'] ?? 'Bill process failed');
      }
    } catch (e) {
      debugPrint('❌ BBPS API FAILED');
      debugPrint(e.toString());

      final errorMessage = e.toString().replaceFirst('Exception: ', '');

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_billerInfo?.biller.billerName ?? 'Biller'),
        backgroundColor: const Color.fromARGB(255, 95, 110, 143),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _billerInfo == null
          ? const Center(child: Text('Failed to fetch biller info'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_shouldShowCustomerForm) ...[
                    CustomerDetailsForm(
                      key: _customerFormKey,
                      mode: CustomerFormMode.billProcess,
                    ),
                    const SizedBox(height: 24),
                  ],
                  const SizedBox(height: 24),
                  BillerDynamicForm(
                    key: _billerFormKey,
                    inputGroups: _billerInfo!.biller.billerInputParams,
                  ),
                  ElevatedButton(
                    onPressed: _onProceed,
                    child: const Text('Proceed'),
                  ),

                  const Divider(),
                  const SizedBox(height: 12),
                  BillerInfoRawView(billerInfo: _billerInfo!),
                ],
              ),
            ),
    );
  }
}
