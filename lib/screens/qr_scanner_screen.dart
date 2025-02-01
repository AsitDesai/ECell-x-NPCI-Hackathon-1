import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  @override
  _QrScannerScreenState createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isNavigating = false; // Prevent multiple navigations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
        actions: [
          IconButton(
            icon: Icon(Icons.flash_on),
            onPressed: () => cameraController.toggleTorch(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            String? qrData = barcode.rawValue;
            if (qrData != null && !_isNavigating) {
              // Check if it's a valid UPI QR code
              if (qrData.startsWith("upi://")) {
                setState(() {
                  _isNavigating = true; // Prevent further scans during navigation
                });

                // Navigate to the payment screen with the QR data
                Navigator.pushReplacementNamed(context, '/payment', arguments: qrData).then((_) {
                  setState(() {
                    _isNavigating = false; // Reset navigation flag after returning from payment screen
                  });
                });
              } else {
                // If the QR is not a UPI code, show a message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('This is not a valid UPI QR code.')),
                );
              }
              break; // Exit after the first valid scan
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}