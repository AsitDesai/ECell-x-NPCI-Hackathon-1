// lib/screens/current_points.dart
import 'package:flutter/material.dart';

class CurrentPointsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Current Points")),
      body: Center(
        child: Text(
          "You have 150 points!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
