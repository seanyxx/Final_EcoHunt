import 'package:flutter/material.dart';

import '../data/local_storage.dart';

class AchievementsScreen extends StatefulWidget {
  AchievementsScreen({super.key});

  @override
  _AchievementsScreenState createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  List<Map<String, dynamic>> achievements = [];

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final loaded = await LocalStorage.loadAchievements();
    if (loaded.isEmpty) {
      // initialize defaults
      achievements = [
        {"title": "First Mission Completed", "points": 10, "completed": false},
        {"title": "3-Day Streak", "points": 30, "completed": false},
        {"title": "5 Eco Tasks", "points": 50, "completed": false},
        {"title": "Green Hero", "points": 100, "completed": false},
      ];
      await LocalStorage.saveAchievements(achievements);
    } else {
      achievements = loaded;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade600,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final item = achievements[index];
            final bool completed = item['completed'] == true;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(
                  completed ? Icons.emoji_events : Icons.lock,
                  color: completed ? Colors.amber : Colors.grey,
                  size: 30,
                ),
                title: Text(
                  item['title'] ?? '',
                  style: const TextStyle(fontSize: 18),
                ),
                trailing: Text(
                  "+${item['points']} pts",
                  style: TextStyle(
                    color: completed ? Colors.green.shade700 : Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
