import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mission_model.dart';

class LocalStorage {
  // ====== Keys ======
  static const String _missionsKey = 'missions';
  static const String _pointsKey = 'points';
  static const String _streakKey = 'streak';
  static const String _achievementsKey = 'achievements';
  static const String _lastStreakTimeKey = 'last_streak_time';
  static const String _profileKey = 'profile';

  // ====== Missions ======
  static Future<void> saveMissions(List<Mission> missions) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encoded = missions
        .map((m) => jsonEncode(m.toMap()))
        .toList();
    await prefs.setStringList(_missionsKey, encoded);
  }

  static Future<List<Mission>> loadMissions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encoded = prefs.getStringList(_missionsKey);
    if (encoded == null) return [];
    try {
      return encoded
          .map((s) => Mission.fromMap(jsonDecode(s) as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> addMission(Mission mission) async {
    final list = await loadMissions();
    list.add(mission);
    await saveMissions(list);
  }

  static Future<void> deleteMission(int index) async {
    final list = await loadMissions();
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      await saveMissions(list);
    }
  }

  // ====== Points ======
  static Future<void> savePoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pointsKey, points);
  }

  static Future<int> loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_pointsKey) ?? 0;
  }

  // ====== Streak ======
  static Future<void> saveStreak(int streak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakKey, streak);
  }

  static Future<int> loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  static Future<void> saveLastStreakTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastStreakTimeKey, time.toIso8601String());
  }

  static Future<DateTime?> loadLastStreakTime() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_lastStreakTimeKey);
    if (str == null) return null;
    try {
      return DateTime.parse(str);
    } catch (e) {
      return null;
    }
  }

  // ====== Achievements ======
  static Future<void> saveAchievements(
    List<Map<String, dynamic>> achievements,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encoded = achievements
        .map((a) => jsonEncode(a))
        .toList();
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

  // ====== Profile ======
  static Future<void> saveProfile(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toMap()));
  }

  static Future<Profile> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_profileKey);
    if (str == null) {
      return Profile(
        name: 'Sean Jericho Catayna',
        email: 'sjrodd27@gmail.com',
        password: 'Catayna123',
      );
    }
    try {
      return Profile.fromMap(jsonDecode(str) as Map<String, dynamic>);
    } catch (e) {
      return Profile(
        name: 'Sean Jericho Catayna',
        email: 'sjrodd27@gmail.com',
        password: 'Catayna123',
      );
    }
  }
}

// ====== Profile Class ======
class Profile {
  String name;
  String email;
  String password;

  Profile({required this.name, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'password': password};
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
