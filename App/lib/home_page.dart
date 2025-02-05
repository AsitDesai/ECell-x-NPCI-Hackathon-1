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
// import 'package:ursapp/screens/database_management_screen.dart';
import '../database/database_helper.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'screens/offers_and_rewards_screen.dart';
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
 

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;
  late TabController _tabController;

  // Image carousel variables
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  final List<String> adsImages = [
    'assets/npci.jpg',
    'assets/imps.png',
    'assets/ads3.png',
    'assets/ad4.png',
  ];

  // Quick actions data
  final List<Map<String, dynamic>> quickActions = [
    {
      'icon': Icons.qr_code,
      'label': 'Personal QR',
      'color': Colors.blue,
      'screen': PersonalQrScreen(),
    },
    {
      'icon': Icons.contact_phone,
      'label': 'Contacts',
      'color': Colors.green,
      'screen': ContactsScreen(),
    },
    {
      'icon': Icons.history,
      'label': 'History',
      'color': Colors.orange,
      'screen': TransactionHistoryScreen(),
    },
    {
      'icon': Icons.cloud_upload,
      'label': 'Upload Bill',
      'color': Colors.purple,
      'screen': UploadBillScreen(),
    },
  ];

  // Feature categories
  final List<Map<String, dynamic>> services = [
    {
      'icon': Icons.qr_code_scanner,
      'title': 'Scan QR',
      'subtitle': 'Scan QR code',
      'color': Colors.blue,
      'screen': QrScannerScreen(),
    },
    {
      'icon': Icons.receipt_long,
      'title': 'Create Bill',
      'subtitle': 'Create new bill',
      'color': Colors.green,
      'screen': CreateBillScreen(),
    },
    {
      'isPoints': true, // Add this flag to identify the points card
      'title': 'Points',
      'subtitle': 'View points',
      'color': Colors.orange,
      'screen': CurrentPointsScreen(),
    },
    {
      'icon': Icons.assignment,
      'title': 'My Bills',
      'subtitle': 'View bills',
      'color': Colors.purple,
      'screen': MyBillsScreen(),
    },
  ];

  final List<Map<String, dynamic>> tools = [
    {
      'icon': Icons.drafts,
      'title': 'Drafts',
      'subtitle': 'Saved items',
      'color': Colors.teal,
      'screen': DraftsScreen(),
    },
    {
      'icon': Icons.card_giftcard,  // Changed icon
      'title': 'Offers & Rewards',  // Changed title
      'subtitle': 'View rewards',    // Changed subtitle
      'color': Colors.indigo,
      'screen': OffersAndRewardsScreen(), // New screen
    },
];

  @override
  void initState() {
    super.initState();
    _loadRecentTransactions();
    _pageController = PageController(initialPage: 0);
    _tabController = TabController(length: 3, vsync: this);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < adsImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _handleLogout(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Confirm Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacementNamed('/login');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error signing out. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  void _handleSearch(String value) {
    // Implement search functionality
    debugPrint('Searching for: $value');
  }

  void _handleNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildNotificationItem(
                    'New Bill Created',
                    'Your bill #123 has been created successfully',
                    '2 min ago',
                  ),
                  _buildNotificationItem(
                    'Points Added',
                    'You received 100 points from your last transaction',
                    '1 hour ago',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

Widget _buildProfileMenu() {
  return PopupMenuButton(
    offset: const Offset(0, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue[100], // Keep original color
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/chill.jpg'),
            radius: 16,
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_drop_down, color: Colors.blue), // Keep original color
        ],
      ),
    ),
    itemBuilder: (context) => [
      PopupMenuItem(
        child: Container(
          width: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const Divider(height: 20),
              _buildPopupMenuItem(
                Icons.person_outline,
                "Profile",
                () => _navigateTo(context, ProfileScreen()),
              ),
              _buildPopupMenuItem(
                Icons.settings_outlined,
                "Settings",
                () => _navigateTo(context, SettingsScreen()),
              ),
              _buildPopupMenuItem(
                Icons.help_outline,
                "Help",
                () => _navigateTo(context, HelpScreen()),
              ),
              const Divider(height: 20),
              _buildPopupMenuItem(
                Icons.logout,
                "Logout",
                () {
                  Navigator.pop(context); // Close the popup menu
                  _handleLogout(context);
                },
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

  Widget _buildProfileHeader() {
    return Row(
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage('assets/chill.jpg'),
          radius: 25,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.displayName ?? "User",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                user?.email ?? "email@example.com",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopupMenuItem(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: searchController,
        onChanged: _handleSearch,
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _buildAdsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 24),
      height: 200,
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
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage(adsImages[index]),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(adsImages.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentPage == index ? Colors.blue : Colors.grey[300],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Quick Actions',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: quickActions.map((action) {
                return GestureDetector(
                  onTap: () => _navigateTo(context, action['screen']),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: action['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          action['icon'],
                          color: action['color'],
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        action['label'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildRecentTransactions() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100, // Adjusted height
          child: _isLoadingRecent
              ? Center(child: CircularProgressIndicator())
              : _recentTransactions.isEmpty
                  ? Center(
                      child: Text(
                        "No recent transactions",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _recentTransactions.take(4).length, // Show only 4 transactions
                      itemBuilder: (context, index) {
                        final transaction = _recentTransactions[index];
                        // Get receiver's UPI ID and extract name (you might need to adjust this based on your data structure)
                        String receiverName = transaction['receiver_upi_id']
                            .toString()
                            .split('@')[0] // Assuming UPI ID format: name@upi
                            .split('_')[0] // In case of name_lastname@upi format
                            .capitalize(); // You'll need to add this extension method

                        return Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              // Circle with first letter
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    receiverName[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Receiver's name
                              Text(
                                receiverName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Amount
                              Text(
                                '₹${transaction['amount']?.toStringAsFixed(0) ?? '0'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ),
      ],
    ),
  );
}

// Add this extension method at the top of your file or in a separate utilities file

  Widget _buildFeatureSection(String title, List<Map<String, dynamic>> items) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildFeatureCard(
                  item['isPoints'] == true ? null : item['icon'],
                  item['title'],
                  item['subtitle'],
                  item['color'],
                  () => _navigateTo(context, item['screen']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  List<Map<String, dynamic>> _recentTransactions = [];
  bool _isLoadingRecent = true;
  Future<void> _loadRecentTransactions() async {
  try {
    final DatabaseHelper dbHelper = DatabaseHelper();
    final List<Map<String, dynamic>> transactions = 
      await dbHelper.getAllTransactions();
    
    setState(() {
      _recentTransactions = transactions
          .take(5) // Get only first 5 transactions
          .toList();
      _isLoadingRecent = false;
    });
  } catch (e) {
    setState(() => _isLoadingRecent = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error loading recent transactions: $e')),
    );
  }
}



  Widget _buildFeatureCard(
    IconData? icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (title == 'Points')
              FutureBuilder<int>(
                future: DatabaseHelper().getTotalPoints(),
                builder: (context, snapshot) {
                  return Text(
                    '${snapshot.data ?? 0}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  );
                },
              )
            else
              Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _tabController.animateTo(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: Colors.blue, // Keep white background
            elevation: 0,
            toolbarHeight: 70,
            title: _buildSearchField(),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Colors.grey),
                  onPressed: _handleNotifications,
                ),
              ),
              const SizedBox(width: 8),
              _buildProfileMenu(),
              const SizedBox(width: 16),
            ],
          ),
        ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Home Tab
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAdsSection(),
              _buildFeatureSection('Services', services),
              _buildQuickActions(),
              _buildFeatureSection('Tools', tools),
              _buildRecentTransactions(),
              const SizedBox(height: 24),
            ],
          ),
        ),
          // History Tab
          TransactionHistoryScreen(),
          // Profile Tab
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: TabBar(
            controller: _tabController,
            onTap: _onItemTapped,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.history), text: 'History'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}