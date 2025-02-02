import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';

class DatabaseManagementScreen extends StatelessWidget {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Function to clear a table
  Future<void> _clearTable(BuildContext context, String tableName) async {
    // Show confirmation dialog before clearing
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Clear Table"),
        content: Text("Are you sure you want to clear the $tableName table?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Clear", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if (!confirmed) return;

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
            children: [
              if (data.isEmpty)
                Text("No data found in $tableName"),
              ...data.map((row) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: row.entries.map((entry) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            "${entry.key}: ${entry.value}",
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }).toList(),
            ],
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "View Tables",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
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
                  ElevatedButton(
                    onPressed: () => _viewTableData(context, 'bills'),
                    child: Text('View Bills Table'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Clear Tables",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () => _clearTable(context, 'vendors'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100],
                    ),
                    child: Text('Clear Vendors Table'),
                  ),
                  ElevatedButton(
                    onPressed: () => _clearTable(context, 'phones'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100],
                    ),
                    child: Text('Clear Phones Table'),
                  ),
                  ElevatedButton(
                    onPressed: () => _clearTable(context, 'transactions'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100],
                    ),
                    child: Text('Clear Transactions Table'),
                  ),
                  ElevatedButton(
                    onPressed: () => _clearTable(context, 'bills'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100],
                    ),
                    child: Text('Clear Bills Table'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}