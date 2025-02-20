import 'package:flutter/material.dart';
import 'package:health_app_3/pages/bmi_calculate_page.dart';
import 'package:health_app_3/pages/bottom_navbar.dart';
import 'package:health_app_3/pages/forgotpassword.dart';
import 'package:health_app_3/pages/goal_selection_page.dart';
import 'package:health_app_3/pages/login_page.dart';
import 'package:health_app_3/pages/profile_page.dart';
import 'package:health_app_3/pages/register_page.dart';

import 'complete_details_page.dart';
import 'pages/meal_comparison_page.dart';
import 'pages/meal_result_page.dart';
import 'pages/scanmeal_page.dart';
import 'package:path_provider/path_provider.dart';

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
        '/scan_meal': (context) => CustomBottomNavBar(
              onItemSelected: (int index) {
                // Implement functionality here
              },
              selectedIndex: 0,
            ),
        '/meal_result': (context) => const ScanMealPage(),
        '/complete_details': (context) => CompleteProfilePage(),
        '/forgot_password': (context) => MealResultPage(
              mealImage: null,
            ),
        '/MealComparisonPage': (context) => const MealComparisonPage(
              mealImage: null,
            ),
        '/': (context) => ProfilePage(),
        '/profile': (context) => ModernForgotPasswordPage(),
      },
    );
  }
}
