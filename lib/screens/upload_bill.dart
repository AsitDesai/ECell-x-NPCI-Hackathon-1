// lib/screens/upload_bill.dart
import 'package:flutter/material.dart';

class UploadBillScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Bill")),
      body: Center(
        child: Text(
          "Upload your bill here.",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
