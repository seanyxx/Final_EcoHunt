// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(EcoHuntApp());
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
      home: SplashScreen(),
      routes: {
        '/onboarding': (_) => OnboardingScreen(),
        '/home': (_) => HomeScreen(),
      },
    );
  }
}

// NOTE TO TEAM:
// The original combined UI code has now been removed from main.dart.
// Next steps: create the files inside /screens and /widgets folders.
// I will generate each file when you say "Create the screens folder now."
