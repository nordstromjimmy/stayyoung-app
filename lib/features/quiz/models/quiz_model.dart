class QuizAnswers {
  final String ageRange;
  final String goal;
  final String activityLevel;

  const QuizAnswers({
    required this.ageRange,
    required this.goal,
    required this.activityLevel,
  });

  // Flatten to a map for saving to prefs
  Map<String, String> toMap() => {
    'ageRange': ageRange,
    'goal': goal,
    'activityLevel': activityLevel,
  };

  // Rebuild from saved prefs values
  factory QuizAnswers.fromMap(Map<String, String> map) => QuizAnswers(
    ageRange: map['ageRange'] ?? '',
    goal: map['goal'] ?? '',
    activityLevel: map['activityLevel'] ?? '',
  );

  // Friendly label for the goal — used in greeting later
  String get goalLabel {
    switch (goal) {
      case 'mind':
        return 'sharp mind';
      case 'body':
        return 'active body';
      case 'balance':
        return 'balanced life';
      default:
        return 'young spirit';
    }
  }

  bool get isComplete =>
      ageRange.isNotEmpty && goal.isNotEmpty && activityLevel.isNotEmpty;
}
