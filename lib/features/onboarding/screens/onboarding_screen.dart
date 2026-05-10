import 'package:flutter/material.dart';
import 'package:stayyoung/features/shell/screens/main_shell.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/prefs_helper.dart';
import '../../../shared/widgets/primary_button.dart';
import '../widgets/onboarding_page_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = const [
    OnboardingPageData(
      emoji: '🌅',
      title: 'Every day is\na fresh start',
      subtitle:
          'Small steps every day add up to a life that feels vibrant, sharp, and full of energy.',
      backgroundColor: Color(0xFFFFF3E0),
      accentColor: AppColors.primary,
    ),
    OnboardingPageData(
      emoji: '🧠',
      title: 'Keep your mind\nsharp & playful',
      subtitle:
          'Fun daily brain games and reads designed to keep you curious, focused, and engaged.',
      backgroundColor: Color(0xFFE8F5E9),
      accentColor: AppColors.secondary,
    ),
    OnboardingPageData(
      emoji: '✨',
      title: 'Your best years\nare right now',
      subtitle:
          'Build habits that make you feel younger every single day — it only takes a few minutes.',
      backgroundColor: Color(0xFFFFFDE7),
      accentColor: AppColors.accent,
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _onSkip() {
    _finishOnboarding();
  }

  Future<void> _finishOnboarding() async {
    await PrefsHelper.setOnboardingComplete();
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const MainShell()));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button row
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: AnimatedOpacity(
                  opacity: isLastPage ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: TextButton(
                    onPressed: isLastPage ? null : _onSkip,
                    child: const Text('Skip'),
                  ),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(data: _pages[index]);
                },
              ),
            ),

            // Bottom area — indicators + button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _buildDot(index),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Next / Get started button
                  PrimaryButton(
                    label: isLastPage ? 'Get Started' : 'Next',
                    onPressed: _onNext,
                    backgroundColor: _pages[_currentPage].accentColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    final bool isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? _pages[_currentPage].accentColor : AppColors.textHint,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
