import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class HabitItem {
  final String emoji;
  final String label;
  final Color color;
  bool isDone;

  HabitItem({
    required this.emoji,
    required this.label,
    required this.color,
    this.isDone = false,
  });
}

class HabitRow extends StatefulWidget {
  const HabitRow({super.key});

  @override
  State<HabitRow> createState() => _HabitRowState();
}

class _HabitRowState extends State<HabitRow> {
  final List<HabitItem> _habits = [
    HabitItem(emoji: '💧', label: 'Hydrate', color: const Color(0xFFE3F2FD)),
    HabitItem(emoji: '🚶', label: 'Walk', color: const Color(0xFFFFF3E0)),
    HabitItem(emoji: '🧘', label: 'Breathe', color: const Color(0xFFE8F5E9)),
    HabitItem(emoji: '📖', label: 'Read', color: const Color(0xFFFCE4EC)),
  ];

  void _toggleHabit(int index) {
    setState(() {
      _habits[index].isDone = !_habits[index].isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(_habits.length, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index < _habits.length - 1 ? 10 : 0,
              ),
              child: _HabitCard(
                item: _habits[index],
                onTap: () => _toggleHabit(index),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Single habit card ──────────────────────────────────────────
class _HabitCard extends StatelessWidget {
  final HabitItem item;
  final VoidCallback onTap;

  const _HabitCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: item.isDone ? AppColors.secondary : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: item.isDone ? AppColors.secondary : AppColors.divider,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emoji
            Text(item.emoji, style: const TextStyle(fontSize: 26)),

            const SizedBox(height: 8),

            // Label
            Text(
              item.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: item.isDone ? Colors.white : AppColors.textSecondary,
                fontSize: 11,
              ),
            ),

            const SizedBox(height: 8),

            // Check indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: item.isDone ? Colors.white.withOpacity(0.3) : item.color,
                shape: BoxShape.circle,
              ),
              child: item.isDone
                  ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
