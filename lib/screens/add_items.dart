import 'package:flutter/material.dart';
import 'add_manually.dart';
import '../database/database_helper.dart';

class AddItemsScreen extends StatefulWidget {
  final int transactionId;

  const AddItemsScreen({
    Key? key,
    required this.transactionId,
  }) : super(key: key);

  @override
  _AddItemsScreenState createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> addedItems = [];
  bool _isLoading = false;
  bool _hasNewItems = false;  // Track if new items have been added

  @override
  void initState() {
    super.initState();
    _loadExistingBills();
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
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddManuallyScreen(transactionId: widget.transactionId),
        ),
      );

      // If an item was successfully added
      if (result != null) {
        setState(() => _hasNewItems = true);
        await _loadExistingBills();
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
    if (!_hasNewItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one item before saving'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Save each item with the transaction ID
      for (var item in addedItems) {
        final formattedItem = {
          'item': item['name'],
          'quantity': item['quantity'],
          'price': item['price'],
        };
        await _dbHelper.insertBill(formattedItem, widget.transactionId);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('List saved successfully')),
        );
        setState(() => _hasNewItems = false);  // Reset the flag after successful save
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving list: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Items"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Transaction ID: ${widget.transactionId}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: addedItems.isEmpty
                    ? const Center(
                        child: Text('No items added yet'),
                      )
                    : ListView.builder(
                        itemCount: addedItems.length,
                        itemBuilder: (context, index) {
                          final item = addedItems[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            child: ListTile(
                              title: Text(item['name']?.toString() ?? 'Unknown Item'),
                              subtitle: Text(
                                'Quantity: ${item['quantity']?.toString() ?? '0'}, '
                                'Price: \$${(item['price'] ?? 0.0).toStringAsFixed(2)}',
                              ),
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
                        onPressed: _isLoading ? null : () {
                          // TODO: Implement barcode scanning
                        },
                        child: const Text("Barcode Scanning"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _addItemManually,
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
                        onPressed: _isLoading ? null : saveList,
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