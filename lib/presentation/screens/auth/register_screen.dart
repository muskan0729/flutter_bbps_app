import 'package:flutter/material.dart';
import '../../screens/home/home_screen.dart';
import '../../../data/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailOtpController = TextEditingController();
  final _mobileOtpController = TextEditingController();

  bool _isLoading = false;
  AuthService apiService = AuthService();

  bool emailSent = false;
  bool emailVerified = false;
  bool mobileSent = false;
  bool mobileVerified = false;

  int emailTime = 30;
  int mobileTime = 30;

  String emailError = '';
  String mobileError = '';
  String registerError = '';

  /* ================= TIMERS ================= */
  void _startEmailTimer() {
    if (emailTime > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() => emailTime--);
        _startEmailTimer();
      });
    }
  }

  void _startMobileTimer() {
    if (mobileTime > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() => mobileTime--);
        _startMobileTimer();
      });
    }
  }

  /* ================= EMAIL ================= */
  void _sendEmailOtp() async {
    setState(() {
      emailError = '';
      _isLoading = true;
    });
    try {
      await apiService.sendEmailOtp(_emailController.text);
      setState(() {
        emailSent = true;
        _isLoading = false;
      });
      _startEmailTimer();
    } catch (e) {
      setState(() {
        emailError = e.toString();
        _isLoading = false;
      });
    }
  }

  void _verifyEmailOtp() async {
    if (emailTime <= 0) {
      setState(() => emailError = 'OTP expired. Please resend.');
      return;
    }
    setState(() => _isLoading = true);
    try {
      final response =
          await apiService.verifyEmailOtp(_emailController.text, _emailOtpController.text);
      setState(() {
        emailVerified = response['verified'] == true;
        emailError = emailVerified ? '' : 'Invalid OTP';
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        emailError = 'Invalid OTP';
        _isLoading = false;
      });
    }
  }

  /* ================= MOBILE ================= */
  void _sendMobileOtp() async {
    setState(() {
      mobileError = '';
      _isLoading = true;
    });
    try {
      await apiService.sendMobileOtp(_mobileController.text);
      setState(() {
        mobileSent = true;
        _isLoading = false;
      });
      _startMobileTimer();
    } catch (e) {
      setState(() {
        mobileError = e.toString();
        _isLoading = false;
      });
    }
  }

  void _verifyMobileOtp() async {
    if (mobileTime <= 0) {
      setState(() => mobileError = 'OTP expired. Please resend.');
      return;
    }
    setState(() => _isLoading = true);
    try {
      final response =
          await apiService.verifyMobileOtp(_mobileController.text, _mobileOtpController.text);
      setState(() {
        mobileVerified = response['verified'] == true;
        mobileError = mobileVerified ? '' : 'Invalid OTP';
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        mobileError = 'Invalid OTP';
        _isLoading = false;
      });
    }
  }

  /* ================= REGISTER ================= */
 void _registerUser() async {
  setState(() {
    _isLoading = true;
    registerError = '';
  });

  try {
    final response = await apiService.registerNew(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _mobileController.text.trim(),
    );

    print("REGISTER RESPONSE: ${response.toString()}");

    // Check if registration is successful by checking the 'registered' field in the response body
    if (response['registered'] == true) {
      // Redirect to Dashboard or Home Screen after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()), // Replace with your actual Dashboard screen
      );
    } else {
      setState(() {
        registerError = response['message'] ?? 'Registration failed';
      });
    }
  } catch (e) {
    print("Error in registerNew: $e");
    setState(() {
      registerError = e.toString();
    });
  } finally {
    setState(() => _isLoading = false);
  }
}


  /* ================= UI ================= */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  Image.asset('assets/images/bharatconnect.png', height: 90),
                  const SizedBox(height: 16),
                  const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Verify email & mobile to continue",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 32),
                  _card(children: _buildFields()),
                  if (registerError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child:
                          Text(registerError, style: const TextStyle(color: Colors.red)),
                    ),
                  const SizedBox(height: 16),
                  if (emailVerified && mobileVerified)
                    _primaryBtn("Register", _registerUser),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFields() {
    List<Widget> fields = [];

    fields.add(_inputField(
      "Full Name",
      Icons.person,
      _nameController,
      enabled: !(emailVerified && mobileVerified),
      verified: (emailVerified && mobileVerified),
    ));

    fields.add(const SizedBox(height: 16));

    fields.add(_inputField(
      "Email Address",
      Icons.email,
      _emailController,
      enabled: !emailVerified,
      verified: emailVerified,
    ));

    fields.add(const SizedBox(height: 16));

    if (!emailVerified) {
      fields.add(emailSent
          ? _otpBlock(
              controller: _emailOtpController,
              onVerify: _verifyEmailOtp,
              error: emailError,
              time: emailTime,
              resend: _sendEmailOtp,
              label: "Verify Email OTP",
            )
          : _primaryBtn("Send Email OTP", _sendEmailOtp));
    }

    if (emailVerified) {
      fields.add(const SizedBox(height: 16));
      fields.add(_inputField(
        "Mobile Number",
        Icons.phone,
        _mobileController,
        enabled: !mobileVerified,
        verified: mobileVerified,
      ));

      fields.add(const SizedBox(height: 16));

      if (!mobileVerified) {
        fields.add(mobileSent
            ? _otpBlock(
                controller: _mobileOtpController,
                onVerify: _verifyMobileOtp,
                error: mobileError,
                time: mobileTime,
                resend: _sendMobileOtp,
                label: "Verify Mobile OTP",
              )
            : _primaryBtn("Send Mobile OTP", _sendMobileOtp));
      }
    }

    return fields;
  }

  /* ================= REUSABLE UI ================= */
  Widget _card({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _inputField(
    String hint,
    IconData icon,
    TextEditingController controller, {
    bool enabled = true,
    bool verified = false,
  }) {
    return Stack(
      children: [
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF1F3F6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (verified)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              child: const Icon(Icons.verified, color: Colors.green),
            ),
          ),
      ],
    );
  }

  Widget _primaryBtn(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 27, 86, 173),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _otpBlock({
    required TextEditingController controller,
    required VoidCallback onVerify,
    required String error,
    required int time,
    required VoidCallback resend,
    required String label,
  }) {
    return Column(
      children: [
        _inputField("Enter OTP", Icons.lock, controller),
        const SizedBox(height: 12),
        _primaryBtn(label, onVerify),
        if (error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(error, style: const TextStyle(color: Colors.red)),
          ),
        TextButton(
          onPressed: time > 0 ? null : resend,
          child: Text(time > 0 ? 'Resend in $time sec' : 'Resend OTP'),
        ),
      ],
    );
  }
}
