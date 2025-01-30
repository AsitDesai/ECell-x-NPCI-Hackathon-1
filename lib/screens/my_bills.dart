// lib/screens/my_bills.dart
import 'package:flutter/material.dart';

class MyBillsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Bills")),
      body: Center(
        child: Text(
          "Here are your saved bills.",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
