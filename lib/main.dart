import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const GreetFarmApp());
}

class GreetFarmApp extends StatelessWidget {
  const GreetFarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GreetFarm',
      theme: AppTheme.themeData,
      home: const SplashScreen(),
    );
  }
}