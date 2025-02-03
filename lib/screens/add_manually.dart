import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../database/database_helper.dart';

class AddManuallyScreen extends StatefulWidget {
  final int transactionId;

  const AddManuallyScreen({super.key, required this.transactionId});

  @override
  AddManuallyScreenState createState() => AddManuallyScreenState();
}

class AddManuallyScreenState extends State<AddManuallyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newItem = {
        'item': _nameController.text.trim(),
        'quantity': int.parse(_quantityController.text.trim()),
        'price': double.parse(_priceController.text.trim()),
      };

      // final dbHelper = Provider.of<DatabaseHelper>(context, listen: false);
      // await dbHelper.insertBill(newItem, widget.transactionId);

      if (!mounted) return;
      Navigator.pop(context, newItem);
      
    } catch (e) {
      if (!mounted) return;
      
      String errorMessage;
      
      if (e is FormatException) {
        errorMessage = 'Invalid number format. Please check your input.';
      } else {
        // More generic error handling that doesn't rely on DatabaseException
        errorMessage = 'Error saving item: ${e.toString()}';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
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
        title: const Text("Add Item Manually"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter quantity';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Enter a valid whole number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter price';
                  }
                  final price = double.tryParse(value.trim());
                  if (price == null) {
                    return 'Enter a valid price';
                  }
                  if (price < 0) {
                    return 'Price cannot be negative';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _isLoading ? null : _saveItem,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Add Item',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}