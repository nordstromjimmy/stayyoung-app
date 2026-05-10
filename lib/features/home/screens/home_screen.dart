import 'package:flutter/material.dart';
import 'package:stayyoung/core/utils/prefs_helper.dart';
import '../widgets/greeting_header.dart';
import '../widgets/quiz_banner_card.dart';
import '../widgets/habit_row.dart';
import '../widgets/game_card.dart';
import '../widgets/read_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _quizComplete = false;
  bool _quizDismissed = false;

  @override
  void initState() {
    super.initState();
    _checkQuizStatus();
  }

  Future<void> _checkQuizStatus() async {
    final complete = await PrefsHelper.isQuizComplete();
    final dismissed = await PrefsHelper.isQuizDismissed();
    if (mounted) {
      setState(() {
        _quizComplete = complete;
        _quizDismissed = dismissed;
      });
    }
  }

  Future<void> _onQuizDismissed() async {
    await PrefsHelper.setQuizDismissed();
    if (mounted) setState(() => _quizDismissed = true);
  }

  void _onQuizCompleted() {
    setState(() => _quizComplete = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Greeting
            const SliverToBoxAdapter(child: GreetingHeader()),

            // Quiz banner — hidden once complete
            if (!_quizComplete && !_quizDismissed)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: QuizBannerCard(
                    onQuizCompleted: _onQuizCompleted,
                    onDismissed: _onQuizDismissed,
                  ),
                ),
              ),

            // Today's habits
            SliverToBoxAdapter(child: _SectionLabel(label: "Today's habits")),
            const SliverToBoxAdapter(child: HabitRow()),

            // Brain games
            SliverToBoxAdapter(child: _SectionLabel(label: 'Brain games')),
            SliverList(
              delegate: SliverChildListDelegate([
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: GameCard(
                    emoji: '🧩',
                    title: 'Word recall',
                    subtitle: '2 min · Memory',
                    backgroundColor: Color(0xFFFFF3E0),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: GameCard(
                    emoji: '🔢',
                    title: 'Number patterns',
                    subtitle: '3 min · Focus',
                    backgroundColor: Color(0xFFE8F5E9),
                  ),
                ),
              ]),
            ),

            // Today's read
            SliverToBoxAdapter(child: _SectionLabel(label: "Today's read")),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: ReadCard(
                  emoji: '🌿',
                  title: '5 foods that keep your brain sharp after 40',
                  duration: '3 min read',
                  category: 'Nutrition',
                  backgroundColor: Color(0xFFFFF3E0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable section label ─────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFFBDBDBD),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
