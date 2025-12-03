import 'dart:async';
import 'package:flutter/material.dart';
import '../data/local_storage.dart';
import '../models/mission_model.dart';
import 'profile_screen.dart';
import 'achievements_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // ===== Home Screen Data =====
  int points = 0;
  int streakMinutes = 0;
  List<Mission> missions = [];

  DateTime? lastStreakIncrementTime; // Last minute increment time
  bool completedThisMinute =
      false; // Track if a mission was completed in the current minute
  Timer? _streakTimer;

  final _tabs = const [
    Center(child: Text('Home Placeholder')), // will replace in build
    ProfileScreen(),
    AchievementsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    _startStreakTimer();
  }

  @override
  void dispose() {
    _streakTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    final loadedMissions = await LocalStorage.loadMissions();
    final loadedPoints = await LocalStorage.loadPoints();
    final loadedStreak = await LocalStorage.loadStreak();
    final lastIncrement = await LocalStorage.loadLastStreakTime();

    setState(() {
      points = loadedPoints;
      streakMinutes = loadedStreak;
      lastStreakIncrementTime = lastIncrement;
      missions = loadedMissions.isNotEmpty
          ? loadedMissions
          : [
              Mission(title: 'Turn off unused lights'),
              Mission(title: 'Use a reusable bottle'),
              Mission(title: 'Segregate your waste properly'),
            ];
    });
  }

  void _startStreakTimer() {
    _streakTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final now = DateTime.now();

      if (lastStreakIncrementTime == null) {
        lastStreakIncrementTime = now;
        await LocalStorage.saveLastStreakTime(now);
        return;
      }

      final diffMinutes = now.difference(lastStreakIncrementTime!).inMinutes;

      if (diffMinutes >= 1) {
        // If a mission was completed during the last minute, increment
        if (completedThisMinute) {
          streakMinutes += 1;
        } else {
          streakMinutes = 0; // Reset streak if no mission was completed
        }

        completedThisMinute = false; // Reset for next minute
        lastStreakIncrementTime = now;
        await LocalStorage.saveStreak(streakMinutes);
        await LocalStorage.saveLastStreakTime(now);

        setState(() {});
        _updateAchievements();
      }
    });
  }

  // ===== Toggle Mission Completion =====
  Future<void> toggleMission(int index) async {
    final mission = missions[index];
    setState(() {
      mission.completed = !mission.completed;
    });

    // Update points
    if (mission.completed) {
      points += mission.points;
    } else {
      points -= mission.points;
      if (points < 0) points = 0;
    }

    await LocalStorage.saveMissions(missions);
    await LocalStorage.savePoints(points);

    // Mark that a mission was completed in this minute
    if (mission.completed) completedThisMinute = true;

    _updateAchievements();
  }

  Future<void> _deleteMission(int index) async {
    setState(() {
      missions.removeAt(index);
    });
    await LocalStorage.saveMissions(missions);
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

  Future<void> _updateAchievements() async {
    final completedCount = missions.where((m) => m.completed).length;
    final achievements = [
      {
        'title': 'First Mission Completed',
        'points': 10,
        'completed': completedCount >= 1,
      },
      {
        'title': '3-Minute Streak',
        'points': 30,
        'completed': streakMinutes >= 3,
      },
      {'title': '5 Eco Tasks', 'points': 50, 'completed': completedCount >= 5},
      {'title': 'Green Hero', 'points': 100, 'completed': points >= 100},
    ];
    await LocalStorage.saveAchievements(achievements);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _buildHomeTab(),
      const ProfileScreen(),
      const AchievementsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green.shade600,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Achievements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: _addMissionDialog,
              backgroundColor: Colors.green.shade600,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildHomeTab() {
    return SafeArea(
      child: Column(
        children: [
          // Header: Points and Streak
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
                    const Text(
                      'Points',
                      style: TextStyle(color: Colors.white70),
                    ),
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
                    const Text(
                      'Day-Streak (minute based for demo)',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '$streakMinutes',
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

          // Missions List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: missions.length,
              itemBuilder: (context, index) {
                final mission = missions[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: mission.completed
                        ? Colors.green.shade100
                        : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => toggleMission(index),
                        child: Icon(
                          mission.completed
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: mission.completed ? Colors.green : Colors.grey,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          mission.title,
                          style: TextStyle(
                            fontSize: 18,
                            decoration: mission.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: mission.completed
                                ? Colors.green.shade800
                                : Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteMission(index),
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
}
