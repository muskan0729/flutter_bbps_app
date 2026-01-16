import 'package:flutter/material.dart';
import '../../../data/services/app_lock_service.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  bool _authenticating = false;

  @override
  void initState() {
    super.initState();
    _startAuth();
  }

  Future<void> _startAuth() async {
    setState(() => _authenticating = true);

    final success = await AppLockService().authenticate();

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _authenticating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _authenticating
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _startAuth,
                child: const Text('Unlock'),
              ),
      ),
    );
  }
}
