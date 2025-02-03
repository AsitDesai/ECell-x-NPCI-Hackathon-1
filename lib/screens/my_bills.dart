import 'package:flutter/material.dart';
import '../database/database_helper.dart'; // Adjust the import path as needed

class MyBillsScreen extends StatefulWidget {
  @override
  _MyBillsScreenState createState() => _MyBillsScreenState();
}

class _MyBillsScreenState extends State<MyBillsScreen> {
  List<Map<String, dynamic>> _groupedTransactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  Future<void> _loadBills() async {
    try {
      final DatabaseHelper dbHelper = DatabaseHelper();
      final List<Map<String, dynamic>> transactions = await dbHelper.getAllTransactions();
      
      // Group bills by transaction
      List<Map<String, dynamic>> groupedTransactions = [];
      
      for (var transaction in transactions) {
        final int transactionId = transaction['transaction_id'];
        final List<Map<String, dynamic>> bills = 
          await dbHelper.getBillsByTransactionId(transactionId);
        
        // Calculate total transaction amount
        double totalAmount = bills.fold(0, (sum, bill) => sum + (bill['price'] * bill['quantity']));
        
        groupedTransactions.add({
          'transaction_id': transactionId,
          'date': transaction['date'],
          'sender_upi_id': transaction['sender_upi_id'],
          'receiver_upi_id': transaction['receiver_upi_id'],
          'total_amount': totalAmount,
          'bills': bills,
        });
      }

      setState(() {
        _groupedTransactions = groupedTransactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading bills: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter out transactions with zero total amount
    final nonZeroTransactions = _groupedTransactions.where((transaction) => transaction['total_amount'] != 0).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("My Bills"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadBills,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : nonZeroTransactions.isEmpty
              ? Center(
                  child: Text(
                    "No bills found.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: nonZeroTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = nonZeroTransactions[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      child: ExpansionTile(
                        title: Text(
                          'Transaction on ${transaction['date']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Total: \$${transaction['total_amount'].toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.green),
                        ),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: transaction['bills'].length,
                            itemBuilder: (context, billIndex) {
                              final bill = transaction['bills'][billIndex];
                              return ListTile(
                                title: Text(bill['item']),
                                subtitle: Text(
                                  'Qty: ${bill['quantity']} | Price: \$${bill['price'].toStringAsFixed(2)}',
                                ),
                                trailing: Text(
                                  'Subtotal: \$${(bill['price'] * bill['quantity']).toStringAsFixed(2)}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Sender: ${transaction['sender_upi_id']}'),
                                Text('Receiver: ${transaction['receiver_upi_id']}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}