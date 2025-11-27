import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int points = 120;
  int streak = 3;

  List<Map<String, dynamic>> missions = [
    {"title": "Turn off unused lights", "completed": false},
    {"title": "Use a reusable bottle", "completed": true},
    {"title": "Segregate your waste properly", "completed": false},
  ];

  void toggleMission(int index) {
    setState(() {
      missions[index]["completed"] = !missions[index]["completed"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        elevation: 0,
        title: Text(
          "EcoHunt",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade600,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text("Points", style: TextStyle(color: Colors.white70)),
                    Text(
                      "$points",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("Streak", style: TextStyle(color: Colors.white70)),
                    Text(
                      "${streak} days",
                      style: TextStyle(
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

          SizedBox(height: 20),

          // Daily Missions Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Missions",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.event_available, color: Colors.green),
              ],
            ),
          ),

          SizedBox(height: 10),

          // Mission List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: missions.length,
              itemBuilder: (context, index) {
                bool completed = missions[index]["completed"];
                return GestureDetector(
                  onTap: () => toggleMission(index),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: completed ? Colors.green.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          completed
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: completed ? Colors.green : Colors.grey,
                          size: 30,
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            missions[index]["title"],
                            style: TextStyle(
                              fontSize: 18,
                              decoration: completed
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: completed
                                  ? Colors.green.shade800
                                  : Colors.black,
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
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
