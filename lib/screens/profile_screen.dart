import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade600,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green.shade400,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'johndoe@example.com',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            SizedBox(height: 30),

            // Profile options
            ListTile(
              leading: Icon(Icons.edit, color: Colors.green.shade700),
              title: Text('Edit Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.lock, color: Colors.green.shade700),
              title: Text('Change Password'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.green.shade700),
              title: Text('Mission History'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
