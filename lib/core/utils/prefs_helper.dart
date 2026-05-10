import 'package:shared_preferences/shared_preferences.dart';
import '../../features/quiz/models/quiz_model.dart';

class PrefsHelper {
  PrefsHelper._();

  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _quizCompleteKey = 'quiz_complete';
  static const String _quizAgeRangeKey = 'quiz_age_range';
  static const String _quizGoalKey = 'quiz_goal';
  static const String _quizActivityKey = 'quiz_activity';
  static const String _quizDismissedKey = 'quiz_dismissed';

  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // ── Onboarding ─────────────────────────────────────────────
  static Future<void> setOnboardingComplete() async {
    final prefs = await _getPrefs();
    await prefs.setBool(_onboardingCompleteKey, true);
  }

  static Future<bool> isOnboardingComplete() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  // ── Quiz ───────────────────────────────────────────────────
  static Future<void> saveQuizAnswers(QuizAnswers answers) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_quizCompleteKey, true);
    await prefs.setString(_quizAgeRangeKey, answers.ageRange);
    await prefs.setString(_quizGoalKey, answers.goal);
    await prefs.setString(_quizActivityKey, answers.activityLevel);
  }

  static Future<bool> isQuizComplete() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_quizCompleteKey) ?? false;
  }

  static Future<QuizAnswers?> loadQuizAnswers() async {
    final prefs = await _getPrefs();
    final bool complete = prefs.getBool(_quizCompleteKey) ?? false;
    if (!complete) return null;
    return QuizAnswers.fromMap({
      'ageRange': prefs.getString(_quizAgeRangeKey) ?? '',
      'goal': prefs.getString(_quizGoalKey) ?? '',
      'activityLevel': prefs.getString(_quizActivityKey) ?? '',
    });
  }

  static Future<void> setQuizDismissed() async {
    final prefs = await _getPrefs();
    await prefs.setBool(_quizDismissedKey, true);
  }

  static Future<bool> isQuizDismissed() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_quizDismissedKey) ?? false;
  }

  // ── Dev helper ─────────────────────────────────────────────
  // TODO: Remove before release
  static Future<void> clearAll() async {
    final prefs = await _getPrefs();
    await prefs.clear();
  }
}
