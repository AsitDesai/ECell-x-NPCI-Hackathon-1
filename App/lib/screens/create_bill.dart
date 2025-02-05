import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'add_items.dart';

class CreateBillScreen extends StatefulWidget {
  const CreateBillScreen({Key? key}) : super(key: key);

  @override
  _CreateBillScreenState createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  late Future<List<Map<String, dynamic>>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    _transactionsFuture = _fetchLatestTransactions();
  }

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

  /// Build a checkbox that reflects whether the bills for this transaction are matched.
  Widget _buildTransactionCheckbox(int transactionId, double transactionAmount) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dbHelper.getBillsByTransactionId(transactionId),
      builder: (context, snapshot) {
        bool isMatched = false;
        if (snapshot.hasData) {
          final bills = snapshot.data!;
          final double totalBillsAmount = bills.fold(0.0, (sum, bill) {
            final int quantity = bill['quantity'] ?? 0;
            final double price =
                double.tryParse(bill['price'].toString()) ?? 0.0;
            return sum + (quantity * price);
          });
          // Consider the amounts equal if the difference is less than 0.01
          isMatched = (totalBillsAmount - transactionAmount).abs() < 0.01;
        }
        return Checkbox(
          value: isMatched,
          onChanged: null, // Disabled, as this is only an indicator.
          activeColor: Colors.green,
        );
      },
    );
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
                future: _transactionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No eligible transactions found.'));
                  } else {
                    final transactions = snapshot.data!;
                    return ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];

                        // Safely convert amount to double
                        final double transactionAmount =
                            double.tryParse(transaction['amount'].toString()) ??
                                0.0;
                        final int transactionId = transaction['transaction_id'];

                        return Card(
                          margin:
                              const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            // Display the checkbox that indicates match status
                            leading: _buildTransactionCheckbox(
                                transactionId, transactionAmount),
                            title: Text(
                              'Transaction ID: $transactionId',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                                // Navigate to AddItemsScreen.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddItemsScreen(
                                      transactionId: transactionId,
                                      transactionAmount: transactionAmount,
                                    ),
                                  ),
                                ).then((_) {
                                  // When returning from AddItemsScreen, refresh the UI.
                                  setState(() {
                                    _loadTransactions();
                                  });
                                });
                              },
                            ),
                            isThreeLine: true,
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
