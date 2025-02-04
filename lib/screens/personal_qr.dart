import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../user_data.dart';

class PersonalQrScreen extends StatefulWidget {
  @override
  _PersonalQrScreenState createState() => _PersonalQrScreenState();
}

class _PersonalQrScreenState extends State<PersonalQrScreen> {
  String? upiId;

  @override
  void initState() {
    super.initState();
    _loadUpiId();
  }

  Future<void> _loadUpiId() async {
    final loadedUpiId = await UserData.loadUpiId();
    if (mounted) {
      setState(() {
        upiId = loadedUpiId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal QR'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: upiId == null
              ? CircularProgressIndicator() // Show loading while fetching UPI ID
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          QrImageView(
                            data: upiId!,
                            version: QrVersions.auto,
                            size: 200.0,
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Your UPI ID is:',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            upiId!,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ... rest of your UI code
                  ],
                ),
        ),
      ),
    );
  }
}