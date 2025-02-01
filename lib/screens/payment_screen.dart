import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/vendor.dart';

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
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Vendor? _vendor;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkVendor();
  }

  Future<void> _checkVendor() async {
    // Extract UPI ID from QR data
    final upiUri = Uri.parse(widget.qrData);
    final upiId = upiUri.queryParameters['pa'];

    if (upiId != null) {
      final vendor = await _dbHelper.getVendorByUpiId(upiId);
      setState(() {
        _vendor = vendor;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (_vendor != null) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Vendor Details',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            SizedBox(height: 8),
                            Text('Name: ${_vendor!.name}'),
                            Text('Type: ${_vendor!.type}'),
                            Text('Points Eligible: ${_getPointsMultiplier()}x'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ] else
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Vendor not registered in our system'),
                      ),
                    ),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
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
                          TextFormField(
                            controller: _pinController,
                            decoration: InputDecoration(
                              labelText: 'Enter PIN',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
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
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Handle payment logic
                              }
                            },
                            child: Text('Proceed to Payment'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  double _getPointsMultiplier() {
    switch (_vendor?.type) {
      case 'small':
        return 2.0;
      case 'medium':
        return 1.5;
      case 'big':
        return 1.0;
      default:
        return 0.0;
    }
  }
}