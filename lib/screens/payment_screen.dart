import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final String qrData;

  PaymentScreen({required this.qrData});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text('Scanned QR Data: ${widget.qrData}'),
              SizedBox(height: 20),
              // Amount input field
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Enter Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // PIN input field
              TextFormField(
                controller: _pinController,
                decoration: InputDecoration(
                  labelText: 'Enter PIN',
                  border: OutlineInputBorder(),
                ),
                obscureText: true, // Hide the PIN input
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your PIN';
                  }
                  if (value.length != 4) {
                    return 'PIN should be 4 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Proceed button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final amount = _amountController.text;
                    final pin = _pinController.text;
                    // Handle payment logic here with amount and pin
                    print('Proceeding with payment of ₹$amount with PIN: $pin');
                    // You can replace the print statement with actual payment logic
                  }
                },
                child: Text('Proceed to Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}