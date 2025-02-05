import 'package:flutter/material.dart';
import 'add_manually.dart';
import '../database/database_helper.dart';

class AddItemsScreen extends StatefulWidget {
  final int transactionId;
  final double transactionAmount; // Add this field

  const AddItemsScreen({
    Key? key,
    required this.transactionId,
    required this.transactionAmount, // Add this parameter
  }) : super(key: key);

  @override
  _AddItemsScreenState createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> addedItems = [];
  List<Map<String, dynamic>> unsavedItems = []; // Track new unsaved items
  bool _isLoading = false;
  bool _hasNewItems = false;
  bool _isAmountMatched = false; // Track if amounts match

  double get _totalItemsAmount {
    return addedItems.fold(0.0, (sum, item) {
      return sum + ((item['quantity'] ?? 0) * (item['price'] ?? 0.0));
    });
  }


  @override
  void initState() {
    super.initState();
    _loadExistingBills();
  }

  void _checkAmountMatch() {
    setState(() {
      _isAmountMatched = (_totalItemsAmount - widget.transactionAmount).abs() < 0.01;
    });
  }

  Future<void> _loadExistingBills() async {
    setState(() => _isLoading = true);
    
    try {
      final bills = await _dbHelper.getBillsByTransactionId(widget.transactionId);
      if (mounted) {
        setState(() {
          addedItems = bills.map((bill) => {
            'name': bill['item'] ?? '',
            'quantity': bill['quantity'] ?? 0,
            'price': bill['price'] ?? 0.0,
          }).toList();
          _checkAmountMatch();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading bills: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _addItemManually() async {
    if (_isAmountMatched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction amount is matched. Cannot add more items.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddManuallyScreen(transactionId: widget.transactionId),
        ),
      );

      if (result != null) {
        final newItem = {
          'name': result['item'],
          'quantity': result['quantity'],
          'price': result['price'],
        };
        
        // Calculate new item's total and potential new sum
        double newItemTotal = (result['quantity'] as int) * (result['price'] as double);
        double potentialTotal = _totalItemsAmount + newItemTotal;

        // Check if the new total exceeds the transaction amount (with a small threshold)
        if (potentialTotal > widget.transactionAmount + 0.01) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cannot add item: Total would exceed transaction amount by \$${(potentialTotal - widget.transactionAmount).toStringAsFixed(2)}.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        setState(() {
          addedItems.add(newItem);
          unsavedItems.add(newItem);
          _hasNewItems = true;
          _checkAmountMatch();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding item: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }



  Future<void> saveList() async {
    if (unsavedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No new items to save')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Save items as before
      for (var item in unsavedItems) {
        final formattedItem = {
          'item': item['name'],
          'quantity': item['quantity'],
          'price': item['price'],
        };
        await _dbHelper.insertBill(formattedItem, widget.transactionId);
      }

      // Check if amounts match after saving
      _checkAmountMatch();
      
      // If amounts match and points haven't been added yet, add points
      if (_isAmountMatched && !(await _dbHelper.hasPointsForTransaction(widget.transactionId))) {
        final db = await _dbHelper.database;
        final transaction = await db.query(
          'transactions',
          where: 'transaction_id = ?',
          whereArgs: [widget.transactionId],
        );
        
        if (transaction.isNotEmpty) {
          final rewardPoints = transaction.first['reward_points'] as int;
          await _dbHelper.addPoints(widget.transactionId, rewardPoints);
        }
      }

      // Rest of your existing saveList code...
      setState(() {
        unsavedItems.clear();
        _hasNewItems = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Items saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Items"),
        actions: [
          // Add checkbox in AppBar
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isAmountMatched ? Colors.green : Colors.grey.shade300,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.check,
                    size: 20,
                    color: _isAmountMatched ? Colors.white : Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Transaction ID: ${widget.transactionId}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Transaction Amount: \$${widget.transactionAmount.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Total Items Amount: \$${_totalItemsAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: _isAmountMatched ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: addedItems.isEmpty
                    ? const Center(
                        child: Text('No items added yet'),
                      )
                    : ListView.builder(
                        itemCount: addedItems.length,
                        //
                        itemBuilder: (context, index) {
                          final item = addedItems[index];
                          final itemTotal = 
                              (item['quantity'] ?? 0) * (item['price'] ?? 0.0);
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            child: ListTile(
                              title: Text(item['name']?.toString() ?? 'Unknown Item'),
                              subtitle: Text(
                                'Quantity: ${item['quantity']?.toString() ?? '0'}, '
                                'Price: \$${(item['price'] ?? 0.0).toStringAsFixed(2)}\n'
                                'Total: \$${itemTotal.toStringAsFixed(2)}',
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isAmountMatched ? null : () {
                          // TODO: Implement barcode scanning
                        },
                        child: const Text("Barcode Scanning"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isAmountMatched ? null : _addItemManually,
                        child: const Text("Add Manually"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading || !_hasNewItems ? null : saveList,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hasNewItems 
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Save List"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}