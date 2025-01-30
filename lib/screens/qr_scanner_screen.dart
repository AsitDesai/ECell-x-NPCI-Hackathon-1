import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'payment_screen.dart'; // Ensure this import is correct

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String qrResult = "Scan a QR Code";
  bool _isNavigating = false; // Flag to prevent multiple navigations
  MobileScannerController _scannerController = MobileScannerController(); // Add a controller

  @override
  void dispose() {
    _scannerController.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  void _handleScannedData(String scannedData) {
    if (_isNavigating) return; // Prevent multiple navigations

    setState(() {
      qrResult = scannedData;
    });

    print("Scanned Data: $scannedData"); // Debugging the scanned data

    if (scannedData.startsWith("upi://")) {
      _isNavigating = true; // Set flag to true to prevent multiple navigations

      // Stop the scanner to avoid further scans
      _scannerController.stop();

      print("Navigating to PaymentScreen..."); // Debugging navigation

      // Navigate to PaymentScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(qrData: scannedData),
        ),
      ).then((_) {
        print("Returned from PaymentScreen"); // Debugging return
        _isNavigating = false; // Reset flag after navigation is complete
        _scannerController.start(); // Restart the scanner after returning
      });
    } else {
      print("Invalid QR code or no UPI data found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code Scanner')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 400,
            child: MobileScanner(
              controller: _scannerController, // Use the controller
              onDetect: (capture) {
                for (final barcode in capture.barcodes) {
                  final String? scannedData = barcode.rawValue;

                  if (scannedData != null) {
                    _handleScannedData(scannedData);
                    break; // Exit after the first valid scan
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            qrResult,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the scanner screen
            },
            child: const Text('Close Scanner'),
          ),
        ],
      ),
    );
  }
}