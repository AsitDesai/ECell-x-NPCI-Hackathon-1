import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

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
            // Notifications Icon
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: Colors.grey[700]),
              onPressed: () {},
            ),
            // Messages Icon
            IconButton(
              icon: Icon(Icons.mail_outline, color: Colors.grey[700]),
              onPressed: () {},
            ),
            // Profile Section
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
                        _buildPopupMenuItem(Icons.person_outline, "Profile"),
                        _buildPopupMenuItem(Icons.settings_outlined, "Settings"),
                        _buildPopupMenuItem(Icons.help_outline, "Help"),
                        Divider(height: 20),
                        _buildPopupMenuItem(Icons.logout, "Logout"),
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
          // Add your main content here
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
}