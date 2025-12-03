import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade600,
        elevation: 0,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person, color: Colors.green.shade700),
            title: Text('Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.green.shade700),
            title: Text('Notifications'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.color_lens, color: Colors.green.shade700),
            title: Text('Theme'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.help, color: Colors.green.shade700),
            title: Text('Help & Feedback'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
