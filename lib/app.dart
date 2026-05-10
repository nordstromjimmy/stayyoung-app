import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/shell/screens/main_shell.dart';

class StayYoungApp extends StatelessWidget {
  final bool onboardingComplete;

  const StayYoungApp({super.key, required this.onboardingComplete});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stay Young',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: onboardingComplete ? const MainShell() : const OnboardingScreen(),
    );
  }
}
