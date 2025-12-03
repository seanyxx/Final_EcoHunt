import 'package:flutter/material.dart';

import '../data/local_storage.dart';
import '../models/mission_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int points = 0;
  int streak = 0;

  List<Mission> missions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedMissions = await LocalStorage.loadMissions();
    final loadedPoints = await LocalStorage.loadPoints();
    final loadedStreak = await LocalStorage.loadStreak();

    setState(() {
      points = loadedPoints;
      streak = loadedStreak;
      if (loadedMissions.isEmpty) {
        // initialize defaults if none saved
        missions = [
          Mission(title: 'Turn off unused lights'),
          Mission(title: 'Use a reusable bottle', completed: true),
          Mission(title: 'Segregate your waste properly'),
        ];
        LocalStorage.saveMissions(missions);
      } else {
        missions = loadedMissions;
      }
    });

    // Ensure achievements reflect current data
    await _updateAchievements();
  }

  void toggleMission(int index) {
    final wasCompleted = missions[index].completed;
    setState(() {
      missions[index].completed = !wasCompleted;
    });

    // Update points: add when marking completed, subtract when unmarking
    if (!wasCompleted && missions[index].completed) {
      points += missions[index].points;
    } else if (wasCompleted && !missions[index].completed) {
      points -= missions[index].points;
      if (points < 0) points = 0;
    }

    // Persist changes
    LocalStorage.saveMissions(missions);
    LocalStorage.savePoints(points);

    // Recompute achievements and persist
    _updateAchievements();
  }

  Future<void> _updateAchievements() async {
    final completedCount = missions.where((m) => m.completed).length;
    final List<Map<String, dynamic>> achievements = [
      {
        'title': 'First Mission Completed',
        'points': 10,
        'completed': completedCount >= 1,
      },
      {
        'title': '3-Day Streak',
        'points': 30,
        'completed': streak >= 3,
      },
      {
        'title': '5 Eco Tasks',
        'points': 50,
        'completed': completedCount >= 5,
      },
      {
        'title': 'Green Hero',
        'points': 100,
        'completed': points >= 100,
      },
    ];

    await LocalStorage.saveAchievements(achievements);
  }

  Future<void> _addMissionDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Mission'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Mission title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      final newMission = Mission(title: result);
      setState(() => missions.add(newMission));
      await LocalStorage.saveMissions(missions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        elevation: 0,
        title: const Text(
          'EcoHunt',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade600,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Points', style: TextStyle(color: Colors.white70)),
                    Text(
                      '$points',
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Streak', style: TextStyle(color: Colors.white70)),
                    Text(
                      '$streak days',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Daily Missions Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Today's Missions",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.event_available, color: Colors.green),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Mission List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: missions.length,
              itemBuilder: (context, index) {
                final completed = missions[index].completed;
                return GestureDetector(
                  onTap: () => toggleMission(index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: completed ? Colors.green.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          completed ? Icons.check_circle : Icons.circle_outlined,
                          color: completed ? Colors.green : Colors.grey,
                          size: 30,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            missions[index].title,
                            style: TextStyle(
                              fontSize: 18,
                              decoration: completed ? TextDecoration.lineThrough : TextDecoration.none,
                              color: completed ? Colors.green.shade800 : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade600,
        onPressed: _addMissionDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
