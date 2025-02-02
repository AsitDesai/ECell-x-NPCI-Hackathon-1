import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; // Import sqflite package
import '../database/database_helper.dart'; // Import DatabaseHelper

class DatabaseManagementScreen extends StatelessWidget {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Function to clear a table
  Future<void> _clearTable(BuildContext context, String tableName) async {
    final Database db = await _dbHelper.database;
    await db.delete(tableName);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Table $tableName cleared!")),
    );
  }

  // Function to fetch and display table data
  Future<void> _viewTableData(BuildContext context, String tableName) async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> data = await db.query(tableName);

    // Show the data in a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Data in $tableName"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.map((row) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: row.entries.map((entry) {
                  return Text("${entry.key}: ${entry.value}");
                }).toList(),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Database Management"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // View Table Buttons
            ElevatedButton(
              onPressed: () => _viewTableData(context, 'vendors'),
              child: Text('View Vendors Table'),
            ),
            ElevatedButton(
              onPressed: () => _viewTableData(context, 'phones'),
              child: Text('View Phones Table'),
            ),
            ElevatedButton(
              onPressed: () => _viewTableData(context, 'transactions'),
              child: Text('View Transactions Table'),
            ),
            SizedBox(height: 20), // Add some spacing

            // Clear Table Buttons
            ElevatedButton(
              onPressed: () => _clearTable(context, 'vendors'),
              child: Text('Clear Vendors Table'),
            ),
            ElevatedButton(
              onPressed: () => _clearTable(context, 'phones'),
              child: Text('Clear Phones Table'),
            ),
            ElevatedButton(
              onPressed: () => _clearTable(context, 'transactions'),
              child: Text('Clear Transactions Table'),
            ),
          ],
        ),
      ),
    );
  }
}