// lib/screens/create_bill.dart
import 'package:flutter/material.dart';
import '../database/database_helper.dart'; // Import your DatabaseHelper
import 'add_items.dart'; // Import the new AddItemsScreen

class CreateBillScreen extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> _fetchLatestTransactions() async {
    final db = await dbHelper.database;
    // Fetch the latest 5 transactions where reward_points > 0
    final List<Map<String, dynamic>> transactions = await db.query(
      'transactions',
      where: 'reward_points > ?', // Filter transactions where reward_points > 0
      whereArgs: [0],
      orderBy: 'date DESC',
      limit: 5,
    );
    return transactions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Bill")),
      body: Column(
        children: [
          Text(
            "Create your bill here.",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchLatestTransactions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No eligible transactions found.'));
                } else {
                  final transactions = snapshot.data!;
                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return ListTile(
                        leading: Checkbox(
                          value: false, // You can manage the state of the checkbox here
                          onChanged: (bool? value) {
                            // Handle checkbox state change
                          },
                        ),
                        title: Text('Transaction ID: ${transaction['transaction_id']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Amount: ${transaction['amount']}'),
                            Text('Date: ${transaction['date']}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddItemsScreen(),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}