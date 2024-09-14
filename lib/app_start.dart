import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:state_management/screens/dashboard_screen.dart';
import 'screens/onboarding_screen.dart';

class AppStart extends StatelessWidget {
  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkFirstTime(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.data ?? true) {
            return const OnBoardingScreen();  // Show onboarding for first-time users
          } else {
            return const DashboardScreen();   // Redirect to Dashboard
          }
        }
      },
    );
  }

  Future<bool> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('firstTime') ?? true;  // Default true if not set
  }
}
