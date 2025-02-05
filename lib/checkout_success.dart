import 'package:flutter/material.dart';

class CheckoutSuccess extends StatelessWidget {
  static const String id = 'checkout_success';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Payment completed successfully!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'home');
              },
              child: const Text('Go to Homepage'),
            ),
          ],
        ),
      ),
    );
  }
}
