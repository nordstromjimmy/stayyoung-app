import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/brain_score_card.dart';
import '../widgets/game_list_card.dart';
import 'word_recall_screen.dart';

enum GameCategory { all, memory, focus, language }

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  GameCategory _selectedCategory = GameCategory.all;
  int _scoreRefreshKey = 0;

  final List<GameListCardData> _games = [
    GameListCardData(
      emoji: '🧩',
      title: 'Word recall',
      subtitle: 'Memorise & remember 6 words',
      category: GameCategory.memory,
      categoryLabel: 'Memory',
      categoryColor: Color(0xFFFFF3E0),
      categoryTextColor: Color(0xFFE64A19),
      iconBackground: Color(0xFFFFF3E0),
      isAvailable: true,
    ),
    GameListCardData(
      emoji: '🔢',
      title: 'Number patterns',
      subtitle: 'Spot the sequence in a series',
      category: GameCategory.focus,
      categoryLabel: 'Focus',
      categoryColor: Color(0xFFE8F5E9),
      categoryTextColor: Color(0xFF388E3C),
      iconBackground: Color(0xFFE8F5E9),
      isAvailable: false,
    ),
    GameListCardData(
      emoji: '🔤',
      title: 'Word scramble',
      subtitle: 'Unscramble the letters fast',
      category: GameCategory.language,
      categoryLabel: 'Language',
      categoryColor: Color(0xFFEDE7F6),
      categoryTextColor: Color(0xFF512DA8),
      iconBackground: Color(0xFFEDE7F6),
      isAvailable: false,
    ),
    GameListCardData(
      emoji: '🎨',
      title: 'Colour match',
      subtitle: 'Match the colour not the word',
      category: GameCategory.focus,
      categoryLabel: 'Focus',
      categoryColor: Color(0xFFE8F5E9),
      categoryTextColor: Color(0xFF388E3C),
      iconBackground: Color(0xFFE3F2FD),
      isAvailable: false,
    ),
    GameListCardData(
      emoji: '💬',
      title: 'Word association',
      subtitle: 'How fast can you connect words?',
      category: GameCategory.language,
      categoryLabel: 'Language',
      categoryColor: Color(0xFFEDE7F6),
      categoryTextColor: Color(0xFF512DA8),
      iconBackground: Color(0xFFEDE7F6),
      isAvailable: false,
    ),
  ];

  List<GameListCardData> get _filteredGames {
    if (_selectedCategory == GameCategory.all) return _games;
    return _games.where((g) => g.category == _selectedCategory).toList();
  }

  Future<void> _onGameTap(GameListCardData game) async {
    if (!game.isAvailable) return;
    if (game.title == 'Word recall') {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const WordRecallScreen()));
      // Rebuild the score card with a new key so it reloads from prefs
      setState(() => _scoreRefreshKey++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily training',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Brain games 🧠',
                      style: AppTextStyles.displayMedium.copyWith(fontSize: 26),
                    ),
                  ],
                ),
              ),
            ),

            // Brain score card
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: BrainScoreCard(key: ValueKey(_scoreRefreshKey)),
              ),
            ),

            // Category filter chips
            SliverToBoxAdapter(child: _buildFilterRow()),

            // Available now label
            SliverToBoxAdapter(child: _buildSectionLabel('Available now')),

            // Available games
            SliverList(
              delegate: SliverChildListDelegate(
                _filteredGames
                    .where((g) => g.isAvailable)
                    .map(
                      (g) => Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: GameListCard(
                          data: g,
                          onTap: () => _onGameTap(g),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            // Coming soon label — only if there are locked games in filter
            if (_filteredGames.any((g) => !g.isAvailable))
              SliverToBoxAdapter(child: _buildSectionLabel('Coming soon')),

            // Coming soon games
            SliverList(
              delegate: SliverChildListDelegate(
                _filteredGames
                    .where((g) => !g.isAvailable)
                    .map(
                      (g) => Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: GameListCard(
                          data: g,
                          onTap: () => _onGameTap(g),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  // ── Filter chips row ───────────────────────────────────────
  Widget _buildFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            isActive: _selectedCategory == GameCategory.all,
            onTap: () => setState(() => _selectedCategory = GameCategory.all),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Memory',
            isActive: _selectedCategory == GameCategory.memory,
            onTap: () =>
                setState(() => _selectedCategory = GameCategory.memory),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Focus',
            isActive: _selectedCategory == GameCategory.focus,
            onTap: () => setState(() => _selectedCategory = GameCategory.focus),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Language',
            isActive: _selectedCategory == GameCategory.language,
            onTap: () =>
                setState(() => _selectedCategory = GameCategory.language),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
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

// ── Filter chip ────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.divider,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: isActive ? Colors.white : AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
