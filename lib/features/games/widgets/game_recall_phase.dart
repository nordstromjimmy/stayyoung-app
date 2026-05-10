import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/primary_button.dart';

class GameRecallPhase extends StatelessWidget {
  final List<String> allWords;
  final Set<String> selectedWords;
  final ValueChanged<String> onWordToggled;
  final VoidCallback onCheckAnswers;

  const GameRecallPhase({
    super.key,
    required this.allWords,
    required this.selectedWords,
    required this.onWordToggled,
    required this.onCheckAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Which words do you remember?',
            style: AppTextStyles.headingMedium,
          ),

          const SizedBox(height: 4),

          Text(
            'Tap every word that was in the list.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 8),

          // Selected count indicator
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: selectedWords.isEmpty
                ? Text(
                    'No words selected yet',
                    key: const ValueKey('empty'),
                    style: AppTextStyles.caption,
                  )
                : Text(
                    '${selectedWords.length} word${selectedWords.length == 1 ? '' : 's'} selected',
                    key: ValueKey(selectedWords.length),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),

          const SizedBox(height: 20),

          // Word grid
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: allWords.map((word) {
                  final bool isSelected = selectedWords.contains(word);
                  return _RecallChip(
                    word: word,
                    isSelected: isSelected,
                    onTap: () => onWordToggled(word),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Check answers button
          PrimaryButton(label: 'Check answers', onPressed: onCheckAnswers),
        ],
      ),
    );
  }
}

// ── Single tappable recall chip ────────────────────────────────
class _RecallChip extends StatelessWidget {
  final String word;
  final bool isSelected;
  final VoidCallback onTap;

  const _RecallChip({
    required this.word,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selection indicator dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : AppColors.divider,
              ),
            ),

            Text(
              word,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
