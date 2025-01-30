import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ursapp/screens/qr_scan.dart'; // Import the separate QR Scanner file

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

  void _showDialog(String title, List<Widget> items) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: ListView(shrinkWrap: true, children: items),
        actions: [TextButton(child: const Text('Close'), onPressed: () => Navigator.of(context).pop())],
      ),
    );
  }

  Widget _buildListItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  // Navigation methods
  void _navigateToProfile() => Navigator.of(context).pushNamed('/profile');
  void _navigateToSettings() => Navigator.of(context).pushNamed('/settings');
  void _navigateToHelp() => Navigator.of(context).pushNamed('/help');

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
      body: Column(
        children: [
          _buildAdsSection(),
          _buildScanQRButton(),
          _buildWelcomeMessage(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
        ),
      ),
    );
  }

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
                _buildPopupMenuItem(Icons.person_outline, "Profile", _navigateToProfile),
                _buildPopupMenuItem(Icons.settings_outlined, "Settings", _navigateToSettings),
                _buildPopupMenuItem(Icons.help_outline, "Help", _navigateToHelp),
                const Divider(height: 20),
                _buildPopupMenuItem(Icons.logout, "Logout", () => _handleLogout(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildAdsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          const Icon(Icons.local_offer, color: Colors.blue),
          const SizedBox(width: 10),
          const Expanded(child: Text("Check out our latest offers!", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          TextButton(
            onPressed: () => print('View Offers'),
            child: const Text("View", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildScanQRButton() {
    return ElevatedButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QRScannerScreen())),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: const Text('Scan QR Code'),
    );
  }

  Widget _buildWelcomeMessage() {
    return Expanded(
      child: Center(
        child: Text(
          "Welcome to URS!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
