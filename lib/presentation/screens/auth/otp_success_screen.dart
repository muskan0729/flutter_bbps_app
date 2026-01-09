import 'package:flutter/material.dart';

class OtpSuccessScreen extends StatelessWidget {
  const OtpSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration Successful')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Your registration was successful!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the next page or dashboard
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
                child: Text('Go to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
