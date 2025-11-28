import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/mission_model.dart';

class LocalStorage {
  static const String _missionsKey = 'missions';
  static const String _pointsKey = 'points';
  static const String _streakKey = 'streak';
  static const String _achievementsKey = 'achievements';

  // Save full missions list
  static Future<void> saveMissions(List<Mission> missions) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encoded =
        missions.map((m) => jsonEncode(m.toMap())).toList();
    await prefs.setStringList(_missionsKey, encoded);
  }

  // Load missions, returns empty list if none
  static Future<List<Mission>> loadMissions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encoded = prefs.getStringList(_missionsKey);
    if (encoded == null) return [];
    try {
      return encoded
          .map((s) => Mission.fromMap(jsonDecode(s) as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Corrupt data fallback
      return [];
    }
  }

  static Future<void> addMission(Mission mission) async {
    final list = await loadMissions();
    list.add(mission);
    await saveMissions(list);
  }

  static Future<void> savePoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pointsKey, points);
  }

  static Future<int> loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_pointsKey) ?? 0;
  }

  static Future<void> saveStreak(int streak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakKey, streak);
  }

  static Future<int> loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  // Achievements are stored as a List<String> of JSON-encoded maps
  static Future<void> saveAchievements(List<Map<String, dynamic>> achievements) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encoded = achievements.map((a) => jsonEncode(a)).toList();
    await prefs.setStringList(_achievementsKey, encoded);
  }

  static Future<List<Map<String, dynamic>>> loadAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encoded = prefs.getStringList(_achievementsKey);
    if (encoded == null) return [];
    try {
      return encoded
          .map((s) => Map<String, dynamic>.from(jsonDecode(s) as Map))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
