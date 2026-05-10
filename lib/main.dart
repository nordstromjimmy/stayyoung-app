import 'package:flutter/material.dart';
import 'core/utils/prefs_helper.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Remove this before release
  //await PrefsHelper.clearAll();

  final bool onboardingComplete = await PrefsHelper.isOnboardingComplete();
  runApp(StayYoungApp(onboardingComplete: onboardingComplete));
}
