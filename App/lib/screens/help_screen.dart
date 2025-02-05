import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 2,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildHelpCard(
            'FAQ',
            'Find answers to frequently asked questions',
            Icons.question_answer_outlined,
          ),
          _buildHelpCard(
            'Contact Support',
            'Get in touch with our support team',
            Icons.support_agent_outlined,
          ),
          _buildHelpCard(
            'Report an Issue',
            'Report any problems or bugs',
            Icons.bug_report_outlined,
          ),
          _buildHelpCard(
            'User Guide',
            'Learn how to use the app',
            Icons.book_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard(String title, String subtitle, IconData icon) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 30),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}