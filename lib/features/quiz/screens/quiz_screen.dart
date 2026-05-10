import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/prefs_helper.dart';
import '../../../shared/widgets/primary_button.dart';
import '../models/quiz_model.dart';
import '../widgets/quiz_step_widget.dart';
import '../widgets/quiz_option_tile.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isSaving = false;

  // Holds the user's selections as they go
  String? _selectedAgeRange;
  String? _selectedGoal;
  String? _selectedActivity;

  // ── Step definitions ───────────────────────────────────────
  final List<QuizStepData> _steps = const [
    QuizStepData(
      emoji: '🎂',
      title: 'How old are you?',
      subtitle: 'We\'ll tailor your content to suit your stage of life.',
      options: [
        QuizOption(value: '30s', label: 'In my 30s', emoji: '⚡'),
        QuizOption(value: '40s', label: 'In my 40s', emoji: '🌱'),
        QuizOption(value: '50s', label: 'In my 50s', emoji: '🌟'),
        QuizOption(value: '60+', label: '60 and beyond', emoji: '🏆'),
      ],
    ),
    QuizStepData(
      emoji: '🎯',
      title: 'What\'s your main goal?',
      subtitle: 'Pick the one that matters most to you right now.',
      options: [
        QuizOption(value: 'mind', label: 'Keep my mind sharp', emoji: '🧠'),
        QuizOption(value: 'body', label: 'Stay active & fit', emoji: '🏃'),
        QuizOption(value: 'balance', label: 'Find more balance', emoji: '🧘'),
      ],
    ),
    QuizStepData(
      emoji: '🏃',
      title: 'How active are you?',
      subtitle: 'Be honest — we\'re here to help, not judge!',
      options: [
        QuizOption(value: 'low', label: 'Just getting started', emoji: '🐢'),
        QuizOption(value: 'medium', label: 'Fairly active', emoji: '🚶'),
        QuizOption(value: 'high', label: 'Very active', emoji: '🔥'),
      ],
    ),
  ];

  // ── Helpers ────────────────────────────────────────────────
  String? get _currentSelection {
    switch (_currentStep) {
      case 0:
        return _selectedAgeRange;
      case 1:
        return _selectedGoal;
      case 2:
        return _selectedActivity;
      default:
        return null;
    }
  }

  void _onOptionSelected(String value) {
    setState(() {
      switch (_currentStep) {
        case 0:
          _selectedAgeRange = value;
          break;
        case 1:
          _selectedGoal = value;
          break;
        case 2:
          _selectedActivity = value;
          break;
      }
    });
  }

  bool get _canAdvance => _currentSelection != null;
  bool get _isLastStep => _currentStep == _steps.length - 1;

  void _onNext() {
    if (!_canAdvance) return;
    if (_isLastStep) {
      _saveAndFinish();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onBack() {
    if (_currentStep == 0) {
      Navigator.of(context).pop();
    } else {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _saveAndFinish() async {
    setState(() => _isSaving = true);
    final answers = QuizAnswers(
      ageRange: _selectedAgeRange!,
      goal: _selectedGoal!,
      activityLevel: _selectedActivity!,
    );
    await PrefsHelper.saveQuizAnswers(answers);
    if (!mounted) return;
    Navigator.of(context).pop(true); // true = quiz was completed
  }

  // ── Build ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildProgressBar(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentStep = i),
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return QuizStepWidget(
                    data: _steps[index],
                    selectedValue: index == 0
                        ? _selectedAgeRange
                        : index == 1
                        ? _selectedGoal
                        : _selectedActivity,
                    onOptionSelected: _onOptionSelected,
                  );
                },
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ── Top bar with back + step counter ──────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: _onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.textPrimary,
          ),
          const Spacer(),
          Text(
            'Step ${_currentStep + 1} of ${_steps.length}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Animated progress bar ──────────────────────────────────
  Widget _buildProgressBar() {
    final double progress = (_currentStep + 1) / _steps.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: progress,
          minHeight: 6,
          backgroundColor: AppColors.divider,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );
  }

  // ── Bottom bar with next button ────────────────────────────
  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: AnimatedOpacity(
        opacity: _canAdvance ? 1.0 : 0.4,
        duration: const Duration(milliseconds: 200),
        child: PrimaryButton(
          label: _isLastStep ? 'Finish & personalise' : 'Next',
          onPressed: _canAdvance ? _onNext : () {},
          isLoading: _isSaving,
        ),
      ),
    );
  }
}
