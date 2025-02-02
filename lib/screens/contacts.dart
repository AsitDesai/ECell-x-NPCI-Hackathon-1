import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/phone.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late Future<List<Phone>> _phoneList;

  @override
  void initState() {
    super.initState();
    _phoneList = DatabaseHelper().getPhonesByUpiId(''); // Fetch all phones
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts')),
      body: FutureBuilder<List<Phone>>(
        future: _phoneList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No contacts found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Phone phone = snapshot.data![index];
              return ListTile(
                title: Text(phone.name),
                subtitle: Text(phone.phoneNumber),
                leading: Icon(Icons.phone),
              );
            },
          );
        },
      ),
    );
  }
}
