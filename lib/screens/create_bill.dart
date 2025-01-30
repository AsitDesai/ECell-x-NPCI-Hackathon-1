// lib/screens/create_bill.dart
import 'package:flutter/material.dart';

class CreateBillScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Bill")),
      body: Center(
        child: Text(
          "Create your bill here.",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
