import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> achievements = [
    {"title": "First Mission Completed", "points": 10, "completed": true},
    {"title": "3-Day Streak", "points": 30, "completed": false},
    {"title": "5 Eco Tasks", "points": 50, "completed": false},
    {"title": "Green Hero", "points": 100, "completed": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Achievements', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade600,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            bool completed = achievements[index]["completed"];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(
                  completed ? Icons.emoji_events : Icons.lock,
                  color: completed ? Colors.amber : Colors.grey,
                  size: 30,
                ),
                title: Text(
                  achievements[index]["title"],
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Text(
                  "+${achievements[index]["points"]} pts",
                  style: TextStyle(
                    color: completed
                        ? Colors.green.shade700
                        : Colors.grey.shade400,
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
