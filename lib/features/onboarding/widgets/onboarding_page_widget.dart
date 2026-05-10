import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

// Data model for a single onboarding page
class OnboardingPageData {
  final String emoji;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color accentColor;

  const OnboardingPageData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.accentColor,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingPageWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji card
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: data.backgroundColor,
              borderRadius: BorderRadius.circular(48),
            ),
            child: Center(
              child: Text(data.emoji, style: const TextStyle(fontSize: 80)),
            ),
          ),

          const SizedBox(height: 48),

          // Title
          Text(
            data.title,
            style: AppTextStyles.displayMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Subtitle
          Text(
            data.subtitle,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.black54,
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
