import 'package:flutter/material.dart';
import '../models/mission_model.dart';

class MissionCard extends StatelessWidget {
  final Mission mission;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const MissionCard({
    super.key,
    required this.mission,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: mission.completed ? Colors.green.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.green.shade300),
        ),
        child: Row(
          children: [
            Icon(
              mission.completed ? Icons.check_circle : Icons.circle_outlined,
              color: mission.completed ? Colors.green : Colors.grey,
              size: 30,
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
            // ---------------------------
            // Delete button
            // ---------------------------
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
