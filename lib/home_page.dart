import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ursapp/screens/settings_screen.dart';
import 'package:ursapp/screens/help_screen.dart';
import 'package:ursapp/screens/profile_screen.dart';
import 'package:ursapp/screens/contacts.dart';
import 'package:ursapp/screens/personal_qr.dart';
import 'package:ursapp/screens/transaction_history.dart';
import 'package:ursapp/screens/current_points.dart';
import 'package:ursapp/screens/create_bill.dart';
import 'package:ursapp/screens/drafts.dart';
import 'package:ursapp/screens/upload_bill.dart';
import 'package:ursapp/screens/my_bills.dart';
import 'package:ursapp/screens/qr_scanner_screen.dart';
import 'package:ursapp/screens/database_management_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;

  // Image carousel variables
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  final List<String> adsImages = [
    'assets/ads1.jpeg',
    'assets/ads2.jpeg',
    'assets/ads3.png',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < adsImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    searchController.dispose();
    super.dispose();
  }

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

  void _handleSearch(String value) {
    print('Searching for: $value');
  }

  void _handleNotifications() {
    _showDialog('Notifications', [
      _buildListItem(Icons.notifications, 'New notification 1', 'Notification details'),
      _buildListItem(Icons.notifications, 'New notification 2', 'Notification details'),
    ]);
  }

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
        actions: [
          TextButton(child: const Text('Close'), onPressed: () => Navigator.of(context).pop())
        ],
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

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget _buildProfileMenu() {
    return PopupMenuButton(
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

  Widget _buildAdsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      height: 180,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: adsImages.length,
              onPageChanged: (int page) {
                setState(() => _currentPage = page);
              },
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(adsImages[index]),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(adsImages.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentPage == index ? 12 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildIconSection() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 20,
      padding: const EdgeInsets.all(8),
      children: [
        _buildIconItem(Icons.qr_code_scanner, "Scan QR", () => _navigateTo(context, QrScannerScreen())),
        _buildIconItem(Icons.qr_code, "Personal QR", () => _navigateTo(context, PersonalQrScreen())),
        _buildIconItem(Icons.contact_phone, "Contacts", () => _navigateTo(context, ContactsScreen())),
        _buildIconItem(Icons.history, "Transaction_H", () => _navigateTo(context, TransactionHistoryScreen())),
        _buildIconItem(Icons.wallet_giftcard, "Current Points", () => _navigateTo(context, CurrentPointsScreen())),
        _buildIconItem(Icons.receipt_long, "Create Bill", () => _navigateTo(context, CreateBillScreen())),
        _buildIconItem(Icons.drafts, "Drafts", () => _navigateTo(context, DraftsScreen())),
        _buildIconItem(Icons.cloud_upload, "Upload Bill", () => _navigateTo(context, UploadBillScreen())),
        _buildIconItem(Icons.assignment, "My Bills", () => _navigateTo(context, MyBillsScreen())),
        _buildIconItem(Icons.storage, "Manage DB", () => _navigateTo(context, DatabaseManagementScreen())),
      ],
    );
  }

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
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Welcome, ${user?.displayName ?? "User"}!',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: _buildSearchField(),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.grey),
            onPressed: _handleNotifications,
          ),
          _buildProfileMenu(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAdsSection(),
            _buildWelcomeMessage(),
            _buildIconSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}