import 'package:shared_preferences/shared_preferences.dart';

class BrainScoreHelper {
  BrainScoreHelper._();

  static const String _brainScoreKey = 'brain_score';
  static const String _gamesPlayedKey = 'games_played';

  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // ── Getters ────────────────────────────────────────────────
  static Future<int> getBrainScore() async {
    final prefs = await _getPrefs();
    return prefs.getInt(_brainScoreKey) ?? 0;
  }

  static Future<int> getGamesPlayed() async {
    final prefs = await _getPrefs();
    return prefs.getInt(_gamesPlayedKey) ?? 0;
  }

  // ── Update after a game ────────────────────────────────────
  // correctCount = words recalled correctly
  // totalCount   = total target words
  static Future<int> updateScoreAfterGame({
    required int correctCount,
    required int totalCount,
  }) async {
    final prefs = await _getPrefs();
    final int current = prefs.getInt(_brainScoreKey) ?? 0;
    final int played = prefs.getInt(_gamesPlayedKey) ?? 0;

    final double accuracy = correctCount / totalCount;
    final int earned = (accuracy * 10).round();
    final int updated = current + earned;

    await prefs.setInt(_brainScoreKey, updated);
    await prefs.setInt(_gamesPlayedKey, played + 1);

    return updated;
  }
}
