import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      Navigator.of(context).pushReplacementNamed('/login'); // Navigate to login screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out. Please try again.')),
      );
    }
  }

  // Handle search
  void _handleSearch(String value) {
    // Implement search functionality
    print('Searching for: $value');
    // Add your search logic here
  }

  // Handle notifications
  void _handleNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notifications'),
        content: Container(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('New notification 1'),
                subtitle: Text('Notification details'),
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('New notification 2'),
                subtitle: Text('Notification details'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Handle messages
  void _handleMessages() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Messages'),
        content: Container(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text('John Doe'),
                subtitle: Text('Hello, how are you?'),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text('Jane Smith'),
                subtitle: Text('Meeting at 3 PM'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Handle profile navigation
  void _navigateToProfile() {
    Navigator.of(context).pushNamed('/profile'); // Make sure to define this route
  }

  // Handle settings navigation
  void _navigateToSettings() {
    Navigator.of(context).pushNamed('/settings'); // Make sure to define this route
  }

  // Handle help navigation
  void _navigateToHelp() {
    Navigator.of(context).pushNamed('/help'); // Make sure to define this route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          title: Container(
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
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: Colors.grey[700]),
              onPressed: _handleNotifications,
            ),
            IconButton(
              icon: Icon(Icons.mail_outline, color: Colors.grey[700]),
              onPressed: _handleMessages,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PopupMenuButton(
                offset: Offset(0, 50),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/chill.jpg'),
                      radius: 18,
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
                  ],
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/chill.jpg'),
                              radius: 25,
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.displayName ?? "User",
                                  style: TextStyle(
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
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(height: 20),
                        InkWell(
                          onTap: _navigateToProfile,
                          child: _buildPopupMenuItem(Icons.person_outline, "Profile"),
                        ),
                        InkWell(
                          onTap: _navigateToSettings,
                          child: _buildPopupMenuItem(Icons.settings_outlined, "Settings"),
                        ),
                        InkWell(
                          onTap: _navigateToHelp,
                          child: _buildPopupMenuItem(Icons.help_outline, "Help"),
                        ),
                        Divider(height: 20),
                        InkWell(
                          onTap: () => _handleLogout(context),
                          child: _buildPopupMenuItem(Icons.logout, "Logout"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                "Welcome to URS!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMenuItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}