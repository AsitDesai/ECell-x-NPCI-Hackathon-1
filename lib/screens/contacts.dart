import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database_helper.dart';
import '../models/vendor.dart';
import '../models/phone.dart';
import 'payment_screen.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Vendor>>(
              future: Provider.of<DatabaseHelper>(context, listen: false)
                  .getAllVendors(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No contacts found.'));
                } else {
                  final vendors = snapshot.data!;
                  final filteredVendors = vendors.where((vendor) {
                    return vendor.name
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase());
                  }).toList();

                  if (filteredVendors.isEmpty) {
                    return Center(child: Text('No matching contacts found'));
                  }

                  return ListView.builder(
                    itemCount: filteredVendors.length,
                    itemBuilder: (context, index) {
                      final vendor = filteredVendors[index];
                      return FutureBuilder<List<Phone>>(
                        future: Provider.of<DatabaseHelper>(context,
                                listen: false)
                            .getPhonesByUpiId(vendor.upiId),
                        builder: (context, phoneSnapshot) {
                          if (phoneSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  vendor.name.isNotEmpty
                                      ? vendor.name[0]
                                      : '?',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.blue,
                              ),
                              title: Text(vendor.name),
                              subtitle: Text('Loading phone numbers...'),
                            );
                          } else if (phoneSnapshot.hasError) {
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  vendor.name.isNotEmpty
                                      ? vendor.name[0]
                                      : '?',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.blue,
                              ),
                              title: Text(vendor.name),
                              subtitle: Text('Error loading phone numbers'),
                            );
                          } else if (!phoneSnapshot.hasData ||
                              phoneSnapshot.data!.isEmpty) {
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  vendor.name.isNotEmpty
                                      ? vendor.name[0]
                                      : '?',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.blue,
                              ),
                              title: Text(vendor.name),
                              subtitle: Text('No phone numbers available'),
                            );
                          } else {
                            final phones = phoneSnapshot.data!;
                            final phone = phones.first;
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  vendor.name.isNotEmpty
                                      ? vendor.name[0]
                                      : '?',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.blue,
                              ),
                              title: Text(vendor.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Phone: ${phone.phoneNumber}'),
                                  Text('UPI ID: ${phone.upiId}'),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentScreen(qrData: phone.upiId),
                                  ),
                                );
                              },
                            );
                          }
                        },
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