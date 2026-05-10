import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/primary_button.dart';

class GameResultPhase extends StatefulWidget {
  final List<String> targetWords;
  final Set<String> selectedWords;
  final int correctCount;
  final int wrongCount;
  final int missedCount;
  final VoidCallback onPlayAgain;
  final VoidCallback onHome;

  const GameResultPhase({
    super.key,
    required this.targetWords,
    required this.selectedWords,
    required this.correctCount,
    required this.wrongCount,
    required this.missedCount,
    required this.onPlayAgain,
    required this.onHome,
  });

  @override
  State<GameResultPhase> createState() => _GameResultPhaseState();
}

class _GameResultPhaseState extends State<GameResultPhase>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────
  String get _encouragement {
    final int total = widget.targetWords.length;
    final int correct = widget.correctCount;
    if (correct == total) return 'Perfect score! 🏆';
    if (correct >= total - 1) return 'Almost perfect! 🌟';
    if (correct >= total ~/ 2) return 'Great memory! 🎉';
    return 'Keep practising! 💪';
  }

  bool _wasSelected(String word) => widget.selectedWords.contains(word);
  bool _isTarget(String word) => widget.targetWords.contains(word);

  // A word is correct if it was a target AND selected
  bool _isCorrect(String word) => _isTarget(word) && _wasSelected(word);

  // A word is missed if it was a target but NOT selected
  bool _isMissed(String word) => _isTarget(word) && !_wasSelected(word);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score hero
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  children: [
                    Text(
                      '${widget.correctCount}/${widget.targetWords.length}',
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 64,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      _encouragement,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Stat row
            Row(
              children: [
                _StatCard(
                  value: widget.correctCount,
                  label: 'Correct',
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 10),
                _StatCard(
                  value: widget.missedCount,
                  label: 'Missed',
                  color: AppColors.accent,
                ),
                const SizedBox(width: 10),
                _StatCard(
                  value: widget.wrongCount,
                  label: 'Wrong picks',
                  color: AppColors.error,
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Word breakdown
            Text('Word breakdown', style: AppTextStyles.headingSmall),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.targetWords.map((word) {
                return _ResultChip(
                  word: word,
                  isCorrect: _isCorrect(word),
                  isMissed: _isMissed(word),
                );
              }).toList(),
            ),

            // Wrong picks section — only shown if user tapped wrong words
            if (widget.wrongCount > 0) ...[
              const SizedBox(height: 20),
              Text('Wrong picks', style: AppTextStyles.headingSmall),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.selectedWords
                    .where((w) => !_isTarget(w))
                    .map(
                      (word) => _ResultChip(
                        word: word,
                        isCorrect: false,
                        isMissed: false,
                        isWrong: true,
                      ),
                    )
                    .toList(),
              ),
            ],

            const SizedBox(height: 32),

            // Play again
            PrimaryButton(label: 'Play again', onPressed: widget.onPlayAgain),

            const SizedBox(height: 12),

            // Back to home
            PrimaryButton(
              label: 'Back to home',
              onPressed: widget.onHome,
              backgroundColor: AppColors.surfaceWarm,
              textColor: AppColors.primaryDark,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stat card ──────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final int value;
  final String label;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: AppTextStyles.displayMedium.copyWith(
                fontSize: 26,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Result chip ────────────────────────────────────────────────
class _ResultChip extends StatelessWidget {
  final String word;
  final bool isCorrect;
  final bool isMissed;
  final bool isWrong;

  const _ResultChip({
    required this.word,
    required this.isCorrect,
    this.isMissed = false,
    this.isWrong = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isCorrect
        ? AppColors.secondary.withOpacity(0.1)
        : isMissed
        ? AppColors.accent.withOpacity(0.1)
        : AppColors.error.withOpacity(0.1);

    final Color borderColor = isCorrect
        ? AppColors.secondary
        : isMissed
        ? AppColors.accent
        : AppColors.error;

    final String suffix = isCorrect
        ? ' ✓'
        : isMissed
        ? ' ○'
        : ' ✗';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withOpacity(0.4), width: 1),
      ),
      child: Text(
        '$word$suffix',
        style: AppTextStyles.labelMedium.copyWith(
          color: borderColor,
          fontSize: 13,
        ),
      ),
    );
  }
}
