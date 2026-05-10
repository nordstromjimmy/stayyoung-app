import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class GameMemorisePhase extends StatefulWidget {
  final List<String> words;
  final VoidCallback onComplete;

  const GameMemorisePhase({
    super.key,
    required this.words,
    required this.onComplete,
  });

  @override
  State<GameMemorisePhase> createState() => _GameMemorisePhaseState();
}

class _GameMemorisePhaseState extends State<GameMemorisePhase>
    with SingleTickerProviderStateMixin {
  static const int _totalSeconds = 5;
  int _secondsLeft = _totalSeconds;
  Timer? _timer;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation on the timer number
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        widget.onComplete();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = _secondsLeft / _totalSeconds;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Memorise these words', style: AppTextStyles.headingMedium),

          const SizedBox(height: 4),

          Text(
            'Hold as many as you can in your mind.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 24),

          // Countdown timer
          Center(
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Text(
                '$_secondsLeft',
                style: AppTextStyles.displayLarge.copyWith(
                  color: _secondsLeft <= 2
                      ? AppColors.error
                      : AppColors.primary,
                  fontSize: 72,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(
                _secondsLeft <= 2 ? AppColors.error : AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Word chips
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceWarm,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: widget.words.map((word) {
                return _WordChip(word: word);
              }).toList(),
            ),
          ),

          const Spacer(),

          Center(
            child: Text(
              'Words disappear when the timer ends',
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single word chip ───────────────────────────────────────────
class _WordChip extends StatelessWidget {
  final String word;

  const _WordChip({required this.word});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        word,
        style: AppTextStyles.labelMedium.copyWith(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }
}
