import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class CurrentPointsScreen extends StatelessWidget {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Current Points")),
      body: Center(
        child: FutureBuilder<int>(
          future: _dbHelper.getTotalPoints(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            return Text(
              "You have ${snapshot.data ?? 0} points!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
    );
  }
}