import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'add_items.dart';

class CreateBillScreen extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> _fetchLatestTransactions() async {
    final db = await dbHelper.database;
    // Fetch the latest 5 transactions where reward_points > 0
    final List<Map<String, dynamic>> transactions = await db.query(
      'transactions',
      where: 'reward_points > ?',
      whereArgs: [0],
      orderBy: 'date DESC',
      limit: 5,
    );
    return transactions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Bill"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Create your bill here.",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchLatestTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No eligible transactions found.'));
                  } else {
                    final transactions = snapshot.data!;
                    return ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        
                        // Convert amount to double safely
                        final double transactionAmount = 
                            double.tryParse(transaction['amount'].toString()) ?? 0.0;
                        
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Checkbox(
                              value: false, // You can manage the state of the checkbox here
                              onChanged: (bool? value) {
                                // Handle checkbox state change
                              },
                            ),
                            title: Text(
                              'Transaction ID: ${transaction['transaction_id']}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Amount: \$${transactionAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Date: ${transaction['date']}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddItemsScreen(
                                      transactionId: transaction['transaction_id'],
                                      transactionAmount: transactionAmount, // Add the amount here
                                    ),
                                  ),
                                );
                              },
                            ),
                            isThreeLine: true, // Give more space for the three lines of content
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
      ),
    );
  }
}