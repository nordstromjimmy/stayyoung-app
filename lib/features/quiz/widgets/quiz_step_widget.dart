import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/quiz_model.dart';
import 'quiz_option_tile.dart';

class QuizStepData {
  final String emoji;
  final String title;
  final String subtitle;
  final List<QuizOption> options;

  const QuizStepData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.options,
  });
}

class QuizStepWidget extends StatelessWidget {
  final QuizStepData data;
  final String? selectedValue;
  final ValueChanged<String> onOptionSelected;

  const QuizStepWidget({
    super.key,
    required this.data,
    required this.selectedValue,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emoji
          Text(data.emoji, style: const TextStyle(fontSize: 52)),

          const SizedBox(height: 20),

          // Title
          Text(
            data.title,
            style: AppTextStyles.displayMedium.copyWith(fontSize: 26),
          ),

          const SizedBox(height: 10),

          // Subtitle
          Text(
            data.subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.black54,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 32),

          // Options
          ...data.options.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: QuizOptionTile(
                option: option,
                isSelected: selectedValue == option.value,
                onTap: () => onOptionSelected(option.value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
