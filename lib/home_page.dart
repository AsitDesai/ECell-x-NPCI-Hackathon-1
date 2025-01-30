import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ursapp/screens/settings_screen.dart';
import 'package:ursapp/screens/help_screen.dart';
import 'package:ursapp/screens/profile_screen.dart';

import 'package:ursapp/screens/contacts.dart'; // Importing Contacts Screen
import 'package:ursapp/screens/personal_qr.dart'; // Importing Personal QR Screen
import 'package:ursapp/screens/transaction_history.dart'; // Importing Transaction History Screen
import 'package:ursapp/screens/current_points.dart'; // Importing Current Points Screen
import 'package:ursapp/screens/create_bill.dart'; // Importing Create Bill Screen
import 'package:ursapp/screens/drafts.dart'; // Importing Drafts Screen
import 'package:ursapp/screens/upload_bill.dart'; // Importing Upload Bill Screen
import 'package:ursapp/screens/my_bills.dart'; // Importing My Bills Screen
import 'package:ursapp/screens/qr_scan.dart'; // Importing the QR Scan Screen

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController searchController = TextEditingController();

  // Handle logout
  Future<void> _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error signing out. Please try again.')),
      );
    }
  }

  // Handle search
  void _handleSearch(String value) {
    print('Searching for: $value');
  }

  // Handle notifications
  void _handleNotifications() {
    _showDialog('Notifications', [
      _buildListItem(Icons.notifications, 'New notification 1', 'Notification details'),
      _buildListItem(Icons.notifications, 'New notification 2', 'Notification details'),
    ]);
  }

  // Handle messages
  void _handleMessages() {
    _showDialog('Messages', [
      _buildListItem(Icons.person, 'John Doe', 'Hello, how are you?'),
      _buildListItem(Icons.person, 'Jane Smith', 'Meeting at 3 PM'),
    ]);
  }

  // Build notification or message dialog
  void _showDialog(String title, List<Widget> items) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: ListView(shrinkWrap: true, children: items),
        actions: [
          TextButton(child: const Text('Close'), onPressed: () => Navigator.of(context).pop())
        ],
      ),
    );
  }

  // Build a list item for the dialog
  Widget _buildListItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  // Navigation methods
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Build the profile menu
  Widget _buildProfileMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: PopupMenuButton(
        offset: const Offset(0, 50),
        child: Row(
          children: [
            const CircleAvatar(backgroundImage: AssetImage('assets/chill.jpg'), radius: 18),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(),
                const Divider(height: 20),
                _buildPopupMenuItem(Icons.person_outline, "Profile", () => _navigateTo(context, ProfileScreen())),
                _buildPopupMenuItem(Icons.settings_outlined, "Settings", () => _navigateTo(context, SettingsScreen())),
                _buildPopupMenuItem(Icons.help_outline, "Help", () => _navigateTo(context, HelpScreen())),
                const Divider(height: 20),
                _buildPopupMenuItem(Icons.logout, "Logout", () => _handleLogout(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build profile header in the profile menu
  Widget _buildProfileHeader() {
    return Row(
      children: [
        const CircleAvatar(backgroundImage: AssetImage('assets/chill.jpg'), radius: 25),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user?.displayName ?? "User", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(user?.email ?? "email@example.com", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          ],
        ),
      ],
    );
  }

  // Build popup menu item in the profile menu
  Widget _buildPopupMenuItem(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 12),
            Text(text, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // Build the search field
  Widget _buildSearchField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        controller: searchController,
        onChanged: _handleSearch,
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
        ),
      ),
    );
  }

  // Build the ads section
  Widget _buildAdsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer, color: Colors.blue),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "Check out our latest offers!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () => print('View Offers'),
            child: const Text(
              "View",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Build the icon section using GridView
  Widget _buildIconSection() {
    return GridView.count(
      shrinkWrap: true, // Ensures the GridView only takes the space it needs
      physics: NeverScrollableScrollPhysics(), // Prevents scrolling inside the GridView
      crossAxisCount: 4,
      padding: const EdgeInsets.all(8),
      children: [
        _buildIconItem(Icons.contact_phone, "Contacts", () => _navigateTo(context, ContactsScreen())),
        _buildIconItem(Icons.qr_code, "Personal QR", () => _navigateTo(context, PersonalQrScreen())),
        _buildIconItem(Icons.history, "Transaction_H", () => _navigateTo(context, TransactionHistoryScreen())),
        _buildIconItem(Icons.wallet_giftcard, "Current Points", () => _navigateTo(context, CurrentPointsScreen())),
        _buildIconItem(Icons.receipt_long, "Create Bill", () => _navigateTo(context, CreateBillScreen())),
        _buildIconItem(Icons.drafts, "Drafts", () => _navigateTo(context, DraftsScreen())),
        _buildIconItem(Icons.cloud_upload, "Upload Bill", () => _navigateTo(context, UploadBillScreen())),
        _buildIconItem(Icons.assignment, "My Bills", () => _navigateTo(context, MyBillsScreen())),
      ],
    );
  }

  // Build each individual icon item
  Widget _buildIconItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue.withOpacity(0.2),
            child: Icon(icon, size: 30, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Build the scan QR button
  Widget _buildScanQRButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QRScannerScreen())),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(fontSize: 18),
        ),
        child: const Text('Scan QR Code'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          title: _buildSearchField(),
          actions: _buildAppBarActions(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAdsSection(),
            _buildWelcomeMessage(),
            _buildScanQRButton(),
            _buildIconSection(),
          ],
        ),
      ),
    );
  }

  // Build app bar actions
  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        icon: const Icon(Icons.notifications_outlined, color: Colors.grey),
        onPressed: _handleNotifications,
      ),
      IconButton(
        icon: const Icon(Icons.mail_outline, color: Colors.grey),
        onPressed: _handleMessages,
      ),
      _buildProfileMenu(),
    ];
  }

  // Build welcome message
  Widget _buildWelcomeMessage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Welcome, ${user?.displayName ?? "User"}!',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}