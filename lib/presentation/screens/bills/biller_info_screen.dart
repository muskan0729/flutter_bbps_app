import 'package:flutter/material.dart';
import '../../../data/models/biller_info_model.dart';
import '../../../data/services/biller_service.dart';
import '../../widgets/bills/customer_details_form.dart';
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

  // Theme colors
  static const Color _primary = Color(0xFF0033A0);
  static const Color _accent = Color(0xFF4B7BEC);
  static const Color _bg = Color(0xFFF5F7FB);

  // Assets
  static const String _appLogo = "assets/images/logo_app_icon_white.png";

  bool get _shouldShowCustomerForm {
    final requirement = _billerInfo?.biller.billerFetchRequiremet.toUpperCase();
    return requirement == 'MANDATORY' || requirement == 'OPTIONAL';
  }

  bool _loading = true;
  bool _processing = false;
  BillerInfoModel? _billerInfo;

  @override
  void initState() {
    super.initState();
    _fetchBillerInfo();
  }

  Future<void> _fetchBillerInfo() async {
    try {
      final info = await _billerService.getBillerInfo(widget.billerId);
      if (!mounted) return;
      setState(() {
        _billerInfo = info;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _billerInfo = null;
        _loading = false;
      });
    }
  }

  Future<void> _onProceed() async {
    if (_processing) return;

    final billerState = _billerFormKey.currentState;
    final customerState = _customerFormKey.currentState;

    if (billerState == null) return;

    final isBillerValid = billerState.validate();
    final isCustomerValid =
        _shouldShowCustomerForm ? (customerState?.validate() ?? false) : true;

    if (!isBillerValid || !isCustomerValid) {
      debugPrint('❌ Validation failed');
      return;
    }

    final billerParams = billerState.getData();

    final payload = <String, dynamic>{
      'billerId': _billerInfo!.biller.billerId,
      ...billerParams,
    };

    Map<String, dynamic>? customerData;
    if (_shouldShowCustomerForm) {
      customerData = customerState!.getData();
      if (customerData['customerMobile']?.isNotEmpty == true) {
        payload['customerMobile'] = customerData['customerMobile'];
      }
    }

    setState(() => _processing = true);

    try {
      final response = await _billProcessService.processBill(payload);

      final decrypted = response['result']?['decryptedResponse'];
      final billProcessResult = BillProcessResult.fromApi(decrypted);
      final responseCode = decrypted?['responseCode'];

      if (response['status'] == true && responseCode == '000') {
        if (!mounted) return;
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
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final billerName = _billerInfo?.biller.billerName ?? "Biller";

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          billerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_primary, _accent],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Image.asset(
                _appLogo,
                height: 36,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported, color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _billerInfo == null
              ? Center(
                  child: _cardWrapper(
                    child: Row(
                      children: [
                        Icon(Icons.error_outline_rounded,
                            color: Colors.red.shade700),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            "Failed to fetch biller info. Please try again.",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 850),
                      child: Column(
                        children: [
                          if (_shouldShowCustomerForm) ...[
                            _cardWrapper(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _sectionHeader(
                                    icon: Icons.person_rounded,
                                    title: "Customer Details",
                                    subtitle: "Fill details for bill fetch/process",
                                  ),
                                  const SizedBox(height: 14),
                                  CustomerDetailsForm(
                                    key: _customerFormKey,
                                    mode: CustomerFormMode.billProcess,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          _cardWrapper(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionHeader(
                                  icon: Icons.receipt_long_rounded,
                                  title: "Biller Details",
                                  subtitle: "Enter biller required fields",
                                ),
                                const SizedBox(height: 14),

                                BillerDynamicForm(
                                  key: _billerFormKey,
                                  inputGroups:
                                      _billerInfo!.biller.billerInputParams,
                                ),

                                const SizedBox(height: 18),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    height: 48,
                                    child: ElevatedButton.icon(
                                      onPressed: _processing ? null : _onProceed,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 102, 128, 214),
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor:
                                            const Color(0xFF93C5FD),
                                        disabledForegroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 0,
                                      ),
                                      icon: _processing
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            )
                                          : const Icon(Icons.arrow_forward_rounded),
                                      label: Text(
                                        _processing ? "Processing..." : "Proceed",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  /// ================= COMMON UI =================
  Widget _cardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFFE9EEF7)),
      ),
      child: child,
    );
  }

  Widget _sectionHeader({
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade700,
                    height: 1.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}