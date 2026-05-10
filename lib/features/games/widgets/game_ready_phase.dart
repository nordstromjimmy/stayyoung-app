import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/primary_button.dart';

class GameReadyPhase extends StatelessWidget {
  final VoidCallback onStart;

  const GameReadyPhase({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emoji
          const Text('🧩', style: TextStyle(fontSize: 56)),

          const SizedBox(height: 20),

          // Title
          Text(
            'Word Recall',
            style: AppTextStyles.displayMedium.copyWith(fontSize: 28),
          ),

          const SizedBox(height: 8),

          Text(
            'A quick memory workout for your brain.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 32),

          // How to play card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceWarm,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How to play',
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 16),
                _InstructionRow(
                  emoji: '👁',
                  text: 'Study 6 words for 5 seconds',
                ),
                const SizedBox(height: 12),
                _InstructionRow(
                  emoji: '🧠',
                  text: 'The words disappear — hold them in your mind',
                ),
                const SizedBox(height: 12),
                _InstructionRow(
                  emoji: '✅',
                  text: 'Tap every word you remember from the grid',
                ),
                const SizedBox(height: 12),
                _InstructionRow(
                  emoji: '🏆',
                  text: 'See your score and try to beat it next time',
                ),
              ],
            ),
          ),

          const Spacer(),

          PrimaryButton(label: "Let's go →", onPressed: onStart),
        ],
      ),
    );
  }
}

// ── Single instruction row ─────────────────────────────────────
class _InstructionRow extends StatelessWidget {
  final String emoji;
  final String text;

  const _InstructionRow({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
