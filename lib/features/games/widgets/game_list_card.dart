import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../screens/games_screen.dart';

class GameListCardData {
  final String emoji;
  final String title;
  final String subtitle;
  final GameCategory category;
  final String categoryLabel;
  final Color categoryColor;
  final Color categoryTextColor;
  final Color iconBackground;
  final bool isAvailable;

  const GameListCardData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.categoryLabel,
    required this.categoryColor,
    required this.categoryTextColor,
    required this.iconBackground,
    required this.isAvailable,
  });
}

class GameListCard extends StatelessWidget {
  final GameListCardData data;
  final VoidCallback onTap;

  const GameListCard({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: data.isAvailable ? 1.0 : 0.55,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider, width: 1),
          ),
          child: Row(
            children: [
              // Icon box
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: data.iconBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(data.emoji, style: const TextStyle(fontSize: 26)),
                ),
              ),

              const SizedBox(width: 14),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: AppTextStyles.headingSmall.copyWith(fontSize: 15),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      data.subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Category pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: data.categoryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        data.categoryLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: data.categoryTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Play / Soon badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: data.isAvailable
                      ? AppColors.primaryLight.withOpacity(0.15)
                      : AppColors.divider,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  data.isAvailable ? 'Play' : 'Soon',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: data.isAvailable
                        ? AppColors.primaryDark
                        : AppColors.textHint,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
