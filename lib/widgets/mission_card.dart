import 'package:flutter/material.dart';

class MissionCard extends StatelessWidget {
  final String title;
  final bool completed;
  final VoidCallback onTap;

  const MissionCard({super.key, 
    required this.title,
    required this.completed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              completed ? Icons.check_circle : Icons.circle_outlined,
              color: completed ? Colors.green : Colors.grey,
              size: 30,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  decoration: completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: completed ? Colors.green.shade800 : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
