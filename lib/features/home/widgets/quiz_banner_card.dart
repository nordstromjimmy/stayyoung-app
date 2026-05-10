import 'package:flutter/material.dart';
import 'package:stayyoung/features/quiz/screens/quiz_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class QuizBannerCard extends StatelessWidget {
  final VoidCallback onQuizCompleted;
  final VoidCallback onDismissed;

  const QuizBannerCard({
    super.key,
    required this.onQuizCompleted,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text side
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Personalise your experience',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Tell us about yourself',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'A quick 3-step quiz so we can tailor your daily habits, reads, and games.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.85),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                // Progress dots
                Row(
                  children: List.generate(3, (index) {
                    return Container(
                      width: index == 0 ? 20 : 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: index == 0
                            ? Colors.white
                            : Colors.white.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 16),

                // Buttons row
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Start quiz button
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(builder: (_) => const QuizScreen()),
                        );
                        if (result == true) onQuizCompleted();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Start quiz',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Dismiss button
                    GestureDetector(
                      onTap: onDismissed,
                      child: Text(
                        'Dismiss',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: Colors.white.withOpacity(0.75),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Emoji illustration
          Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text('🎯', style: TextStyle(fontSize: 38)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
