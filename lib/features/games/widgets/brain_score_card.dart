import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/brain_score_helper.dart';

class BrainScoreCard extends StatefulWidget {
  const BrainScoreCard({super.key});

  @override
  State<BrainScoreCard> createState() => _BrainScoreCardState();
}

class _BrainScoreCardState extends State<BrainScoreCard>
    with SingleTickerProviderStateMixin {
  int _score = 0;
  int _gamesPlayed = 0;
  bool _isLoading = true;

  late AnimationController _controller;
  late Animation<double> _barAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _barAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _loadScore();
  }

  Future<void> _loadScore() async {
    final score = await BrainScoreHelper.getBrainScore();
    final played = await BrainScoreHelper.getGamesPlayed();
    if (!mounted) return;
    setState(() {
      _score = score;
      _gamesPlayed = played;
      _isLoading = false;
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _scoreLabel {
    if (_score >= 150) return 'Elite memory 🏆';
    if (_score >= 100) return 'Sharp mind 🌟';
    if (_score >= 60) return 'Getting stronger 💪';
    if (_score >= 20) return 'Building up 🌱';
    return 'Just getting started ✨';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: _isLoading ? _buildSkeleton() : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Row(
      children: [
        // Score number
        Text(
          '$_score',
          style: AppTextStyles.displayLarge.copyWith(
            fontSize: 56,
            color: Colors.white,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),

        const SizedBox(width: 16),

        // Info side
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Brain score',
                style: AppTextStyles.headingSmall.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                _scoreLabel,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white.withOpacity(0.75),
                ),
              ),

              const SizedBox(height: 10),

              // Animated progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: AnimatedBuilder(
                  animation: _barAnimation,
                  builder: (context, _) {
                    return LinearProgressIndicator(
                      value: (_score % 10) / 10 * _barAnimation.value,
                      minHeight: 6,
                      backgroundColor: Colors.white.withOpacity(0.25),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 6),
              Text(
                '$_gamesPlayed ${_gamesPlayed == 1 ? 'game' : 'games'} played',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Shown while score loads from prefs
  Widget _buildSkeleton() {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
