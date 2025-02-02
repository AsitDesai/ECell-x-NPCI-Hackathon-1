import 'package:flutter/material.dart';
import 'add_manually.dart';

class AddItemsScreen extends StatefulWidget {
  @override
  _AddItemsScreenState createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  List<Map<String, dynamic>> addedItems = [];

  void addItem(Map<String, dynamic> item) {
    setState(() {
      addedItems.add(item);
    });
  }

  // Function to save the final list
  void saveList() async {
    if (addedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot save empty list')),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      // TODO: Implement your actual save logic here
      // For example, saving to local storage or sending to a server
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay

      Navigator.pop(context); // Dismiss loading indicator
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('List saved successfully')),
      );

      // Optionally clear the list after saving
      setState(() {
        addedItems.clear();
      });
    } catch (e) {
      Navigator.pop(context); // Dismiss loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving list: $e')),
      );
    }
  }

  ///

  // Function to save as draft
  void saveDraft() async {
    if (addedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot save empty draft')),
      );
      return;
    }

    try {
      // TODO: Implement your draft saving logic here
      // For example, saving to local storage with a draft flag
      await Future.delayed(Duration(milliseconds: 500)); // Simulate storage delay

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Draft saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving draft: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Items"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: addedItems.length,
              itemBuilder: (context, index) {
                final item = addedItems[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text('Quantity: ${item['quantity']}, Price: ${item['price']}'),
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
                    onPressed: () {
                      // Navigate to Barcode Scanning Screen
                      // Implement barcode scanning logic here
                    },
                    child: Text("Barcode Scanning"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final newItem = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddManuallyScreen(),
                        ),
                      );

                      if (newItem != null) {
                        addItem(newItem);
                      }
                    },
                    child: Text("Add Manually"),
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
                    onPressed: saveList,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Save List"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: saveDraft,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Save Draft"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}