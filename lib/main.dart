import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/achievements_screen.dart';

void main() {
  runApp(const EcoHuntApp());
}

class EcoHuntApp extends StatelessWidget {
  const EcoHuntApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoHunt',
      theme: ThemeData(
        textTheme: Typography.blackMountainView.apply(fontSizeFactor: 1.0),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
      routes: {
        '/onboarding': (_) => const OnboardingScreen(),
        '/home': (_) => const HomeScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/achievements': (_) => const AchievementsScreen(),
      },
    );
  }
}
