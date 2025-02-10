import 'package:flutter/material.dart';
import 'package:health_app_3/pages/bmi_calculate_page.dart';
import 'package:health_app_3/pages/bottom_navbar.dart';
import 'package:health_app_3/pages/goal_selection_page.dart';
import 'package:health_app_3/pages/login_page.dart';
import 'package:health_app_3/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/', // Sets the initial route
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/goal_selection': (context) => const GoalSelectionPage(),
        '/bmi': (context) => WhiteGreenBMIPage(),
        '/': (context) => CustomBottomNavBar(
              onItemSelected: (int index) {
                // Implement functionality here
              },
              selectedIndex: 0,
            ),
      },
    );
  }
}
