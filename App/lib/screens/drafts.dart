// lib/screens/drafts.dart
import 'package:flutter/material.dart';

class DraftsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Drafts")),
      body: Center(
        child: Text(
          "Your drafts will appear here.",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
